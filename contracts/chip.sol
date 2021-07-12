// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Chip is Ownable, ERC721{
    struct Metadata {
        string name;
        string description;
        string img_url;
    }

    // token和元数据的对应
    mapping(uint256 => Metadata) id_to_chip;
    // token和创作者的对应
    mapping(uint256 => address) autherOf;

    constructor() public ERC721("Chip", "CHIP") {
        // 这里 baseURI 需要修改为我们的后台接口
        _setBaseURI("https://date.kie.codes/token/");

        // 这里是初始化的时候 mint 的token，可以初始化多个
        mint("sun", "Beautiful!", "http://47.94.4.177:8010/img.png", 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0);
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    function mint(string memory name, string memory description, string memory img_url, address auther, uint token_id) internal {
        id_to_chip[token_id] = Metadata(name, description, img_url);
        autherOf[token_id] = auther;
        _safeMint(msg.sender, token_id);
    }

    function claim(string memory name, string memory description, string memory img_url, address auther, uint token_id) external payable {
        require(msg.value >= 100000000000000 wei, "create a Chip cost at least 100000000000000 wei");
        mint(name, description, img_url, auther, token_id);
        // payable(owner()).transfer(msg.value);
        address(uint160(owner())).transfer(msg.value);
    }

    function ownerOfChip(uint token_id) public view returns(address) {
        return ownerOf(token_id);
    }

    function get(uint256 toke_id) external view returns (string memory name, string memory description, string memory img_url) {
        require(_exists(toke_id), "token not minted");
        Metadata memory chip = id_to_chip[toke_id];
        name = chip.name;
        description = chip.description;
        img_url = chip.img_url;
    }
    
    function getAuther (uint _token_id) public view returns(address) {
        require(_exists(_token_id), "token has not been minted");
        return autherOf[_token_id];
    }
    
    function transfer(address from_addr, address to_addr, uint toke_id) internal {
        _transfer(from_addr, to_addr, toke_id);
    }

    function buy (uint token_id) public payable {
        require(_exists(token_id), "token not minted");
        // uint Tex = 1 ether;
        require(msg.value >= 10000000000 wei, "need more ether");
        address from_addr = ownerOfChip(token_id);
        address(uint160(from_addr)).transfer(msg.value/10 * 8);
        address(uint160(address(this))).transfer(msg.value/10 * 1);
        address(uint160(autherOf[token_id])).transfer(msg.value/10 * 1);
        transfer(from_addr, msg.sender, token_id);
    }
    
    function balanceOfContract() public onlyOwner view returns(uint)  {
        return address(this).balance;
    }
    
    function ethBalance(address _addr) public view returns (uint) {
        return _addr.balance;
    }
    
    fallback () external payable{
         
    }
    
    function withdraw () onlyOwner public{
        msg.sender.transfer(address(this).balance);
    }
    
    receive () payable external {
        
    }
}