public protocol ThreadQueue {
  func async(_ closure: @escaping () -> Void)
}
