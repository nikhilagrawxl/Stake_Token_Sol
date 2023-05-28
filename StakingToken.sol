pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingToken is ERC20 {
    IERC20 private _token;
    mapping(address => uint256) private _stakes;

    event Staked(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    constructor(IERC20 token) ERC20("Staking Token", "STK") {
        _token = token;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(_token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        _stakes[msg.sender] += amount;
        _mint(msg.sender, amount);

        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= _stakes[msg.sender], "Insufficient staked amount");

        _stakes[msg.sender] -= amount;
        _burn(msg.sender, amount);
        require(_token.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function getStakedAmount(address account) public view returns (uint256) {
        return _stakes[account];
    }
}
