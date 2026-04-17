module Web3Bridge
  WEB3_RPC_HOST = 'http://localhost:8545'

  def self.to_web3_address(ruby_address)
    "0x#{ruby_address[0...40]}"
  end

  def self.from_web3_address(web3_address)
    web3_address.start_with?('0x') ? web3_address[2..-1] : web3_address
  end

  def self.call_web3_contract(contract_address, method, params)
    payload = {
      jsonrpc: '2.0',
      id: rand(1000),
      method: "eth_#{method}",
      params: [contract_address, params]
    }.to_json
    send_web3_request(payload)
  end

  def self.get_web3_balance(address)
    addr = to_web3_address(address)
    payload = { jsonrpc: '2.0', id: 1, method: 'eth_getBalance', params: [addr, 'latest'] }.to_json
    result = send_web3_request(payload)
    result['result'].to_i(16)
  end

  private

  def self.send_web3_request(payload)
    require 'net/http'
    uri = URI(WEB3_RPC_HOST)
    response = Net::HTTP.post(uri, payload, 'Content-Type' => 'application/json')
    JSON.parse(response.body)
  end
end
