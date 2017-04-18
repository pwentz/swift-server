import Foundation

public extension Sequence where Iterator.Element == UInt8 {
  var toData: Data {
    // type cast as workaround to bug fixed in Swift 3.1
    return Data(bytes: self as! [UInt8])
  }
}
