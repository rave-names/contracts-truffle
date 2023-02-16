pragma solidity >=0.8.0;

// import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol"; we inherit this from ERC721Enumerable
import {OwnableUpgradeable as Ownable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721EnumerableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

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

contract AirdropHandler is Ownable, ERC721EnumerableUpgradeable {
    ERC20 rave;
    uint amount;
    bytes32 root;

    address poolToken;
    TarotRouter router;

    event StartLock(address indexed account, uint amount);
    event PoolMigration(address oldPool, address indexed newPool);

    struct Lock {
        uint unlockTime;
        uint amount;
        uint ftmUnlockTime;
    }

    mapping(address claimer => Lock lock) locks;
    mapping(address claimer => bool claimed) claimed;

    function initialize(
        address _rave,
        uint _amount,
        bytes32 _root,
        address tarotRouter
    ) public initializer {
        __Ownable_init_unchained();
        __ERC721Enumerable_init_unchained();
        rave = ERC20(_rave);
        amount = _amount;
        root = _root;
        router = TarotRouter(tarotRouter);
    }

    function startLock(
        uint256 amount,
        bytes32[] calldata merkleProof
    ) public payable {
        address account = msg.sender;

        require(
            msg.value >= 10,
            "You need to lock 10 FTM to start an airdrop lock"
        );

        if (msg.sender != owner()) {
            // 14th feb 2023
            require(block.timestamp > 1676329200, "Airdrop hasn't opened yet.");
            // 28th feb 2023
            require(block.timestamp < 1677538800, "Airdrop has closed.");
        }

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(account, amount));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, node),
            "Invalid proof."
        );

        require(!claimed[account], "Already claimed.");

        claimed[account] = true;

        locks[account] = Lock({
            unlockTime: block.timestamp + 208 weeks,
            amount: amount,
            ftmUnlockTime: block.timestamp + 104 weeks
        });

        _update();

        emit StartLock(account, amount);
    }

    function _update() internal {
        uint balance = address(this).balance;

        if (balance > 0) {
            router.mintETH(
                poolToken,
                address(this),
                block.timestamp // should complete this block
            );
        }
    }

    function migrateTarotPool(address newPool) external onlyOwner {
        oldPool = poolToken;
        poolToken = newPool;

        router.redeemETH(
            oldPool,
            ERC20(oldPool).balanceOf(address(this)),
            address(this),
            block.timestamp,
            bytes(0)
        );

        _update();

        emit PoolMigration(oldPool, newPool);
    }
}
