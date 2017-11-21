pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol';
import '../node_modules/zeppelin-solidity/contracts/token/SafeERC20.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title ModulumTokenHolder
 * @dev ModulumTokenHolder is a smart contract which purpose is to hold and lock
 * HTO's token supply for 1.5years following Modulum ICO
 * 
*/
contract ModulumTokenHolder is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for ERC20Basic;

  event Released(uint256 amount);

  // beneficiary of tokens after they are released
  address public beneficiary;

  // Lock start date
  uint256 public start;
  // Lock period
  uint256 constant public DURATION = 547 days;

  /**
   * @dev Contructor
   */
  function ModulumTokenHolder(address _beneficiary, uint256 _start) {
    require(_beneficiary != address(0));

    beneficiary = _beneficiary;
    start = _start;
  }

  /**
   * @dev Release MDL tokens held by this smart contract only after the timelock period
   */
  function releaseHTOSupply(ERC20Basic token) onlyOwner public {
    require(now >= start.add(DURATION));
    require(token.balanceOf(this) > 0);
    uint256 releasable = token.balanceOf(this);

    token.safeTransfer(beneficiary, releasable);

    Released(releasable);
  }
}
