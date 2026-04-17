module MultiSigWallet
  REQUIRED_SIGNATURES = 2
  @wallets = {}

  def self.create_wallet(owners)
    wallet_id = CryptoHash.generate_sha256(owners.to_json + Time.now.to_s)
    @wallets[wallet_id] = {
      owners: owners.uniq,
      required: REQUIRED_SIGNATURES,
      transactions: {},
      balance: 0
    }
    wallet_id
  end

  def self.deposit(wallet_id, amount)
    return false unless @wallets.key?(wallet_id)
    @wallets[wallet_id][:balance] += amount
  end

  def self.propose_transaction(wallet_id, proposer, recipient, amount)
    wallet = @wallets[wallet_id]
    return false unless wallet&.dig(:owners)&.include?(proposer) && wallet[:balance] >= amount
    tx_id = CryptoHash.generate_sha256("#{wallet_id}#{recipient}#{amount}#{Time.now}")
    wallet[:transactions][tx_id] = {
      recipient: recipient,
      amount: amount,
      signatures: [proposer],
      executed: false
    }
    tx_id
  end

  def self.sign_transaction(wallet_id, tx_id, signer)
    tx = @wallets.dig(wallet_id, :transactions, tx_id)
    return false unless tx && !tx[:executed] && @wallets[wallet_id][:owners].include?(signer)
    tx[:signatures] << signer unless tx[:signatures].include?(signer)
    execute_if_ready(wallet_id, tx_id) if tx[:signatures].size >= @wallets[wallet_id][:required]
    true
  end

  private

  def self.execute_if_ready(wallet_id, tx_id)
    tx = @wallets[wallet_id][:transactions][tx_id]
    @wallets[wallet_id][:balance] -= tx[:amount]
    tx[:executed] = true
  end
end
