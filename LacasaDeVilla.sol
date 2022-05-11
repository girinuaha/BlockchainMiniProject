//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8;

import "./StringUtils.sol";
import "./Villa.sol";
import "./Landlord.sol";

contract LacasaDeVilla is VillaBuilding, LandlordJob {
    
    address payable tenant;

    function checkEmptyVilla() public view returns (string[] memory) {
        return emptyVillaName;
    }

    function checkIn (string memory _villaName) public payable notLandlord checkAvailability(_villaName) checkAgreementFee(_villaName) {
        
        uint totalFee = (getDetailVilla[_villaName].rentPerNight + getDetailVilla[_villaName].rentDeposit) * 1 ether;
        landlord.transfer(totalFee);

        getDetailVilla[_villaName].isOccupied = true;
        getDetailVilla[_villaName].currentTenant = payable(msg.sender);     
        
        uint index;
        for (uint i = 0; i < emptyVillaName.length; i++) {
            if (StringUtils.equal(emptyVillaName[i], _villaName)) {
                index = i;
            }
        }

        for(uint i = index; i < emptyVillaName.length - 1; i++){
            emptyVillaName[i] = emptyVillaName[i+1];      
        }
        emptyVillaName.pop();

        uint change = msg.value - totalFee;
        payable(msg.sender).transfer(change); 

        villaOccupied++;  
    }

    function checkOut (string memory _villaName) public payable onlyLandlord {
        
        uint deposit = getDetailVilla[_villaName].rentDeposit;
        address payable _tenantAddress = getDetailVilla[_villaName].currentTenant;
        _tenantAddress.transfer(deposit);

        getDetailVilla[_villaName].isOccupied = false; 
        getDetailVilla[_villaName].currentTenant = payable(address(0));
        
        emptyVillaName.push(_villaName);    

        uint change = msg.value - (deposit * 1 ether);
        payable(msg.sender).transfer(change); 

        villaOccupied--;
    }
}