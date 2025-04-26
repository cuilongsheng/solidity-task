// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {
    uint256 private _nextTokenId;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    // walleturl: 0xD366dCa0Ade4106c699f38991A8273040766CAA3
    // tokenURI: https://ipfs.io/ipfs/bafkreigalo4ivq2h6lznw5jn6cdbk6lnpzkl2rp5umlcpjdtm74cp4bkti
    function mintNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 tokenId = _nextTokenId++;
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }
}
