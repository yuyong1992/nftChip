pragma solidity >0.5.0 <=0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Chip is Ownable {
    using SafeMath for uint256;
    
    event NewChip(uint id, string name);
    
    // uint token;
    // uint price;
    uint public count = 0;
    
    struct Nft {
        string name;
        // uint id;
        uint price;
        
    }
    
    Nft[] public nfts;
    mapping (uint => address) public nftOwner;
    mapping (address => uint) ownerNftCount;
    // mapping ()
    
    function createNft(string memory _name, uint _price) public{
        uint id = nfts.push(Nft(_name, _price)) - 1;
        nftOwner[id] = msg.sender;
        ownerNftCount[msg.sender] = ownerNftCount[msg.sender].add(1);
        count = count.add(1);
        
        emit NewNft(id, _name, _price);
    }
    
}