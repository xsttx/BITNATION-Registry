pragma solidity ^0.4.4;

contract DecisionPool {
	uint public nbProposals;
	Proposal[] public allProposals;

	uint public debatingPeriod;
	uint public minimumApproval;

	struct Proposal {
		address author;

		address recipient;
		uint amount;
		bytes32 hash;

		string description;
		string tag;

		uint waitingWindow;
		
		bool executed;
		bool triggered;

		uint nbVotes;
		Vote[] allVotes;
		mapping (address => uint) allVoteID;

		int approval;
	}

	struct Vote {
		address voter;
		bool inSupport;
		string comment;
	}

	event NewProposal(uint proposalID, address recipient, uint amount, string description, address author);
	event ProposalTallied(uint id, int result, bool passed);
	event VoteChanged(uint proposalID, address voter, bool support, string comment);
	event ChangeOfRules(uint debatingPeriod, uint minimumApproval);

	function changeRules(uint debatingPeriod, uint minimumApproval);

	function newProposal(address to, uint amount, string description, string tag, bytes txBytecode) returns (uint ProposalID);
	function executeProposal(address proposalID, bytes txBytecode) returns (bool proposalPassed);
	function checkProposalHash(uint proposalID, bytes txBytecode) constant returns (bool isHashValid) {
		Proposal p = allProposals[proposalID];
		return p.hash == sha3(p.recipient, p.amount, txBytecode);
	}

	function vote(uint proposalID, bool support, string justification) returns (uint VoteID);
	function getVote(uint VoteID) returns (address voter, bool inSupport, string comment); 
}
