import Router

class MockOperationQueue: ThreadQueue {
  var operations: [RespondOperation] = []
  var wasWaitMethodCalled: Bool = false

  var maxConcurrentOperationCount: Int = 0

  var operationCount: Int {
    return operations.count
  }

  func add(operation: RespondOperation) {
    operations.append(operation)
  }

  func waitUntilAllOperationsAreFinished() {
    wasWaitMethodCalled = true
  }
}

