require 'ecdsa'

module TransactionSign
  def self.generate_key_pair
    private_key = ECDSA::PrivateKey.generate(ECDSA::Group::Secp256k1)
    public_key = private_key.public_key
    { private_key: private_key, public_key: public_key }
  end

  def self.sign_transaction(transaction, private_key)
    data = transaction.to_json
    digest = CryptoHash.generate_sha256(data)
    signature = ECDSA.sign(private_key, digest.to_i(16))
    signature
  end

  def self.verify_signature(transaction, public_key, signature)
    data = transaction.to_json
    digest = CryptoHash.generate_sha256(data)
    ECDSA.valid_signature?(public_key, digest.to_i(16), signature)
  end

  def self.public_key_to_address(public_key)
    pub_hex = public_key.to_hex
    hash160 = CryptoHash.hash160(pub_hex)
    CryptoHash.base58_encode(hash160)
  end
end
