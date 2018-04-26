pragma solidity ^0.4.17;

contract Campaign {
    
    struct Request {
       string description;
       uint256 value;
       address recipient;
       bool complete;
    }
    
    Request[] public requests;
    address public manager;
    uint256 minimumContribution;
    address[] public approvers;
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
    
    
    function Campaign(uint256 _minimumContribution) external {
        manager = msg.sender;
        minimumContribution = _minimumContribution;
    }
    
    function contribute() external payable {
        require(msg.value > minimumContribution);
        approvers.push(msg.sender);
    }
    
    function createRequest(string _description, uint256 _value, address _recipient) external restricted {
        Request newRequest = Request({
           description: _description,
           value: _value,
           recipient: _recipient,
           complete: false
        });
        requests.push(newRequest);
    }
}