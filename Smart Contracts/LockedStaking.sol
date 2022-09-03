//SPDX-License-Identifier:UNLICENSE
pragma solidity ^0.8.7;

contract LockedStaking{
    //Variable Declarations
    address CLD;
    address Operator;
    bool PreSaleListCompleted = false;

    //Array for each person
    mapping(address => Lock[]) public UserLocks;
    mapping(address => uint256) public ActiveLocks;
    mapping(address => bool) public PreSaleUser;
    mapping(uint8 => uint256) LockTypeTime;
    mapping(uint8 => uint256) LockTypeMultiplier;

    constructor(address _CLD){
        CLD = _CLD; 
        Operator = msg.sender;
        LockTypeTime[1] = 60;//30 Days 2592000
        LockTypeTime[2] = 60;
        LockTypeTime[3] = 60;//90 Days 7776000
        LockTypeTime[4] = 60;
        LockTypeTime[5] = 60;//180 Days 15552000
        LockTypeTime[6] = 60;
        LockTypeTime[7] = 60;//365 days (1Y) 31536000
        LockTypeTime[8] = 60;
        LockTypeMultiplier[1] = 250;
        LockTypeMultiplier[2] = 320;
        LockTypeMultiplier[3] = 875;
        LockTypeMultiplier[4] = 1100;
        LockTypeMultiplier[5] = 2000;
        LockTypeMultiplier[6] = 2500;
        LockTypeMultiplier[7] = 5000;
        LockTypeMultiplier[8] = 6300;
    }
    //Lock Types:
    //1M 2.5% Reg 3% WL (1 and 2)
    //3M 8.75% Reg 11% WL (3 and 4)
    //6M 20% Reg 25% WL (5 and 6)
    //12M 50% Reg 63% WL (7 and 8)

    struct Lock{
        uint256 ID;
        address User;
        uint8 Type;
        uint256 DepositAmount;
        uint256 WithdrawAmount;
        uint256 Expiration; //In Unix
    }


    //Public Functions
    function CreateLock(uint8 Type, uint256 amount) public returns(bool success){
        require(ERC20(CLD).balanceOf(msg.sender) >= amount, "You do not have enough CLD to stake this amount");
        require(ERC20(CLD).allowance(msg.sender, address(this)) >= amount, "You have not given the staking contract enough allowance");
        require((ActiveLocks[msg.sender] + 1) <= 3);

        if(Type == 2 || Type == 4 || Type == 6 || Type == 8){
            require(PreSaleUser[msg.sender] == true, "Cannot use this lock type because you are not a Pre Sale participant");
        }
        uint256 NewLockID = UserLocks[msg.sender].length;
        uint256 AmountOnWithdraw = ((amount * LockTypeMultiplier[Type]) / 1000) + amount;
        uint256 Expiration = (block.timestamp + LockTypeTime[Type]);
        Lock memory NewLock = Lock(NewLockID, msg.sender, Type, amount, AmountOnWithdraw, Expiration);

        ERC20(CLD).transferFrom(msg.sender, address(this), amount);

        ActiveLocks[msg.sender] = ActiveLocks[msg.sender] + 1;
        UserLocks[msg.sender].push(NewLock);

        return(success);
    }

    function ClaimLock(uint256 ID) public returns(bool success){
        require(UserLocks[msg.sender][ID].Expiration <= block.timestamp, "This lock has not acheived its maturity date yet");
        if(UserLocks[msg.sender][ID].Type == 66){
            revert("This lock has already been claimed");
        }
        uint256 amount = UserLocks[msg.sender][ID].WithdrawAmount;
        require(ERC20(CLD).balanceOf(address(this)) >= amount, "The contract does not have enough CLD to claim this lock, please reach out to the Dev team");

        UserLocks[msg.sender][ID].Type = 66;
        UserLocks[msg.sender][ID].User = address(0);
        UserLocks[msg.sender][ID].DepositAmount = 0;
        UserLocks[msg.sender][ID].WithdrawAmount = 0;
        UserLocks[msg.sender][ID].Expiration = 3093517607560;

        ActiveLocks[msg.sender] = ActiveLocks[msg.sender] - 1;
        
        ERC20(CLD).transfer(msg.sender, amount);
        return(success);
    }

    //Internal Functions
    

    //Owner Only Functions

    function AddEligible(address[] memory Addresses) public returns(bool success){
        require(msg.sender == Operator);
        require(PreSaleListCompleted == false);

        uint256 index = 0;
        while(index < Addresses.length){
            PreSaleUser[Addresses[index]] = true;
            index++;
        }
        PreSaleListCompleted = true;
        return(success);
    }

    //Informatical View Functions

    function GetDaysLeft(address User, uint256 ID) public view returns(uint256 Days){
        return(((UserLocks[User][ID].Expiration - block.timestamp) / 86400));
    }

    function GetTimeLeft(address User, uint256 ID) public view returns(uint256 Seconds){
        return((UserLocks[User][ID].Expiration - block.timestamp)); //Fix when negative
    }

    function GetActiveUserLocks(address User) public view returns(uint256[] memory List){
        uint256 len = UserLocks[User].length;
        uint256[] memory list;
        if(ActiveLocks[User] == 3){
            list[0] = (len - 1);
            list[0] = (len - 2);
            list[0] = (len - 3);
        }
        else if(ActiveLocks[User] == 2){
            list[0] = (len - 1);
            list[0] = (len - 2);
        }
        return(list);
    }

}

interface ERC20 {
  function balanceOf(address owner) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint value) external returns (bool);
  function Mint(address _MintTo, uint256 _MintAmount) external;
  function transfer(address to, uint value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool); 
  function totalSupply() external view returns (uint);
}    