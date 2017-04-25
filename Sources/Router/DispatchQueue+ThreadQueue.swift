import Foundation

extension DispatchQueue: ThreadQueue {

  public func async(_ closure: @escaping () -> Void) {
    self.async(execute: closure)
  }

}
