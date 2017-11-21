pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/token/MintableToken.sol';
import '../node_modules/zeppelin-solidity/contracts/token/PausableToken.sol';
import '../node_modules/zeppelin-solidity/contracts/token/BurnableToken.sol';

/**
 * @title ModulumToken
 * @dev ModulumToken is ERC20-compilant, mintable, pausable and burnable.
 */
contract ModulumToken is MintableToken, PausableToken, BurnableToken {

  // Token information
  string public name = "Modulum Token";
  string public symbol = "MDL";
  uint256 public decimals = 18;

  /**
   * @dev Contructor
   */
  function ModulumToken() {
  }
}