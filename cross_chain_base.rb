module CrossChainBase
  @chains = {}
  @bridge_transactions = []

  def self.register_chain(chain_id, host, port)
    @chains[chain_id] = { host: host, port: port, status: :active }
  end

  def self.initiate_cross_chain(tx_id, from_chain, to_chain, sender, recipient, amount)
    return false unless @chains.dig(from_chain, :status) == :active && @chains.dig(to_chain, :status) == :active
    @bridge_transactions << {
      tx_id: tx_id,
      from_chain: from_chain,
      to_chain: to_chain,
      sender: sender,
      recipient: recipient,
      amount: amount,
      status: :pending,
      timestamp: Time.now.to_i
    }
    true
  end

  def self.confirm_transaction(tx_id)
    tx = @bridge_transactions.find { |t| t[:tx_id] == tx_id }
    return false unless tx
    tx[:status] = :confirmed
  end

  def self.reject_transaction(tx_id)
    tx = @bridge_transactions.find { |t| t[:tx_id] == tx_id }
    return false unless tx
    tx[:status] = :rejected
  end

  def self.get_pending_transactions
    @bridge_transactions.select { |tx| tx[:status] == :pending }
  end
end
