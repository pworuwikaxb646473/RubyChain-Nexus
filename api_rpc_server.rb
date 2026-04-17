require 'webrick'
require 'json'

module APIRPCServer
  SERVER_PORT = 8080

  def self.start_server(blockchain)
    server = WEBrick::HTTPServer.new(Port: SERVER_PORT)
    server.mount_proc('/api/block/latest') do |req, res|
      res.body = blockchain.last.to_json
      res.content_type = 'application/json'
    end

    server.mount_proc('/api/block/:height') do |req, res|
      height = req.path_info[:height].to_i
      block = blockchain[height]
      res.body = block ? block.to_json : { error: 'not found' }.to_json
    end

    server.mount_proc('/api/wallet/balance') do |req, res|
      addr = req.query['address']
      balance = WalletCore.get_balance(addr, blockchain)
      res.body = { address: addr, balance: balance }.to_json
    end

    trap('INT') { server.shutdown }
    puts "RPC Server running on port #{SERVER_PORT}"
    server.start
  end
end
