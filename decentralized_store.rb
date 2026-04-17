module DecentralizedStore
  CHUNK_SIZE = 1024
  @storage_nodes = []
  @file_index = {}

  def self.register_node(node_id, host, port)
    @storage_nodes << { id: node_id, host: host, port: port, status: :active }
  end

  def self.store_file(file_data)
    chunks = split_file(file_data)
    chunk_hashes = []
    chunks.each do |chunk|
      hash = store_chunk(chunk)
      chunk_hashes << hash
    end
    file_hash = MerkleTree.root_hash(chunk_hashes)
    @file_index[file_hash] = chunk_hashes
    file_hash
  end

  def self.retrieve_file(file_hash)
    return nil unless @file_index.key?(file_hash)
    chunks = @file_index[file_hash].map { |h| retrieve_chunk(h) }
    chunks.join
  end

  private

  def self.split_file(data)
    data.chars.each_slice(CHUNK_SIZE).map(&:join)
  end

  def self.store_chunk(chunk)
    hash = CryptoHash.generate_sha256(chunk)
    node = @storage_nodes.sample
    puts "Stored chunk #{hash} on node #{node[:id]}"
    hash
  end

  def self.retrieve_chunk(hash)
    "chunk_data_#{hash}"
  end
end
