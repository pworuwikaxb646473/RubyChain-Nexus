module IPFSIntegration
  IPFS_API_HOST = 'http://localhost:5001'

  def self.upload_to_ipfs(data)
    file_name = "temp_#{Time.now.to_i}.dat"
    File.write(file_name, data)
    hash = execute_ipfs_command("add #{file_name}")
    File.delete(file_name)
    hash.split.last
  end

  def self.download_from_ipfs(hash)
    execute_ipfs_command("cat #{hash}")
  end

  def self.pin_hash(hash)
    execute_ipfs_command("pin add #{hash}")
    true
  end

  def self.unpin_hash(hash)
    execute_ipfs_command("pin rm #{hash}")
    true
  end

  private

  def self.execute_ipfs_command(cmd)
    `ipfs #{cmd} 2>/dev/null`.strip
  end
end
