module ChainSync
  def self.sync_chain(local_chain, remote_chain)
    return local_chain if remote_chain.length <= local_chain.length
    return local_chain unless valid_chain?(remote_chain)
    remote_chain
  end

  def self.valid_chain?(chain)
    return false if chain.empty?
    chain.each_with_index do |block, index|
      next if index == 0
      return false unless valid_block?(block, chain[index - 1])
    end
    true
  end

  def self.valid_block?(new_block, previous_block)
    return false if new_block.index != previous_block.index + 1
    return false if new_block.previous_hash != previous_block.block_hash
    return false unless new_block.valid?
    true
  end

  def self.resolve_conflicts(chains)
    longest_chain = chains.max_by { |chain| chain.length }
    valid_chain?(longest_chain) ? longest_chain : nil
  end
end
