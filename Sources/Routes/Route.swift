import Requests

public class Route {
  public let auth: String?
  public let cookiePrefix: String?
  public let includeLogs: Bool
  public let allowedMethods: [HTTPRequestMethod]
  public let includeDirectoryLinks: Bool
  public let redirectPath: String?

  public init(auth: String? = nil, cookiePrefix: String? = nil, includeLogs: Bool = false, allowedMethods: [HTTPRequestMethod], includeDirectoryLinks: Bool = false, redirectPath: String? = nil) {
    self.auth = auth
    self.cookiePrefix = cookiePrefix
    self.includeLogs = includeLogs
    self.allowedMethods = allowedMethods
    self.includeDirectoryLinks = includeDirectoryLinks
    self.redirectPath = redirectPath
  }
}
