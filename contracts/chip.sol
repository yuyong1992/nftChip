pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract Chip is Ownable, ERC721{
    // 合约的所有者，存在变量中方便有需要直接调用
    address ownerOfContract = msg.sender;

    // token和创作者的对应
    mapping(uint256 => address) authorOf;

    // 定义事件
    // event Mint(address indexed to, address indexed author, uint256 indexed token_id);
    // event create(address indexed to, address indexed author, uint256 indexed token_id);
    // event ChangeAuthor(address indexed Modifier, address befor_addr, address indexed after_addr, uint256 indexed token_id);
    // event Buy(address indexed from, address indexed to, uint256 token_id);
    

    constructor() ERC721("Nft.Chip", "CHIP") {
        // 这里 baseURI 需要修改为我们的后台接口
        // _setBaseURI("https://date.kie.codes/token/");

        // 这里是初始化的时候 mint 的token，可以初始化多个
        mint(msg.sender, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0);
        mint(msg.sender,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 1); 
        mint(msg.sender,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 2); 
        mint(msg.sender,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 3); 
        mint(msg.sender,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 4); 
    }

    fallback () external payable{
         
    }

    receive () payable external {
        
    }
    
    function withdraw () onlyOwner public{
        msg.sender.transfer(address(this).balance);
    }
    
    /*
     *  设置获取token元数据的接口
     *  例如：baseURL为：http:www.baseuri.com
     *  id为 1 的token会自动从：http:www.baseuri.com/1 获取元数据
    */
    function setBaseURI(string memory baseURI) public onlyOwner {
        // require(msg.sender == ownerOfContract, "only the owner of contract can set the baseURI");
        _setBaseURI(baseURI);
    }

    function setTokenURI(uint256 token_id, string memory _tokenURI) public onlyOwner {
        _setTokenURI(token_id, _tokenURI);
    }

    function mint(address to, address author, uint token_id) public onlyOwner {
        authorOf[token_id] = author;
        _safeMint(to, token_id);
        // emit Mint(to, author, token_id);
    }

    function create(address author, uint token_id) external payable {
        // 需要确定创建NFT需不需要花钱
        mint(msg.sender, author, token_id);
        address(uint160(owner())).transfer(msg.value);
        // emit create(msg.sender, author, token_id);
    }

    function ownerOfChip(uint token_id) public view returns(address) {
        return ownerOf(token_id);
    }
    
    function getauthor (uint _token_id) public view returns(address) {
        require(_exists(_token_id), "token has not been minted");
        return authorOf[_token_id];
    }
    
    function getOwnerOfContract () public view returns (address){
        return ownerOfContract;
    }
    
    function changeAuthor(uint token_id, address new_author) public {
        require(_exists(token_id), "token id not exists");
        require(new_author != address(0), "address of new author is zero");
        require(msg.sender == owner(), "have no authority to change the author");
        // address author_old = authorOf[token_id];
        authorOf[token_id] = new_author;
        // emit ChangeAuthor(msg.sender, author_old, new_author, token_id);
    }
    
    function transfer(address from_addr, address to_addr, uint token_id) internal {
        _transfer(from_addr, to_addr, token_id);
    }

    function buy (uint token_id) public payable {
        require(_exists(token_id), "token not minted");
        require(ownerOfChip(token_id) != msg.sender, "already the owner");
        // 原owner:创作者:平台 = 88:6:6
        address(uint160(ownerOfChip(token_id))).transfer(msg.value/100 * 88);
        address(uint160(authorOf[token_id])).transfer(msg.value/100 * 6);
        transfer(ownerOfChip(token_id), msg.sender, token_id);
        // emit Buy(from_addr, msg.sender, token_id);
    }
    
    function balanceOfContract() public onlyOwner view returns(uint)  {
        return address(this).balance;
    }
    
    function ethBalance(address _addr) public view returns (uint) {
        return _addr.balance;
    }
}