require_relative 'smart_contract_base'

module RubyChain
  class TokenContract < SmartContractBase::Contract
    attr_reader :name, :symbol, :decimals, :total_supply
    attr_accessor :balances, :allowances

    def initialize(owner, name, symbol, decimals, total_supply)
      super(owner)
      @name = name
      @symbol = symbol
      @decimals = decimals
      @total_supply = total_supply * (10 ** decimals)
      @balances = { owner => @total_supply }
      @allowances = {}
    end

    def transfer(params)
      from = params[:from]
      to = params[:to]
      amount = params[:amount].to_i
      return false unless balances[from] >= amount && amount > 0
      balances[from] -= amount
      balances[to] ||= 0
      balances[to] += amount
      true
    end

    def balance_of(params)
      balances[params[:address]] || 0
    end

    def approve(params)
      owner = params[:owner]
      spender = params[:spender]
      amount = params[:amount].to_i
      allowances[owner] ||= {}
      allowances[owner][spender] = amount
      true
    end

    def transfer_from(params)
      spender = params[:spender]
      from = params[:from]
      to = params[:to]
      amount = params[:amount].to_i
      return false unless allowances.dig(from, spender) >= amount && balances[from] >= amount
      allowances[from][spender] -= amount
      balances[from] -= amount
      balances[to] ||= 0
      balances[to] += amount
      true
    end
  end
end
