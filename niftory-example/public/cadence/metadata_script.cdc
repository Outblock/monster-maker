import MetadataViews from "../../contracts/MetadataViews.cdc"

import DapperUtilityCoin from "../../contracts/DapperUtilityCoin.cdc"

import NiftoryNonFungibleToken from "../../contracts/NiftoryNonFungibleToken.cdc"
import NiftoryNFTRegistry from "../../contracts/NiftoryNFTRegistry.cdc"

pub struct PurchaseData {
  pub let id: UInt64
  pub let name: String
  pub let amount: UFix64
  pub let description: String
  pub let imageURL: String
  pub let paymentVaultTypeID: Type

  init(id: UInt64, name: String, amount: UFix64, description: String, imageURL: String, paymentVaultTypeID: Type) {
    self.id = id
    self.name = name
    self.amount = amount
    self.description = description
    self.imageURL = imageURL
    self.paymentVaultTypeID = paymentVaultTypeID
  }
}

pub fun main(
  merchantAccountAddress: Address,
  registryAddress: Address,
  brand: String,
  nftId: UInt64?,
  nftTypeRef: String,
  setId: Int?,
  templateId: Int?,
  price: UFix64,
  expiry: UInt64
): PurchaseData {

  if setId == nil || templateId == nil {
    panic("setId and templateId must be provided")
  }

  let setManager = NiftoryNFTRegistry.getSetManagerPublic(
    registryAddress,
    brand
  )

  let template = setManager
    .getSet(setId!)
    .getTemplate(templateId!)
    .metadata()
    .get() as! {String: String}
  let name = template["title"]!
  let description = template["description"]!
  var imageURL = template["mediaUrl"]!
  if imageURL.slice(from: 0, upTo: 7) == "ipfs://" {
    imageURL = "https://gateway.ipfs.io/ipfs/".concat(
      imageURL.slice(
        from: 7,
        upTo: imageURL.length
      )
    )
  }

  return PurchaseData(
    id: nftId ?? 0,
    name: name,
    amount: price,
    description: description,
    imageURL: imageURL,
    paymentVaultTypeID: Type<@DapperUtilityCoin.Vault>()
  )
}