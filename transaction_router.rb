module TransactionRouter
  @node_load = Hash.new(0)
  ROUTE_THRESHOLD = 80

  def self.register_node(node_id, max_load)
    @node_load[node_id] = { current: 0, max: max_load }
  end

  def self.route_transaction(transaction)
    target_node = select_available_node
    return :no_available_nodes unless target_node
    @node_load[target_node][:current] += 1
    { node: target_node, status: :routed }
  end

  def self.release_node_load(node_id)
    return false unless @node_load.key?(node_id)
    @node_load[node_id][:current] = [@node_load[node_id][:current] - 1, 0].max
  end

  private

  def self.select_available_node
    @node_load.each do |id, load|
      usage = (load[:current].to_f / load[:max] * 100).round
      return id if usage < ROUTE_THRESHOLD
    end
    nil
  end
end
