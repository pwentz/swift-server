import Foundation

public protocol Writable {
  func write<WriteableLocation>(to destination: WriteableLocation) throws
}
