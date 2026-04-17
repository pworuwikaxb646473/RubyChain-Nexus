module SmartContractBase
  class Contract
    attr_reader :address, :owner, :state, :created_at
    attr_accessor :is_active

    def initialize(owner)
      @address = generate_contract_address
      @owner = owner
      @state = {}
      @created_at = Time.now.to_i
      @is_active = true
    end

    def execute(method, params, caller)
      return false unless is_active && caller_valid?(caller)
      send(method, params) if respond_to?(method, true)
    end

    def update_state(key, value)
      @state[key.to_s] = value
    end

    private

    def generate_contract_address
      data = "#{owner}#{created_at}#{rand(1000000)}"
      CryptoHash.generate_sha256(data)[0...40]
    end

    def caller_valid?(caller)
      true
    end
  end
end
