module UTXOManager
  @utxo_set = {}

  def self.add_utxo(tx_id, index, address, amount)
    @utxo_set["#{tx_id}_#{index}"] = {
      address: address,
      amount: amount,
      spent: false
    }
  end

  def self.spend_utxo(tx_id, index)
    key = "#{tx_id}_#{index}"
    return false unless @utxo_set.dig(key, :spent) == false
    @utxo_set[key][:spent] = true
  end

  def self.get_address_utxos(address)
    @utxo_set.select { |_, utxo| utxo[:address] == address && !utxo[:spent] }
  end

  def self.get_balance(address)
    get_address_utxos(address).sum { |_, utxo| utxo[:amount] }
  end

  def self.select_utxos_for_amount(address, target_amount)
    utxos = get_address_utxos(address).sort_by { |_, u| -u[:amount] }
    selected = []
    total = 0
    utxos.each do |id, utxo|
      selected << { id: id, amount: utxo[:amount] }
      total += utxo[:amount]
      break if total >= target_amount
    end
    total >= target_amount ? selected : []
  end
end
