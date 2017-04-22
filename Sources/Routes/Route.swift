import Requests
import Responses

public struct Route {
  public let auth: String?
  public let cookiePrefix: String?
  public let includeLogs: Bool
  public let allowedMethods: [HTTPRequestMethod]
  public let includeDirectoryLinks: Bool
  public let redirectPath: String?
  public let customResponse: HTTPResponse?

  public init(allowedMethods: [HTTPRequestMethod], auth: String? = nil, cookiePrefix: String? = nil, includeLogs: Bool = false, includeDirectoryLinks: Bool = false, redirectPath: String? = nil) {
    self.allowedMethods = allowedMethods
    self.auth = auth
    self.cookiePrefix = cookiePrefix
    self.includeLogs = includeLogs
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
    return verb.map(allowedMethods.contains) ?? false
  }

}
