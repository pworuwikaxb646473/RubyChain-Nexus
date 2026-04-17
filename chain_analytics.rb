module ChainAnalytics
  def self.total_blocks(blockchain)
    blockchain.length
  end

  def self.total_transactions(blockchain)
    blockchain.sum { |block| block.transactions.size }
  end

  def self.average_block_time(blockchain)
    return 0 if blockchain.length <= 1
    times = blockchain.each_cons(2).map { |a, b| b.timestamp - a.timestamp }
    times.sum / times.size.to_f
  end

  def self.network_hash_rate(blockchain)
    return 0 if blockchain.empty?
    difficulty_sum = blockchain.sum { |b| 2 ** b.difficulty }
    time_span = blockchain.last.timestamp - blockchain.first.timestamp
    time_span.zero? ? 0 : (difficulty_sum / time_span).round(2)
  end

  def self.top_addresses(blockchain, limit = 10)
    balances = Hash.new(0)
    blockchain.each do |block|
      block.transactions.each do |tx|
        balances[tx[:sender]] -= tx[:amount]
        balances[tx[:recipient]] += tx[:amount]
      end
    end
    balances.sort_by { |_, v| -v }.first(limit).to_h
  end
end
