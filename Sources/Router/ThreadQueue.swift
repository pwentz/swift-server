public protocol ThreadQueue {
  var operationCount: Int { get }
  var maxConcurrentOperationCount: Int { get }

  func add(operation: RespondOperation)

  func waitUntilAllOperationsAreFinished()
}
