import Foundation
import SocksCore

public protocol Socket {
  func send(data: [UInt8]) throws

  func close() throws
}

extension TCPInternetSocket: Socket {}
