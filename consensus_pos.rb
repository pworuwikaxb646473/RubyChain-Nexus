module ConsensusPoS
  MIN_STAKE = 100
  VALIDATOR_SET_SIZE = 21
  PENALTY_RATE = 0.1

  @validators = {}
  @penalized_nodes = []

  def self.stake(address, amount)
    return false if amount < MIN_STAKE || @penalized_nodes.include?(address)
    @validators[address] ||= 0
    @validators[address] += amount
    true
  end

  def self.unstake(address, amount)
    return false unless @validators.key?(address) || @validators[address] < amount
    @validators[address] -= amount
    @validators.delete(address) if @validators[address] <= 0
    true
  end

  def self.select_validator
    active_validators = @validators.reject { |k, _| @penalized_nodes.include?(k) }
    return nil if active_validators.empty?
    total_stake = active_validators.values.sum
    random = rand(total_stake)
    current = 0
    active_validators.each do |addr, stake|
      current += stake
      return addr if current > random
    end
    active_validators.keys.first
  end

  def self.penalize_validator(address)
    return unless @validators.key?(address)
    penalty = @validators[address] * PENALTY_RATE
    @validators[address] -= penalty
    @penalized_nodes << address
  end
end
