import Router

class MockOperationQueue: ThreadQueue {
  var wasAsyncMethodCalled: Bool = false

  func async(_ closure: @escaping () -> Void) {
    wasAsyncMethodCalled = true
    closure()
  }

}
