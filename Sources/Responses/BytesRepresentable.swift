import Foundation

public protocol BytesRepresentable {
  var toBytes: [UInt8] { get }
  var count: Int { get }
}

public extension BytesRepresentable {

  func plus(_ rhs: BytesRepresentable?) -> BytesRepresentable {
    return Data(bytes: self.toBytes + (rhs?.toBytes ?? []))
  }

}

public func + (lhs: BytesRepresentable, rhs: BytesRepresentable?) -> BytesRepresentable {
  return lhs.plus(rhs)
}
