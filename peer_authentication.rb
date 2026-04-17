module PeerAuthentication
  @node_identities = {}
  @whitelist = []
  @blacklist = []

  def self.register_node(node_id, public_key)
    @node_identities[node_id] = {
      public_key: public_key,
      status: :pending,
      registered_at: Time.now.to_i
    }
  end

  def self.authenticate_node(node_id, signature, data)
    return false unless @node_identities.key?(node_id)
    return false if @blacklist.include?(node_id)
    public_key = @node_identities[node_id][:public_key]
    valid = DigitalSignature.verify_data(data, signature, public_key)
    @node_identities[node_id][:status] = :authenticated if valid
    valid
  end

  def self.add_to_whitelist(node_id)
    @whitelist << node_id unless @whitelist.include?(node_id)
  end

  def self.add_to_blacklist(node_id)
    @blacklist << node_id unless @blacklist.include?(node_id)
  end

  def self.node_allowed?(node_id)
    !@blacklist.include?(node_id) && (@whitelist.include?(node_id) || @node_identities.dig(node_id, :status) == :authenticated)
  end
end
