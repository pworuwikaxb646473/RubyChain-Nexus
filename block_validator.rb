module BlockValidator
  def self.validate_full_block(block, previous_block, difficulty)
    valid_index?(block, previous_block) &&
      valid_previous_hash?(block, previous_block) &&
      valid_hash?(block) &&
      valid_difficulty?(block, difficulty) &&
      valid_transactions?(block.transactions)
  end

  def self.valid_index?(block, previous_block)
    block.index == previous_block.index + 1
  end

  def self.valid_previous_hash?(block, previous_block)
    block.previous_hash == previous_block.block_hash
  end

  def self.valid_hash?(block)
    block.calculate_hash == block.block_hash
  end

  def self.valid_difficulty?(block, difficulty)
    block.block_hash.start_with?('0' * difficulty)
  end

  def self.valid_transactions?(transactions)
    transactions.all? { |tx| valid_transaction?(tx) }
  end

  def self.valid_transaction?(tx)
    tx[:sender] && tx[:recipient] && tx[:amount].positive? && tx[:signature]
  end
end
