pragma solidity >=0.8.0;

// import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable as Ownable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {NumberUtils} from "../Other/NumberUtilities.sol";
import {Router} from "../Other/solidlyrouter.sol";

interface TarotRouter {
    function mintETH(
        address poolToken,
        address to,
        uint256 deadline
    ) external payable returns (uint256 tokens);

    function redeemETH(
        address poolToken,
        uint256 tokens,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external returns (uint256 amountETH);
}

interface IBorrowable is IERC20 {
    function exchangeRate() external returns (uint256);
}

contract AirdropHandler is Ownable {
    ERC20 rave;
    uint amount;
    bytes32 root;
    address constant treasury = 0x87f385d152944689f92Ed523e9e5E9Bd58Ea62ef;
    uint claimLimit;

    uint factor = uint(95) / uint(100);

    using NumberUtils for uint256;

    address poolToken;
    TarotRouter router;
    uint totalLocked = 0;

    event StartLock(address indexed account, uint amount);
    event PoolMigration(address oldPool, address indexed newPool);

    struct Lock {
        uint unlockTime;
        uint amount;
        uint ftmUnlockTime;
        bool active;
        bool ftmMatched;
        uint lpDeposited;
        address lockerAddress;
    }

    mapping(address claimer => Lock lock) locks;
    mapping(address claimer => bool claimed) claimed;

    function initialize(
        address _rave,
        uint _amount,
        bytes32 _root,
        address tarotRouter,
        address _poolToken
    ) public initializer {
        __Ownable_init_unchained();
        rave = ERC20(_rave);
        amount = _amount;
        root = _root;
        router = TarotRouter(tarotRouter);
        poolToken = _poolToken;
        claimLimit = block.timestamp + 2.5 weeks;
    }

    function clamp(uint a, uint n, uint x) internal pure returns (uint) {
        return (a < n) ? n : (a > x) ? x : a;
    }

    function startLock(
        uint256 _amount,
        bytes32[] calldata merkleProof
    ) public payable {
        address account = msg.sender;

        require(block.timestamp < claimLimit, "You are too late lmfao");

        require(
            msg.value >= 10,
            "You need to lock 10 FTM to start an airdrop lock"
        );

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(account, _amount));
        require(MerkleProof.verify(merkleProof, root, node), "Invalid proof.");

        require(!claimed[account], "Already claimed.");

        claimed[account] = true;

        locks[account] = Lock({
            unlockTime: block.timestamp + 208 weeks,
            amount: clamp(_amount, 0, 200_000),
            ftmUnlockTime: block.timestamp + 104 weeks,
            active: true,
            ftmMatched: false,
            lpDeposited: 0,
            lockerAddress: address(0)
        });

        _update();
        totalLocked += 1;

        emit StartLock(account, amount);
    }

    function startLockWithFTMMatching(
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external payable {}

    function _update() internal {
        uint balance = address(this).balance;

        if (balance > 0) {
            uint sharesAdded = router.mintETH(
                poolToken,
                address(this),
                block.timestamp // should complete this block
            );
        }
    }

    function migrateTarotPool(address newPool) external onlyOwner {
        address oldPool = poolToken;
        poolToken = newPool;

        router.redeemETH(
            oldPool,
            IBorrowable(oldPool).balanceOf(address(this)),
            address(this),
            block.timestamp,
            bytes("")
        );

        _update();

        emit PoolMigration(oldPool, newPool);
    }

    function claimFTM() public {
        address account = msg.sender;

        require(
            block.timestamp >= locks[account].ftmUnlockTime ||
                msg.sender == owner(),
            "You cannot claim your FTM yet."
        );

        uint rate = IBorrowable(poolToken).exchangeRate();

        uint ftm = router.redeemETH(
            poolToken,
            (10 * 10 ** 18) * (rate / 10 ** 18),
            address(this),
            block.timestamp,
            bytes("")
        );

        (bool success, ) = account.call{value: 10}("");
        (bool successTreasury, ) = treasury.call{value: ftm - 10}("");

        require(success && successTreasury, "Transfer failed.");
    }

    function claimFees() external {
        uint rate = IBorrowable(poolToken).exchangeRate();
        uint depositedFTM = totalLocked * 10;
        uint balance = IBorrowable(poolToken).balanceOf(address(this));

        uint depositedAsShares = depositedFTM * rate;
        uint fees = balance - depositedAsShares;

        router.redeemETH(poolToken, fees, treasury, block.timestamp, bytes(""));
    }

    function claimRAVE() external {
        address account = msg.sender;

        require(
            block.timestamp >= locks[account].unlockTime ||
                msg.sender == owner(),
            "You cannot claim your RAVE yet."
        );
        require(locks[account].active, "This lock is inactive.");
        require(!locks[account].ftmMatched, "You have matched with FTM, please use the correct claim function.");

        claimFTM();

        rave.transferFrom(
            address(this),
            account,
            locks[account].amount.toDecimals(18) * factor
        );

        locks[account].active = false;
    }

    function lock(address owner) external view returns (Lock memory, bool) {
        return (locks[owner], claimed[owner]);
    }
}
