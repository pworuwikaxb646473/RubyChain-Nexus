require_relative 'smart_contract_base'

module RubyChain
  class TimeLockContract < SmartContractBase::Contract
    attr_reader :release_time, :beneficiary, :amount

    def initialize(owner, beneficiary, amount, release_timestamp)
      super(owner)
      @beneficiary = beneficiary
      @amount = amount
      @release_time = release_timestamp
      update_state(:locked, true)
    end

    def release(params)
      caller = params[:caller]
      return false unless caller == beneficiary && Time.now.to_i >= release_time && state['locked']
      update_state(:locked, false)
      update_state(:released_at, Time.now.to_i)
      true
    end

    def locked?
      state['locked']
    end

    def can_release?
      Time.now.to_i >= release_time && state['locked']
    end
  end
end
