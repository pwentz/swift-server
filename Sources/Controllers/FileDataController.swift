protocol FileDataController: Controller {
  static func setData(contents: [String: [UInt8]])
}
