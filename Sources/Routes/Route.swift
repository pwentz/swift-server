import Requests
import Responses

public class Route {
  public let auth: String?
  public let cookiePrefix: String?
  public let includeLogs: Bool
  public let allowedMethods: [HTTPRequestMethod]
  public let includeDirectoryLinks: Bool
  public let redirectPath: String?
  public let customResponse: HTTPResponse?

  public init(auth: String? = nil, cookiePrefix: String? = nil, includeLogs: Bool = false, allowedMethods: [HTTPRequestMethod], includeDirectoryLinks: Bool = false, redirectPath: String? = nil) {
    self.auth = auth
    self.cookiePrefix = cookiePrefix
    self.includeLogs = includeLogs
    self.allowedMethods = allowedMethods
    self.includeDirectoryLinks = includeDirectoryLinks
    self.redirectPath = redirectPath
    self.customResponse = nil
  }

  public init(allowedMethods: [HTTPRequestMethod], customResponse: HTTPResponse) {
    self.auth = nil
    self.cookiePrefix = nil
    self.includeLogs = false
    self.includeDirectoryLinks = false
    self.redirectPath = nil
    self.allowedMethods = allowedMethods
    self.customResponse = customResponse
  }

  public func canRespondTo(_ verb: HTTPRequestMethod?) -> Bool {
    return verb.map { self.allowedMethods.contains($0) } ?? false
  }
}
