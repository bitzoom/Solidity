// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoToken is ERC721URIStorage, Ownable {
    constructor() ERC721("VolcanoToken", "VTM") { TokenID =1;}

    uint256 public TokenID;

    struct token {
        uint256 timestamp;
        uint256 tokenID;
        string tokenURI;
    }

    token[] public BurnedTokens;

    token[] public AllTokens;

    mapping (address => token[]) public OwnerTokens;

    function CheckExists(uint256 tokenId) public view returns (bool) { 
        return _exists(tokenId);
    }

    function MintToken (address to, string memory _tokenURI) public returns (bool) {
        // mint the token using _safeMint()
        _mint(to, TokenID);

        // update the mappings
        token memory NewToken = token(block.timestamp,TokenID,_tokenURI);
        OwnerTokens[to].push(NewToken);
        AllTokens.push(NewToken);

        // store the tokenURI
        _setTokenURI(TokenID, _tokenURI);
        
        // update TokenID so we keep count
        TokenID +=1;
        return true;
    }

    function BurnToken (uint256 tokenId) public returns(bool) {
        // require only owner to call function to burn token
        require(msg.sender == ownerOf(tokenId), "BurnToken: You are not the owner of the token");
        _burn(tokenId);

        // remove the burned token from the OwnerTokens mapping
        RemoveToken(ownerOf(tokenId),tokenId);
        return true;
    }

    function RemoveToken (address _owner, uint256 _tokenId) internal returns(bool) {
        token[] memory ListTokens = OwnerTokens[_owner];
        uint position = 0;

        // find out position of the token to delete in the list    
        for (uint i=0; i<ListTokens.length; i++) {
            if (ListTokens[i].tokenID == _tokenId) { position = i; }
        }
        
        // delete the token from the owner's list
        OwnerTokens[_owner][position] = OwnerTokens[_owner][ListTokens.length-1];
        OwnerTokens[_owner].pop();

        // update the list of burned tokens
        BurnedTokens.push(ListTokens[position]);
        return true;
    }
    
}
