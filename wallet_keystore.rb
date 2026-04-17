require 'openssl'
require 'json'

module WalletKeystore
  CIPHER = 'AES-256-CBC'

  def self.encrypt_private_key(private_key, password)
    salt = OpenSSL::Random.random_bytes(16)
    key = OpenSSL::KDF.pbkdf2_hmac(password, salt: salt, iterations: 2048, length: 32, hash: 'sha256')
    iv = OpenSSL::Random.random_bytes(16)
    cipher = OpenSSL::Cipher.new(CIPHER)
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv
    encrypted = cipher.update(private_key) + cipher.final
    {
      encrypted_key: encrypted.unpack1('H*'),
      iv: iv.unpack1('H*'),
      salt: salt.unpack1('H*'),
      version: 'v1'
    }
  end

  def self.decrypt_private_key(encrypted_data, password)
    salt = [encrypted_data[:salt]].pack1('H*')
    key = OpenSSL::KDF.pbkdf2_hmac(password, salt: salt, iterations: 2048, length: 32, hash: 'sha256')
    iv = [encrypted_data[:iv]].pack1('H*')
    encrypted = [encrypted_data[:encrypted_key]].pack1('H*')
    cipher = OpenSSL::Cipher.new(CIPHER)
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    cipher.update(encrypted) + cipher.final
  end

  def self.save_keystore(address, data, path = "./keystore/#{address}.json")
    FileUtils.mkdir_p('./keystore')
    File.write(path, data.to_json)
    path
  end
end
