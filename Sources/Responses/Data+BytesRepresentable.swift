import Foundation

extension Data: BytesRepresentable {
  public var toBytes: [UInt8] {
    return [UInt8](self)
  }

}

extension Data {
  // public static func == (lhs: BytesRepresentable, rhs: Data) -> Bool {
  //   return lhs.toBytes == rhs.toBytes
  // }
}
