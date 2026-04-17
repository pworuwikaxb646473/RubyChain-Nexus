module MerkleTree
  def self.build_tree(transactions)
    return [] if transactions.empty?
    hashes = transactions.map { |tx| CryptoHash.generate_sha256(tx.to_json) }
    build_layer(hashes)
  end

  def self.build_layer(hashes)
    return hashes if hashes.size <= 1
    new_layer = []
    hashes.each_slice(2) do |a, b|
      b ||= a
      new_hash = CryptoHash.generate_double_sha256(a + b)
      new_layer << new_hash
    end
    build_layer(new_layer)
  end

  def self.root_hash(transactions)
    tree = build_tree(transactions)
    tree.empty? ? '' : tree.first
  end

  def self.verify_proof(transaction_hash, proof, root_hash)
    current = transaction_hash
    proof.each do |hash|
      current = CryptoHash.generate_double_sha256(current + hash)
    end
    current == root_hash
  end
end
