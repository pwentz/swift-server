import SocksCore

do {
  let address = InternetAddress.any(port: 5000)
  let socket = try TCPInternetSocket(address: address)

  try socket.bind()
  try socket.listen()

  print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

  while true {
    let client = try socket.accept()

    let data = try client.recv()

    try client.send(data: data)

    try client.close()
    print("Client: \(client.address), Echoed: \(try data.toString())")
  }
} catch {
  print("Error \(error)")
}
