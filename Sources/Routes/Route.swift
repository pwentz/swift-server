import Requests

public class Route {
  public let auth: String?
  public let cookiePrefix: String?
  public let includeLogs: Bool
  public let allowedMethods: [HTTPRequestMethod]
  public let includeDirectoryLinks: Bool

  public init(auth: String?, cookiePrefix: String? = nil, includeLogs: Bool = false, allowedMethods: [HTTPRequestMethod], includeDirectoryLinks: Bool = false) {
    self.auth = auth
    self.cookiePrefix = cookiePrefix
    self.includeLogs = includeLogs
    self.allowedMethods = allowedMethods
    self.includeDirectoryLinks = includeDirectoryLinks
  }
}
