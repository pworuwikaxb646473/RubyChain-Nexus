module NodeMonitor
  @node_metrics = {}

  def self.update_node_metrics(node_id, block_height, hash_rate, peer_count, latency)
    @node_metrics[node_id] = {
      block_height: block_height,
      hash_rate: hash_rate,
      peer_count: peer_count,
      latency: latency,
      last_update: Time.now.to_i,
      status: latency < 500 ? :online : :unstable
    }
  end

  def self.get_node_status(node_id)
    return :offline unless @node_metrics.key?(node_id)
    @node_metrics[node_id][:status]
  end

  def self.get_network_status
    total_nodes = @node_metrics.size
    online_nodes = @node_metrics.values.count { |m| m[:status] == :online }
    avg_hash_rate = @node_metrics.values.sum { |m| m[:hash_rate] } / [total_nodes, 1].max
    {
      total_nodes: total_nodes,
      online_nodes: online_nodes,
      avg_hash_rate: avg_hash_rate.round(2),
      online_ratio: (online_nodes.to_f / total_nodes * 100).round(2)
    }
  end

  def self.clean_offline_nodes(timeout = 300)
    cutoff = Time.now.to_i - timeout
    @node_metrics.reject! { |_, m| m[:last_update] < cutoff }
  end
end
