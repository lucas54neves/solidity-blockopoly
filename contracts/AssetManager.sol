pragma solidity >=0.5.16;

contract AssetManager {
  address public manager;

  struct Asset {
    address owner;
    string name;
    uint256 price;
    bool exists;
  }

  mapping(uint256 => Asset) private assets;

  event AssetAdded(address sender, string name);

  event AssetTransfered(address sender, address from, address to, string name);

  constructor() public {
    manager = msg.sender;
  }

  function addAsset(
    string memory name,
    uint256 price,
    address owner
  ) public {
    require(msg.sender == manager, "Only the Asset Manager can add assets");

    uint256 assetId = uint256(keccak256(abi.encodePacked(name)));

    require(!assets[assetId].exists, "Asset name already added");

    Asset memory asset = Asset({
      owner: owner,
      name: name,
      price: price,
      exists: true
    });

    assets[assetId] = asset;

    emit AssetAdded(msg.sender, name);
  }

  function getOwner(string memory name) public view returns (address) {
    uint256 assetId = uint256(keccak256(abi.encodePacked(name)));

    Asset memory asset = assets[assetId];

    require(asset.exists, "Asset does not exist");

    return asset.owner;
  }

  function transferAsset(
    address from,
    address to,
    string memory name
  ) public {
    require(msg.sender == manager, "Only the AssetManager can transfer assets");

    uint256 assetId = uint256(keccak256(abi.encodePacked(name)));

    Asset memory asset = assets[assetId];

    require(asset.exists, "Asset must exist");

    require(asset.owner == from, "Asset must be owned by from address");

    asset.owner = to;

    assets[assetId] = asset;

    emit AssetTransfered(msg.sender, from, to, name);
  }
}
