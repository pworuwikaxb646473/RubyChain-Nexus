require 'socket'
require 'json'

module P2PNode
  PORT = 3000
  @peers = []
  @node_socket = nil

  def self.start_node
    @node_socket = TCPServer.new(PORT)
    puts "P2P Node started on port #{PORT}"
    Thread.new { accept_connections }
  end

  def self.connect_peer(host, port)
    socket = TCPSocket.new(host, port)
    @peers << socket
    Thread.new { listen_peer(socket) }
  end

  def self.broadcast(data)
    @peers.each do |peer|
      send_data(peer, data)
    rescue StandardError
      @peers.delete(peer)
    end
  end

  private

  def self.accept_connections
    loop do
      client = @node_socket.accept
      @peers << client
      Thread.new { listen_peer(client) }
    end
  end

  def self.listen_peer(socket)
    while (line = socket.gets)
      handle_message(JSON.parse(line))
    end
  rescue StandardError
    @peers.delete(socket)
  end

  def self.send_data(socket, data)
    socket.puts(data.to_json)
  end

  def self.handle_message(msg)
    puts "Received message: #{msg['type']}"
  end
end
