public protocol ThreadQueue {
  func async(_ closure: @escaping () throws -> Void)
}
