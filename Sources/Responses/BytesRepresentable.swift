import Foundation

public protocol BytesRepresentable {
  var toBytes: [UInt8] { get }
  var count: Int { get }
}

public func + (lhs: BytesRepresentable, rhs: BytesRepresentable?) -> BytesRepresentable {
  return Data(bytes: lhs.toBytes + (rhs?.toBytes ?? []))
}
