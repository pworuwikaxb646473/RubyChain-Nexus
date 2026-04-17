require 'json'
require 'fileutils'

module StateDatabase
  DB_PATH = './state_db'
  META_FILE = 'meta.json'

  def self.init_db
    FileUtils.mkdir_p(DB_PATH)
    meta_path = File.join(DB_PATH, META_FILE)
    File.write(meta_path, { last_block: 0, updated_at: Time.now.to_i }.to_json) unless File.exist?(meta_path)
  end

  def self.put_state(key, value)
    path = File.join(DB_PATH, "#{key}.json")
    File.write(path, value.to_json)
    update_meta
  end

  def self.get_state(key)
    path = File.join(DB_PATH, "#{key}.json")
    return nil unless File.exist?(path)
    JSON.parse(File.read(path))
  end

  def self.delete_state(key)
    path = File.join(DB_PATH, "#{key}.json")
    File.delete(path) if File.exist?(path)
  end

  def self.get_meta
    JSON.parse(File.read(File.join(DB_PATH, META_FILE)))
  end

  private

  def self.update_meta
    meta = get_meta
    meta['last_block'] += 1
    meta['updated_at'] = Time.now.to_i
    File.write(File.join(DB_PATH, META_FILE), meta.to_json)
  end
end
