pragma solidity ^0.8.19;

struct Name {
    string name;
    address resolvee;
    bool exists;
    address resolver;
}
