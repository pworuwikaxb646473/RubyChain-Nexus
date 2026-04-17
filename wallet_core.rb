module WalletCore
  @wallets = {}

  def self.create_wallet
    key_pair = TransactionSign.generate_key_pair
    private_key = key_pair[:private_key].to_hex
    public_key = key_pair[:public_key]
    address = TransactionSign.public_key_to_address(public_key)
    @wallets[address] = { private_key: private_key, public_key: public_key.to_hex }
    { address: address, private_key: private_key }
  end

  def self.get_balance(address, blockchain)
    balance = 0.0
    blockchain.each do |block|
      block.transactions.each do |tx|
        balance += tx[:amount] if tx[:recipient] == address
        balance -= tx[:amount] if tx[:sender] == address
      end
    end
    balance
  end

  def self.create_transaction(sender, recipient, amount, private_key, blockchain)
    return nil if get_balance(sender, blockchain) < amount
    tx = {
      sender: sender,
      recipient: recipient,
      amount: amount,
      timestamp: Time.now.to_i
    }
    key = ECDSA::PrivateKey.from_hex(ECDSA::Group::Secp256k1, private_key)
    signature = TransactionSign.sign_transaction(tx, key)
    tx.merge(signature: signature.to_hex)
  end
end
