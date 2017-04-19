import Foundation

public extension Array where Element == UInt8 {
  var toData: Data {
    return Data(bytes: self)
  }
}
