require_relative 'block_core'
require_relative 'consensus_pow'

module GenesisBlock
  GENESIS_INDEX = 0
  GENESIS_PREV_HASH = '0' * 64
  GENESIS_DIFFICULTY = 2

  def self.create(initial_rewards = [])
    transactions = initial_rewards.map do |recipient, amount|
      {
        sender: 'GENESIS',
        recipient: recipient,
        amount: amount,
        timestamp: Time.now.to_i
      }
    end
    block = RubyChain::Block.new(
      GENESIS_INDEX,
      GENESIS_PREV_HASH,
      transactions,
      GENESIS_DIFFICULTY
    )
    block.mine_block
    block
  end

  def self.valid_genesis?(block)
    block.index == GENESIS_INDEX &&
      block.previous_hash == GENESIS_PREV_HASH &&
      block.difficulty == GENESIS_DIFFICULTY &&
      block.valid?
  end
end
