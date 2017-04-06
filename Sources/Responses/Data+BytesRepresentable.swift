import Foundation

extension Data: BytesRepresentable {
  public var toBytes: [UInt8] {
    return [UInt8](self)
  }
}
