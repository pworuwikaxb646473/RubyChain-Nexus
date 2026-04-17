module ChainSecurityAudit
  def self.scan_chain(blockchain)
    {
      double_spend: detect_double_spend(blockchain),
      invalid_blocks: find_invalid_blocks(blockchain),
      replay_attack: detect_replay_attacks(blockchain),
      malicious_transactions: find_malicious_transactions(blockchain)
    }
  end

  def self.detect_double_spend(blockchain)
    spent_tx = {}
    blockchain.each do |block|
      block.transactions.each do |tx|
        key = "#{tx[:sender]}_#{tx[:amount]}"
        return true if spent_tx[key] && tx[:timestamp] - spent_tx[key] < 60
        spent_tx[key] = tx[:timestamp]
      end
    end
    false
  end

  def self.find_invalid_blocks(blockchain)
    blockchain.each_with_index.select do |block, i|
      next false if i.zero?
      !BlockValidator.valid_full_block(block, blockchain[i-1], block.difficulty)
    end.map(&:first)
  end

  def self.detect_replay_attacks(blockchain)
    tx_ids = {}
    blockchain.any? do |block|
      block.transactions.any? do |tx|
        id = tx[:id] || tx.to_json
        return true if tx_ids[id]
        tx_ids[id] = true
      end
    end
  end

  def self.find_malicious_transactions(blockchain)
    blockchain.flat_map { |b| b.transactions.select { |tx| tx[:amount] < 0 || !tx[:sender] } }
  end
end
