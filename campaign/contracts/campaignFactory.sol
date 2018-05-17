pragma solidity ^0.4.17;
import "./campaign.sol";

contract CampaignFactory {
    address[] deployedCampaigns;

    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() external view returns(address[]){
        return deployedCampaigns;
    }
}