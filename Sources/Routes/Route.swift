import Requests

public class Route {
  public let auth: String?
  public let setCookie: Bool
  public let includeLogs: Bool
  public let allowedMethods: [HTTPRequestMethod]

  public init(auth: String?, setCookie: Bool, includeLogs: Bool, allowedMethods: [HTTPRequestMethod]) {
    self.auth = auth
    self.setCookie = setCookie
    self.includeLogs = includeLogs
    self.allowedMethods = allowedMethods
  }
}
