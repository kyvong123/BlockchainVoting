pragma solidity ^0.4.22;



contract Ballot{ //Bỏ phiếu
    struct Voter{ //Người bỏ phiếu
        uint weight; //Trọng số: có quyền bỏ phiếu hay không?
        bool voted; //Đã bỏ phiếu chưa?
        address delegate; //Có ủy quyền lá phiếu cho ai không?
        uint vote; //Chỉ số (đối tượng được bầu) Voter bầu chọn
        uint check;
    }
    struct Proposal{ //Đối tượng được bầu chọn
        bytes32 name; //Tên đối tượng
        uint voteCount; //Lượt bầu chọn cho đối tượng
        uint index;
    } 
    address public chairperson; //Chủ tịch hồi đồng bỏ phiếu
    mapping (address=>Voter) public voters; //Tra cứu địa chỉ và Người bỏ phiếu 
    mapping (uint=>uint) public ids;
    Proposal[] public proposals; // danh sách các đối tượng được bầu chọn
   
    uint public proposalCount;
    uint public voterCount;
    uint public approvalCount;
    

    constructor(bytes32[] proposalNames, uint[] proposalIndexs) public{ //Khởi tạo n đối tượng được bầu chọn
        chairperson = msg.sender; // Chủ tịch hội đồng là người tạo ra cuộc bầu chọn
        voters[chairperson].weight=1; //Trọng số của ông chủ tịch là 1
        for(uint i=0; i<proposalNames.length; i++){ //Duyệt qua danh sách các đối tượng được bầu chọn
            proposals.push(Proposal({ //Thêm nó vào array các struct, với mỗi phần tử có tên và số lượt vote
                name: proposalNames[i],
                voteCount:0,
                index: proposalIndexs[i]
            }));
           
            ids[proposalIndexs[i]]=i;
            proposalCount++;
        }
    }
    
    function giveRightToVote(address voter) public{ //Trao quyền bầu chọn cho một voter
        require(msg.sender==chairperson); //Yêu cầu người trao quyền này là ông chủ tịch
        require(!voters[voter].voted); // yêu cầu ông voter này chưa bỏ phiếu lần nào 
        require(voters[voter].weight==0); // yêu cầu trọng số của ông voter này là 0
        voters[voter].weight=1; //Trọng số đặt là 1     
        approvalCount++;
        
    }
    
    function delegate(address _to) public{
        //Uỷ quyền cho ông "to"
        Voter storage sender=voters[msg.sender]; //Lưu ý, địa chỉ người ủy quyền phải lưu trữ trên blockchain
        require(!sender.voted); //Yêu cầu người ủy quyền chưa bỏ phiếu lần nào
        require(_to!=msg.sender); // Yêu cầu người được ủy quyền không phải là người ủy quyền
        while (voters[_to].delegate!=address(0)){ //Nếu người được ủy quyền đó có ủy quyền cho một người khác nữa
            _to=voters[_to].delegate; //Lúc này sẽ ủy quyền cho người khác nữa "được sự ủy quyền" từ "người được ủy quyền"
            require(_to!=msg.sender); //Yêu cầu "người nhận sự ủy quyền" này khác với "người ủy quyền ban đầu"
        }
        sender.voted=true; //Đánh dấu đã bỏ phiếu
        sender.delegate=_to; //Đánh dấu địa chỉ người được ủy quyền
        Voter storage delegate_ = voters[_to]; 
        if(delegate_.voted){ //Nếu người được ủy quyền này đã sử dụng số lượt bỏ phiếu của mình
            proposals[delegate_.vote].voteCount+=sender.weight; // thì proposal được ông này bầu chọn tăng thêm một lượng là trọng số của sender
        } else{
            delegate_.weight+=sender.weight; //ngược lại thì trọng số người được ủy quền tăng thêm một lượng là trọng số của sender
        }
    }
    
    function vote(uint proposal) public{ //Bỏ phiếu
        Voter storage sender = voters[msg.sender];
        require(!sender.voted); //Yêu cầu người này chưa bỏ phiếu lần nào
        if (sender.check==3){
        sender.voted=true;
        }
        //Đánh dấu đã bỏ phiếu
        sender.vote=proposal; //Đánh dấu bỏ phiếu cho proposal có chỉ số tương ứng  
        proposals[ids[proposal]].voteCount+=sender.weight;  //Tăng số lượt vote của proposal này
        voterCount++;
        sender.check++;
    
    }
    
    function winningProposal()public view returns (uint winningProposal_){ //Xem proposal chiến thắng
        uint winningVoteCount=0; 
        for(uint p=0; p<proposals.length; p++){ //Duyệt qua danh sách các proposal
            if (proposals[p].voteCount>winningVoteCount){ 
                winningVoteCount=proposals[p].voteCount;
                winningProposal_=p; //Tìm ra proposal tương ứng vị trí proposal p có số lượt vote cao nhất
            }
        }
    }
    
    function winnerName() public view returns(bytes32 winnerName_){ //Xem tên proposal chiến thắng
        winnerName_=proposals[winningProposal()].name;
    }

}