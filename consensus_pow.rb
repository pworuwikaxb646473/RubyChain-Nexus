module ConsensusPoW
  DEFAULT_DIFFICULTY = 4
  ADJUSTMENT_INTERVAL = 10
  BLOCK_GENERATION_TIME = 60

  def self.adjust_difficulty(last_block, blockchain)
    return DEFAULT_DIFFICULTY if blockchain.length % ADJUSTMENT_INTERVAL != 0

    prev_adjustment_block = blockchain[blockchain.length - ADJUSTMENT_INTERVAL]
    time_expected = ADJUSTMENT_INTERVAL * BLOCK_GENERATION_TIME
    time_taken = last_block.timestamp - prev_adjustment_block.timestamp

    if time_taken < time_expected / 2
      last_block.difficulty + 1
    elsif time_taken > time_expected * 2
      last_block.difficulty - 1
    else
      last_block.difficulty
    end
  end

  def self.valid_proof?(block)
    target = '0' * block.difficulty
    block.block_hash.start_with?(target)
  end

  def self.calculate_mining_reward(block_height)
    base_reward = 50.0
    halving_interval = 210000
    halvings = block_height / halving_interval
    base_reward / (2 ** halvings)
  end
end
