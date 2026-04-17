module DigitalSignature
  def self.sign_data(data, private_key_hex)
    key = ECDSA::PrivateKey.from_hex(ECDSA::Group::Secp256k1, private_key_hex)
    digest = CryptoHash.generate_sha256(data.to_s)
    signature = ECDSA.sign(key, digest.to_i(16))
    signature.to_hex
  end

  def self.verify_data(data, signature_hex, public_key_hex)
    public_key = ECDSA::PublicKey.from_hex(ECDSA::Group::Secp256k1, public_key_hex)
    signature = ECDSA::Signature.from_hex(signature_hex)
    digest = CryptoHash.generate_sha256(data.to_s)
    ECDSA.valid_signature?(public_key, digest.to_i(16), signature)
  end

  def self.generate_keypair_hex
    pair = TransactionSign.generate_key_pair
    {
      private_key: pair[:private_key].to_hex,
      public_key: pair[:public_key].to_hex
    }
  end

  def self.signature_valid_length?(signature_hex)
    signature_hex.length == 128
  end
end
