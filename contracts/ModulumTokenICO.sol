pragma solidity ^0.4.18;

import "./ModulumToken.sol";
import "./ModulumTokenHolder.sol";
import "./ModulumInvestorsWhitelist.sol";
import '../node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title ModulumTokenICO
 * @dev ModulumTokenICO is the crowdsale smart contract for Modulum ICO, it is capped and refundable.
 * 
*/
contract ModulumTokenICO is CappedCrowdsale, RefundableCrowdsale {
  using SafeMath for uint256;

  ModulumTokenHolder public tokenHolder;
  ModulumInvestorsWhitelist public whitelist;
  
  /**
   * @dev Contructor
   */
  function ModulumTokenICO(
    uint256 _startTime, 
    uint256 _endTime, 
    uint256 _rate, 
    uint256 _goal, 
    uint256 _cap, 
    address _wallet, 
    ModulumTokenHolder _tokenHolder, 
    ModulumInvestorsWhitelist _whitelist)
      CappedCrowdsale(_cap)
      FinalizableCrowdsale()
      RefundableCrowdsale(_rate)
      Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    //As goal needs to be met for a successful crowdsale
    //the value needs to be less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);    

    //Store other smart contract addresses related to this ICO 
    tokenHolder = _tokenHolder;
    whitelist = _whitelist;

    //Mint HTO's tokens supply to the timelocked smart contract (1.5years)
    token.mint(address(tokenHolder), 8775000 ether);
    //Mint the stakeholders tokens supply immediately available for
    //the HTO to distribute as rewards
    token.mint(_wallet, 3510000 ether);
  }

  function createTokenContract() internal returns (MintableToken) {
    return new ModulumToken();
  }

  // overriding Crowdsale#validPurchase to add extra logic
  // @return true if investors can buy at the moment
  function validPurchase() internal constant returns (bool) {
    // Only accept transfers above 0.2 ETH
    bool aboveMinTransfer = msg.value >= (20 ether / 100);
    // Only accept transfers from inverstor in the whitelist
    bool inWhitelist = whitelist.isInvestorInWhitelist(msg.sender);
    return super.validPurchase() && aboveMinTransfer && inWhitelist;
  }

  // overriding Crowdsale#buyTokens to add a dynamic rate 
  // that will match bonus token rewards
  function buyTokens(address beneficiary) public payable {
    if (weiRaised < 7000 ether) {
      rate = 450;
    } else if (weiRaised < 17000 ether) {
      rate = 360;
    } else if (weiRaised < 34000 ether) {
      rate = 330;
    } else if (weiRaised < 51000 ether) {
      rate = 315;
    } else {
      rate = 300;
    }
    return super.buyTokens(beneficiary);
  }

  // overriding FinalizableCrowdsale#finalization to prevent further  
  // minting after ICO end
  function finalization() internal {
    token.finishMinting();
    super.finalization();
  }
}