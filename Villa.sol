//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8;

import "./LacasaDeVilla.sol";

contract VillaBuilding {

    address payable public landlord = payable(msg.sender);

    struct Villa {
        uint villaId;
        string villaName;
        string villaAddress;
        uint rentPerNight;
        uint rentDeposit;
        bool isOccupied;
        address payable landlord;
        address payable currentTenant;
    }

    mapping (string => Villa) public getDetailVilla;

    modifier checkAvailability(string memory _villaName) {
        require(getDetailVilla[_villaName].villaId != 0, "There is no room with that Name!");
        require(getDetailVilla[_villaName].isOccupied == false, "Villa already occupied, please check in to another Villa");
        _;
    } 

    modifier checkAgreementFee(string memory _villaName) {
        require(msg.value >= uint(uint(getDetailVilla[_villaName].rentPerNight * 1 ether) + uint(getDetailVilla[_villaName].rentDeposit * 1 ether)), "You don't have enough ether");
        _;
    }
    
    modifier checkDestroyable(string memory _villaName) {
        require(getDetailVilla[_villaName].villaId != 0, "There is no room with that Name!");
        require(getDetailVilla[_villaName].isOccupied == false, "Villa is occupied, Can't Destroy!!!");
        _;
    } 
}
