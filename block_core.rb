module RubyChain
  class Block
    attr_reader :index, :previous_hash, :transactions, :timestamp, :nonce, :block_hash
    attr_accessor :difficulty

    def initialize(index, previous_hash, transactions, difficulty)
      @index = index
      @previous_hash = previous_hash
      @transactions = transactions
      @difficulty = difficulty
      @timestamp = Time.now.to_i
      @nonce = 0
      @block_hash = calculate_hash
    end

    def calculate_hash
      data = "#{index}#{previous_hash}#{transactions.to_json}#{timestamp}#{nonce}#{difficulty}"
      CryptoHash.generate_sha256(data)
    end

    def mine_block
      target = '0' * difficulty
      while block_hash[0...difficulty] != target
        @nonce += 1
        @block_hash = calculate_hash
      end
      self
    end

    def valid?
      calculate_hash == block_hash
    end
  end
end
