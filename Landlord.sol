//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8;

import "./Villa.sol";

contract LandlordJob is VillaBuilding {

    uint public villaTotal = 0;
    uint public villaOccupied = 0;
    uint totalFund;
    string[] emptyVillaName;

    function buildVilla (string memory _villaName, string memory _villaAddress, uint _rentCost, uint _rentDeposit) public onlyLandlord {
        villaTotal++;
        bool _isOccupied = false;
        getDetailVilla[_villaName] = Villa(villaTotal, _villaName, _villaAddress, _rentCost, _rentDeposit, _isOccupied, payable(msg.sender), payable(address(0)));
        emptyVillaName.push(_villaName);
    }

    function destroyVilla (string memory _villaName) public onlyLandlord checkDestroyable(_villaName) {
        delete getDetailVilla[_villaName];
        villaTotal--;
    }
    
    function checkTotalFund() public view onlyLandlord returns(uint) {
        return totalFund / 1 ether;
    }

    function withdraw () public onlyLandlord {
        landlord.transfer(totalFund);
        totalFund = 0;
    }

    modifier onlyLandlord {
        require(msg.sender == landlord, "Only Landlord can access this function! Go Back!");
        _;
    }

    modifier notLandlord {
        require(msg.sender != landlord, "Hey landlord! Why you rent your own villa?");
        _;
    }
}
