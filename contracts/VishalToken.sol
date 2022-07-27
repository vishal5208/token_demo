// SPDX-License-Identifier : MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract VishalToken is ERC20 {
    using SafeMath for uint256;

    uint256 public constant BASE_UNITS = 10**18;
    uint256 public constant INFLATION_ENABLE_DATE = 1551398400;
    uint256 public constant INITIAL_TOTAL_SUPPLY =
        uint256(93261300000000000000000);
    uint256 public constant YEARLY_MINTABLE_AMOUNT =
        uint256(30060000000000000000000);
    uint256 public constant MINTING_INTERVAL = 365 days;

    address public council;
    address public deployer;
    bool public initialSupplyMinted;
    uint256 public nextMinting = INFLATION_ENABLE_DATE;

    modifier onlyDeployer() {
        require(msg.sender == deployer, "Only deployer can call this.");
        _;
    }

    modifier onlyCouncil() {
        require(msg.sender == council, "Only council can call this.");
        _;
    }

    modifier anIntervalHasPassed() {
        require(
            block.timestamp >= uint256(nextMinting),
            "Please wait until an interval has passed."
        );
        _;
    }

    modifier inflationEnabled() {
        require(
            block.timestamp >= INFLATION_ENABLE_DATE,
            "Inflation is not enabled yet."
        );
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _council
    ) ERC20(_name, _symbol) {
        deployer = msg.sender;
        council = _council;
    }

    function changeCouncil(address _newCouncil) public onlyCouncil {
        council = _newCouncil;
    }

    function mintInitialSupply(address _initialReceiver) public onlyDeployer {
        require(!initialSupplyMinted, "Initial minting already complete");
        initialSupplyMinted = true;
        _mint(_initialReceiver, INITIAL_TOTAL_SUPPLY);
    }

    function mintInflation() public anIntervalHasPassed inflationEnabled {
        require(initialSupplyMinted, "Initial minting not complete");
        nextMinting = uint256(nextMinting).add(MINTING_INTERVAL);
        _mint(council, YEARLY_MINTABLE_AMOUNT);
    }
}
