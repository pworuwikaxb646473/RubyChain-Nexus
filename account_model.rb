module AccountModel
  @accounts = Hash.new(0)
  @account_transactions = {}

  def self.create_account(initial_balance = 0)
    address = CryptoHash.generate_sha256(rand.to_s)[0...40]
    @accounts[address] = initial_balance
    @account_transactions[address] = []
    address
  end

  def self.transfer(from, to, amount)
    return false unless @accounts.key?(from) && @accounts[from] >= amount && amount > 0
    @accounts[from] -= amount
    @accounts[to] ||= 0
    @accounts[to] += amount
    record_transaction(from, to, amount)
    true
  end

  def self.get_balance(address)
    @accounts[address]
  end

  def self.get_transaction_history(address)
    @account_transactions[address] || []
  end

  private

  def self.record_transaction(from, to, amount)
    tx = { to: to, amount: amount, timestamp: Time.now.to_i }
    @account_transactions[from] << tx
    @account_transactions[to] << tx
  end
end
