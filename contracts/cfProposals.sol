// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "hardhat/console.sol";

contract cfProposals is KeeperCompatibleInterface {
    using Counters for Counters.Counter;

    Counters.Counter private proposalIDs;
    Counters.Counter private activeProposals;

    struct proposal {
        uint256 proposalID;
        address proposalOwner;
        string title;
        string description;
        uint256 fundingGoal;
        uint256 fundsRaised;
        uint256 dateCreated;
        uint256 dueDate;
        uint256 dateCompleted;
        bool isActive;
        bool isVoting;
    }

    proposal[] proposals;

    mapping (uint256 => mapping(address => uint256)) propAddressToPledge;
    mapping (uint256 => Counters.Counter) propBackerCount;
    mapping (uint256 => address[]) propBackers;

    constructor() {
        console.log("It's....ALIVE!!!");
    }

    function addProposal(string memory title, string memory description, uint256 goal, uint256 dueDate) public {
        uint256 ID = proposalIDs.current();
        proposals.push(proposal({
            proposalID: ID,
            proposalOwner: msg.sender,
            title: title,
            description: description,
            fundingGoal: goal,
            fundsRaised: 0,
            dateCreated: block.timestamp,
            dueDate: dueDate,
            dateCompleted: 0,
            isActive: true ,
            isVoting: false
        }));

        proposalIDs.increment();
        activeProposals.increment();
    }

    function getProposal(uint256 index) public view returns(proposal memory) {
        return proposals[index];
    }

    function backProposal(uint256 index) public payable{
        require(msg.value == 0.0001 ether, "PAY MOAR"); //Equivalent to 100000000000000 Wei
        require(proposals[index].isActive, "This campaign is over!");
        proposal memory selected = proposals[index];

        if(selected.fundsRaised < selected.fundingGoal){
            proposals[index].fundsRaised = proposals[index].fundsRaised + msg.value;
            } else {
                console.log("Goal already met!");
            }
        if(propAddressToPledge[index][msg.sender] <= 0){
            propBackers[index].push(msg.sender);
            propBackerCount[index].increment();
            console.log("New Backer Added! Now there are %s Backers.", propBackerCount[index].current());
        } 

        propAddressToPledge[index][msg.sender] = propAddressToPledge[index][msg.sender] + msg.value;
    }

    function checkIfActive(uint256 index) public view returns(bool){
        proposal memory selected = proposals[index];
        return selected.isActive;
    }

    function toggleActive(uint256 index) public {
        proposal memory selected = proposals[index];
        uint256 currentTime = block.timestamp;
        if(currentTime >= selected.dueDate) {
            proposals[index].isActive = false;
            activeProposals.decrement();
            console.log("Proposal Closed");
        } else {
            console.log("There's still time!");
        }
    }

    function getActiveProposals() public view returns(uint256[] memory) {
        uint counter = 0;
        //proposal[] memory allActive = new proposal[](activeProposals.current());
        uint256 arrayLength = activeProposals.current();
        console.log(arrayLength);
        uint256[] memory allActive = new uint256[](arrayLength);
        
        for(uint i = 0; i  < proposals.length; i++) {/*
            proposal memory inQuestion = proposals[i];
            if(inQuestion.isActive){
                allActive[counter] = (proposal({
            proposalID: inQuestion.proposalID,
            proposalOwner: inQuestion.proposalOwner,
            title: inQuestion.title,
            description: inQuestion.description,
            fundingGoal: inQuestion.fundingGoal,
            fundsRaised: inQuestion.fundsRaised,
            dateCreated: inQuestion.dateCreated,
            dueDate: inQuestion.dueDate,
            dateCompleted: inQuestion.dateCompleted,
            isActive: inQuestion.isActive,
            isVoting: inQuestion.isVoting
        }));
        */
        proposal memory inQuestion = proposals[i];
        console.log("proposal Found");
            if(inQuestion.isActive){
                console.log("gonna do it");
                allActive[counter] = i;
                console.log("did it");
                console.log("counter incrememnted");
                counter++;
            }
            }
            console.log(allActive.length);
            return allActive;
        }

        function getActivePropDetails() public view returns(proposal[] memory){
            uint counter = 0;
            proposal[] memory allActive = new proposal[](activeProposals.current());
        
            for(uint i = 0; i  < proposals.length; i++) {
                proposal memory inQuestion = proposals[i];
                    if(inQuestion.isActive){
                        allActive[counter] = (proposal({
                    proposalID: inQuestion.proposalID,
                    proposalOwner: inQuestion.proposalOwner,
                    title: inQuestion.title,
                    description: inQuestion.description,
                    fundingGoal: inQuestion.fundingGoal,
                    fundsRaised: inQuestion.fundsRaised,
                    dateCreated: inQuestion.dateCreated,
                    dueDate: inQuestion.dueDate,
                    dateCompleted: inQuestion.dateCompleted,
                    isActive: inQuestion.isActive,
                    isVoting: inQuestion.isVoting
                    }));
                    counter++;
                }
            }

            return(allActive);
        }


    function checkUpkeep(bytes calldata) external override returns(bool upkeepNeeded, bytes memory) {
        upkeepNeeded = false;

        uint256[] memory allActive = getActiveProposals();

        for(uint i = 0; i < allActive.length; i++) {
            if(block.timestamp > proposals[allActive[i]].dueDate){
                upkeepNeeded = true;
            }
        }
        console.log("Done Checking for Upkeep.");
    }

    function performUpkeep(bytes calldata) external override {
        uint256[] memory allActive = getActiveProposals();
        for(uint i = 0; i < allActive.length; i++) {
            uint256 selected = allActive[i];
            toggleActive(selected);
        }
        console.log("Done Performing Upkeep.");
    }

}