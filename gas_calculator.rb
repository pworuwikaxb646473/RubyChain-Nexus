module GasCalculator
  BASE_GAS = 21000
  CONTRACT_DEPLOY_GAS = 500000
  DATA_BYTE_GAS = 68
  MIN_GAS_PRICE = 1e-9

  def self.calculate_transaction_gas(transaction)
    base = BASE_GAS
    data_gas = transaction[:data] ? transaction[:data].bytes.size * DATA_BYTE_GAS : 0
    base + data_gas
  end

  def self.calculate_contract_gas(operations)
    operations.sum { |op| operation_cost(op) }
  end

  def self.calculate_total_fee(gas_used, gas_price)
    return 0 if gas_price < MIN_GAS_PRICE
    (gas_used * gas_price).round(9)
  end

  def self.contract_deploy_cost
    CONTRACT_DEPLOY_GAS
  end

  private

  def self.operation_cost(op)
    case op.to_sym
    when :transfer then 5000
    when :store then 20000
    when :load then 2000
    when :call then 10000
    else 1000
    end
  end
end
