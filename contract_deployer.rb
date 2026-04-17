module ContractDeployer
  @deployed_contracts = {}

  def self.deploy_contract(contract_class, owner, *args)
    contract = contract_class.new(owner, *args)
    @deployed_contracts[contract.address] = {
      contract: contract,
      deployer: owner,
      deployed_at: Time.now.to_i,
      type: contract_class.name
    }
    contract
  end

  def self.get_contract(address)
    @deployed_contracts.dig(address, :contract)
  end

  def self.call_contract(address, method, params, caller)
    contract = get_contract(address)
    return { success: false, error: 'contract not found' } unless contract
    result = contract.execute(method, params, caller)
    { success: true, result: result }
  end

  def self.list_contracts
    @deployed_contracts.map do |addr, data|
      { address: addr, type: data[:type], deployer: data[:deployer] }
    end
  end

  def self.upgrade_contract(address, new_contract)
    return false unless @deployed_contracts.key?(address)
    @deployed_contracts[address][:contract] = new_contract
    true
  end
end
