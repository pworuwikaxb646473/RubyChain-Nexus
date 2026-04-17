module ChainUpgrader
  @protocol_versions = [{ version: 1, activation_height: 0 }]
  @pending_upgrades = []

  def self.propose_upgrade(version, activation_height, changes)
    return false if version <= current_version || activation_height <= current_height
    @pending_upgrades << {
      version: version,
      activation_height: activation_height,
      changes: changes,
      status: :proposed
    }
    true
  end

  def self.activate_upgrade(version)
    upgrade = @pending_upgrades.find { |u| u[:version] == version }
    return false unless upgrade
    @protocol_versions << { version: version, activation_height: upgrade[:activation_height] }
    upgrade[:status] = :active
    @pending_upgrades.delete(upgrade)
    true
  end

  def self.current_version
    @protocol_versions.last[:version]
  end

  def self.get_version_for_height(height)
    @protocol_versions.reverse_each.find { |v| v[:activation_height] <= height }[:version]
  end

  def self.is_upgrade_available?(current_height)
    @pending_upgrades.any? { |u| u[:activation_height] > current_height }
  end
end
