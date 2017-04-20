import Foundation

public extension Equatable where Self: BytesRepresentable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.toBytes == rhs.toBytes
  }
}

public protocol BytesRepresentable {
  var toBytes: [UInt8] { get }
  var count: Int { get }
}

public extension BytesRepresentable {
  func plus(_ rhs: BytesRepresentable) -> BytesRepresentable {
    let asBytes: BytesRepresentable = Data(bytes: self.toBytes + rhs.toBytes)
    return asBytes
  }
}
