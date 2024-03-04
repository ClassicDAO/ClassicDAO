

// //set a countdown to genesiscountdown id, the unix start time is: 1709335406, in the format of X hours
{/* <div style="flex: 1;">Genesis Proposal</div>
                <div style="flex: 1;">1</div>
                <div style="flex: 1;">
                    <button style="width: auto; background-color: #2908df; color: #000; border: 2px solid #000; padding: 0px 10px; border-radius: 10px; font-size: 18px; font-family: GTWalsheim2, regular; cursor: pointer; height: 30px;" id="PropStatus" disabled>Debate</button>
                </div>
                <div style="flex: 1;">
                    <button style="width: auto; background-color: #ffffff; color: #000; border: 2px solid #000; padding: 0px 10px; border-radius: 10px; font-size: 18px; font-family: GTWalsheim2, regular; cursor: pointer; height: 30px;" disabled>SIMPLE</button>
                </div>
                <div id="genesiscountdown" style="flex: 1;"></div>
                <div style="flex: 1; display: flex; justify-content: flex-end;">
                    <a href="CurrentVote.html" style="text-decoration: none; color: inherit; outline: none;">
                    <button class="view_more_button" style="background-color: #16ECD3;">View more</button>             
                    </a>
                </div> */}


//Load the proposal queue and the proposal details for each proposal in the queue. Here are the details needed: ID, Status, ProposalInfo.ProposalType, VotingInstanceID, VotingInstance.Status, VotingInstance.CLDtoIncentive
async function LoadProposals() {
    let ProposalQueue = await DAOvoting.methods.GetVotingQueue().call();
    let ProposalQueueList = document.getElementById("ProposalQueueList");
    ProposalQueueList.innerHTML = "";
    for (let i = 0; i < ProposalQueue.length; i++) {
        let ProposalID = ProposalQueue[i];
        let ProposalInfo = await DAOvoting.methods.ProposalInfo(ProposalID).call();
        let VotingInstanceID = ProposalInfo.VotingInstanceID;
        let VotingInstance = await DAOvoting.methods.VotingInstances(VotingInstanceID).call();
        let Status = VotingInstance.Status;
        let CLDtoIncentive = web3.utils.fromWei(VotingInstance.CLDtoIncentive, 'ether');
        let ProposalType = ProposalInfo.ProposalType;
        let ProposalHTML = `
        <div style="display: flex; justify-content: space-between; align-items:center; padding: 16px 20px; border-bottom:1.81818px solid rgb(255, 255, 255); font-size:16px; color:rgb(255, 255, 255); box-sizing: border-box;">
            <div style="flex: 1;">Proposal ${ProposalID}</div>
            <div style="flex: 1;">${Status}</div>
            <div style="flex: 1;">${ProposalType}</div>
            <div style="flex: 1;">${VotingInstanceID}</div>
            <div style="flex: 1;">${Status}</div>
            <div style="flex: 1;">${CLDtoIncentive} CLD</div>
            <div style="flex: 1; display: flex; justify-content: flex-end;">
                <a href="CurrentVote.html" style="text-decoration: none; color: inherit; outline: none;">
                <button class="view_more_button" style="background-color: #16ECD3;">View more</button>             
                </a>
            </div>
        </div>
        `;
        ProposalQueueList.innerHTML += ProposalHTML;
    }
}
    