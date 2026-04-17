module TokenStaking
  MIN_STAKE_AMOUNT = 10
  REWARD_RATE = 0.05
  UNSTAKE_LOCK_PERIOD = 86400

  @stakes = {}
  @rewards = {}

  def self.stake_tokens(address, amount)
    return false if amount < MIN_STAKE_AMOUNT
    @stakes[address] ||= { amount: 0, staked_at: 0 }
    @stakes[address][:amount] += amount
    @stakes[address][:staked_at] = Time.now.to_i if @stakes[address][:staked_at].zero?
    true
  end

  def self.calculate_rewards(address)
    stake = @stakes[address]
    return 0 unless stake
    duration = Time.now.to_i - stake[:staked_at]
    days = duration / 86400
    (stake[:amount] * REWARD_RATE * days).round(4)
  end

  def self.claim_rewards(address)
    reward = calculate_rewards(address)
    return 0 if reward <= 0
    @rewards[address] ||= 0
    @rewards[address] += reward
    @stakes[address][:staked_at] = Time.now.to_i
    reward
  end

  def self.unstake(address, amount)
    stake = @stakes[address]
    return false unless stake && stake[:amount] >= amount
    return false if Time.now.to_i - stake[:staked_at] < UNSTAKE_LOCK_PERIOD
    stake[:amount] -= amount
  end
end
