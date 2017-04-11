import Foundation

extension DispatchQueue: ThreadQueue {

  public func async(_ closure: @escaping () throws -> Void) {
    let errorHandledClosure: () -> Void = {
      do { try closure() } catch {  }
    }

    self.async(execute: errorHandledClosure)
  }

}
