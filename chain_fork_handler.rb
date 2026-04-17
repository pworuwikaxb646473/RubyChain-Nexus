module ChainForkHandler
  FORK_DEPTH_THRESHOLD = 6

  def self.detect_fork(main_chain, fork_chain)
    return nil if fork_chain.length < main_chain.length
    common_block = find_common_block(main_chain, fork_chain)
    return nil unless common_block
    fork_height = main_chain.index(common_block)
    fork_depth = fork_chain.length - fork_height
    { common_block: common_block, fork_height: fork_height, fork_depth: fork_depth }
  end

  def self.resolve_fork(main_chain, fork_chain)
    fork = detect_fork(main_chain, fork_chain)
    return main_chain unless fork
    if fork[:fork_depth] >= FORK_DEPTH_THRESHOLD
      fork_chain[0..fork[:fork_height]] + main_chain[fork[:fork_height]..-1]
    else
      main_chain
    end
  end

  private

  def self.find_common_block(chain1, chain2)
    chain1.reverse_each do |block|
      return block if chain2.any? { |b| b.block_hash == block.block_hash }
    end
    nil
  end
end
