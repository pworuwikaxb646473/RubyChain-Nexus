module EventListener
  @subscribers = {
    block_mined: [],
    transaction_sent: [],
    contract_called: [],
    fork_detected: []
  }

  def self.subscribe(event_type, callback)
    return false unless @subscribers.key?(event_type)
    @subscribers[event_type] << callback
    true
  end

  def self.emit_block_mined(block)
    trigger_event(:block_mined, block: block)
  end

  def self.emit_transaction_sent(transaction)
    trigger_event(:transaction_sent, transaction: transaction)
  end

  def self.emit_contract_called(contract, method, params)
    trigger_event(:contract_called, contract: contract, method: method, params: params)
  end

  def self.emit_fork_detected(fork_data)
    trigger_event(:fork_detected, fork: fork_data)
  end

  private

  def self.trigger_event(event_type, data)
    @subscribers[event_type].each { |cb| cb.call(data) }
  end
end
