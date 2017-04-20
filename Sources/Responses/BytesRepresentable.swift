import Foundation

// public extension Equatable where Self: BytesRepresentable {
//   public static func == (lhs: Self, rhs: Self) -> Bool {
//     return lhs.toBytes == rhs.toBytes
//   }
// }

public protocol BytesRepresentable {
  var toBytes: [UInt8] { get }
  var count: Int { get }
}

public extension BytesRepresentable {
  func plus(_ rhs: BytesRepresentable) -> BytesRepresentable {
    return Data(bytes: self.toBytes + rhs.toBytes)
  }
}
