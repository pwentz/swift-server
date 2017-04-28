import Foundation
import Dispatch

extension DispatchQueue: ThreadQueue {

  public func async(_ closure: @escaping () -> Void) {
    self.async(execute: closure)
  }

}
