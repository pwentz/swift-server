import Foundation

extension OperationQueue: ThreadQueue {

  public func add(operation: RespondOperation) {
    self.addOperation(operation)
  }

}
