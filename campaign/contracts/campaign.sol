pragma solidity ^0.4.17;

contract Campaign {
    
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint256 public minimumContribution;
    uint256 public approversCount;    
    mapping(address => bool) public approvers;
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint256 _minimumContribution, address creator) public {
        manager = creator;
        minimumContribution = _minimumContribution;
    }
    
    function contribute() external payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string _description, uint256 _value, address _recipient) external restricted {
        Request memory newRequest = Request({
            description: _description,
            value: _value,
            recipient: _recipient,
            complete: false,
            approvalCount: 0
        });
        requests.push(newRequest);
    }

    function approveRequest(uint256 index) public {
        Request storage request = requests[index];
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender], "User has not yet voted for the reques");
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint256 index) public restricted {
        Request storage request = requests[index];
        require(request.approvalCount > approversCount/2);
        require(!request.complete);   
        request.recipient.transfer(request.value);
        request.complete = true;

    }
}