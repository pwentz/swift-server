import Router

class MockOperationQueue: ThreadQueue {
  var wasAsyncMethodCalled: Bool = false

  func async(_ closure: @escaping () throws -> Void) {
    wasAsyncMethodCalled = true
    try! closure()
  }

}
