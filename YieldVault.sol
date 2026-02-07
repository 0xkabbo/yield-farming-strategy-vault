// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YieldVault is ERC20, ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable asset;

    constructor(address _asset) 
        ERC20("Vault Asset Share", "vASSET") 
        Ownable(msg.sender) 
    {
        asset = IERC20(_asset);
    }

    /**
     * @notice Returns the total assets managed by the vault.
     */
    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    /**
     * @notice Deposit assets and receive shares.
     */
    function deposit(uint256 _amount) external nonReentrant {
        uint256 total = totalAssets();
        uint256 supply = totalSupply();

        asset.safeTransferFrom(msg.sender, address(this), _amount);

        uint256 shares;
        if (supply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * supply) / total;
        }

        _mint(msg.sender, shares);
    }

    /**
     * @notice Withdraw assets by burning shares.
     */
    function withdraw(uint256 _shares) external nonReentrant {
        uint256 total = totalAssets();
        uint256 supply = totalSupply();
        uint256 amount = (_shares * total) / supply;

        _burn(msg.sender, _shares);
        asset.safeTransfer(msg.sender, amount);
    }

    /**
     * @notice Helper to calculate the value of 1 share in underlying assets.
     */
    function getPricePerFullShare() public view returns (uint256) {
        if (totalSupply() == 0) return 1e18;
        return (totalAssets() * 1e18) / totalSupply();
    }
}
