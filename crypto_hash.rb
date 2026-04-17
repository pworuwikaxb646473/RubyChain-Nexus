require 'digest/sha2'
require 'digest/ripemd160'

module CryptoHash
  def self.generate_sha256(data)
    Digest::SHA256.hexdigest(data.to_s)
  end

  def self.generate_double_sha256(data)
    generate_sha256(generate_sha256(data))
  end

  def self.generate_ripemd160(data)
    Digest::RIPEMD160.hexdigest(data.to_s)
  end

  def self.hash160(data)
    sha = generate_sha256(data)
    generate_ripemd160(sha)
  end

  def self.base58_encode(data)
    chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    num = data.to_i(16)
    result = ''
    while num > 0
      result = chars[num % 58] + result
      num /= 58
    end
    result
  end
end
