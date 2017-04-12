public class Route {
  public let auth: String?
  public let setCookie: Bool
  public let includeLogs: Bool

  public init(auth: String?, setCookie: Bool, includeLogs: Bool) {
    self.auth = auth
    self.setCookie = setCookie
    self.includeLogs = includeLogs
  }
}
