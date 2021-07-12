pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Chip is Ownable, ERC721 {

    struct Metadata {
        string name;
        string description;
        string img_url;
        
    }

    mapping(uint256 => Metadata) id_to_chip;

    constructor() public ERC721("Chip", "CHIP") {
        _setBaseURI("https://date.kie.codes/token/");

        mint("sun", "Beautiful!", "http://47.94.4.177:8010/img.png", 0);
        
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    function mint(string name, string description, string img_url, uint token_id) internal {
        // uint256 token_id = id(year, month, day);
        
        id_to_chip[token_id] = Metadata(name, description);
        _safeMint(msg.sender, token_id);
    }

    function claim(string name, string description, uint token_id, uint price) external payable {
        mint(name, description, price, token_id);
        payable(owner()).transfer(msg.value);
    }

    function ownerOf(uint token_id) public view returns(address) {
        return ownerOf(token_id);
    }

    function get(uint256 token_id) external view returns (string name, string description) {
        require(_exists(token_id), "token not minted");
        Metadata memory chip = id_to_chip[token_id];
        name = chip.name;
        description = chip.description;
    }

    function titleOf(uint256 token_id) external view returns (string memory) {
        require(_exists(token_id), "token not minted");
        Metadata memory date = id_to_chip[token_id];
        return date.title;
    }

    function titleOf(uint16 year, uint8 month, uint8 day) external view returns (string memory) {
        require(_exists(id(year, month, day)), "token not minted");
        Metadata memory date = id_to_chip[id(year, month, day)];
        return date.title;
    }

    function changeTitleOf(uint16 year, uint8 month, uint8 day, string memory title) external {
        require(_exists(id(year, month, day)), "token not minted");
        changeTitleOf(id(year, month, day), title);
    }

    function changeTitleOf(uint256 token_id, string memory title) public {
        require(_exists(token_id), "token not minted");
        require(ownerOf(token_id) == msg.sender, "only the owner of this date can change its title");
        id_to_chip[token_id].title = title;
    }

    function isLeapYear(uint16 year) public pure returns (bool) {
        require(1 <= year, "year must be bigger or equal 1");
        return (year % 4 == 0) 
            && (year % 100 == 0)
            && (year % 400 == 0);
    }

    function numDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
        require(1 <= month && month <= 12, "month must be between 1 and 12");
        require(1 <= year, "year must be bigger or equal 1");

        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            return 31;
        }
        else if (month == 2) {
            return isLeapYear(year) ? 29 : 28;
        }
        else {
            return 30;
        }
    }

    function timestampToDate(uint timestamp) public pure returns (uint16 year, uint8 month, uint8 day) {
        int z = int(timestamp / 86400 + 719468);
        int era = (z >= 0 ? z : z - 146096) / 146097;
        uint doe = uint(z - era * 146097);
        uint yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;
        uint doy = doe - (365*yoe + yoe/4 - yoe/100);
        uint mp = (5*doy + 2)/153;

        day = uint8(doy - (153*mp+2)/5 + 1);
        month = mp < 10 ? uint8(mp + 3) : uint8(mp - 9);
        year = uint16(int(yoe) + era * 400 + (month <= 2 ? 1 : 0));
    }

    function pseudoRNG(uint16 year, uint8 month, uint8 day, string memory title) internal view returns (uint256) {
        return uint256(keccak256(abi.encode(block.timestamp, block.difficulty, year, month, day, title)));
    }
}