pragma solidity ^0.7.3;

/**
@dev Allows 2 approved addresses to send ETH from this account
*/
contract doublesig{
  event PaymentInitiation(address to, uint amount);
  event contractDeposit(uint amount);
  
  
  struct proposal {
    address payable to;
    uint amount;
    bool approved;
  }

  mapping(uint => proposal) public proposals;
    
  address public approver;
  address public admin;

  mapping(address => bool) public approved;

  uint counter = 0;

  constructor(){
    admin = msg.sender;
  }

  modifier onlyApproved(){
    require(
      approver==msg.sender || admin ==msg.sender,
      "only approved users can call this."  
    );
    _;
  }


  function changeApprover(address _approver) public onlyApproved(){
    approver = _approver;
  }


  
  function attemptTransfer(uint id) public onlyApproved(){
    require(proposals[id].approved = true);
    _transfer(proposals[id].to, proposals[id].amount);
  }

  function deposit() payable public returns (bool) {
    emit contractDeposit(msg.value);
    return true;
  }

  function createProposal(address payable _to, uint _amount) public onlyApproved(){
    require(address(this).balance>_amount, "Cannot propose an amount greater than contract balance");
    // add a new proposal to proposals array
    // proposals.push(newProposal);   

        // By default the proposer has to approve this proposal
    proposal memory newProposal = proposal(_to, _amount, false);
    proposals[counter] = newProposal;
    counter++;
    emit PaymentInitiation(_to, _amount);
  }

  function _transfer(address payable _to, uint _amount) internal{
    (bool success,) = _to.call{value: _amount}("");
    require(success, "Failed to send Ether");
  }

  function approveTransaction(uint id) public onlyApproved(){
    proposals[id].approved=true;
  }

  function rejectTransaction(uint id) public onlyApproved(){
    proposals[id].approved=false;
  }

/**
 * @dev returns the balance of this smart contract
 **/
  function getBalance() external view returns (uint){
    return address(this).balance;
  }

}
