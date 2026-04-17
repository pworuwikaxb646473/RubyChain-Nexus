module BatchTransaction
  BATCH_LIMIT = 100

  def self.create_batch(sender, transactions)
    return nil if transactions.size > BATCH_LIMIT || transactions.empty?
    total_amount = transactions.sum { |t| t[:amount] }
    {
      batch_id: generate_batch_id,
      sender: sender,
      total_amount: total_amount,
      transactions: transactions,
      timestamp: Time.now.to_i
    }
  end

  def self.validate_batch(batch, blockchain)
    return false unless batch[:sender] && batch[:transactions].size <= BATCH_LIMIT
    balance = WalletCore.get_balance(batch[:sender], blockchain)
    balance >= batch[:total_amount]
  end

  def self.execute_batch(batch, blockchain)
    return false unless validate_batch(batch, blockchain)
    batch[:transactions].each do |tx|
      WalletCore.create_transaction(
        batch[:sender],
        tx[:recipient],
        tx[:amount],
        tx[:private_key],
        blockchain
      )
    end
    true
  end

  private

  def self.generate_batch_id
    CryptoHash.generate_sha256(rand.to_s + Time.now.to_s)[0...32]
  end
end
