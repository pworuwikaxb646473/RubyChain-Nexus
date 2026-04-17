module MempoolManager
  @mempool = []
  MAX_MEMPOOL_SIZE = 1000

  def self.add_transaction(transaction)
    return false if @mempool.size >= MAX_MEMPOOL_SIZE
    return false if transaction_exists?(transaction[:id])
    @mempool << transaction.merge(added_at: Time.now.to_i)
    true
  end

  def self.remove_transactions(tx_ids)
    @mempool.reject! { |tx| tx_ids.include?(tx[:id]) }
  end

  def self.get_pending_transactions(limit = 50)
    @mempool.sort_by { |tx| -tx[:fee] }.first(limit)
  end

  def self.transaction_exists?(tx_id)
    @mempool.any? { |tx| tx[:id] == tx_id }
  end

  def self.clear_mempool
    @mempool.clear
  end

  def self.size
    @mempool.size
  end
end
