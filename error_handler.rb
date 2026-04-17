module ErrorHandler
  @error_log = []

  class ChainError < StandardError; end
  class TransactionError < ChainError; end
  class BlockError < ChainError; end
  class ConsensusError < ChainError; end
  class WalletError < ChainError; end

  def self.handle_error(error, context = {})
    error_data = {
      type: error.class.name,
      message: error.message,
      context: context,
      timestamp: Time.now.to_i,
      backtrace: error.backtrace&.first(5)
    }
    @error_log << error_data
    log_error(error_data)
    error_data
  end

  def self.log_error(data)
    puts "[ERROR] #{data[:type]}: #{data[:message]} | Context: #{data[:context]}"
  end

  def self.get_errors(type = nil)
    return @error_log unless type
    @error_log.select { |e| e[:type] == type }
  end

  def self.clear_errors
    @error_log.clear
  end

  def self.raise_transaction_error(msg)
    raise TransactionError, msg
  end

  def self.raise_block_error(msg)
    raise BlockError, msg
  end
end
