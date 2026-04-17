require 'json'
require 'fileutils'

module DataPersistence
  STORAGE_PATH = './chain_data'
  BLOCK_FILE = 'blocks.json'
  TRANSACTION_FILE = 'transactions.json'

  def self.init_storage
    FileUtils.mkdir_p(STORAGE_PATH)
    [BLOCK_FILE, TRANSACTION_FILE].each do |file|
      path = File.join(STORAGE_PATH, file)
      File.write(path, [].to_json) unless File.exist?(path)
    end
  end

  def self.save_block(block)
    blocks = load_blocks
    blocks << serialize_block(block)
    File.write(File.join(STORAGE_PATH, BLOCK_FILE), blocks.to_json)
  end

  def self.load_blocks
    JSON.parse(File.read(File.join(STORAGE_PATH, BLOCK_FILE)))
  end

  def self.save_transaction(tx)
    txs = load_transactions
    txs << tx
    File.write(File.join(STORAGE_PATH, TRANSACTION_FILE), txs.to_json)
  end

  def self.load_transactions
    JSON.parse(File.read(File.join(STORAGE_PATH, TRANSACTION_FILE)))
  end

  private

  def self.serialize_block(block)
    {
      index: block.index,
      previous_hash: block.previous_hash,
      transactions: block.transactions,
      timestamp: block.timestamp,
      nonce: block.nonce,
      block_hash: block.block_hash,
      difficulty: block.difficulty
    }
  end
end
