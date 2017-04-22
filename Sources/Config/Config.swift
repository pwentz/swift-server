import Responses
import Routes

public let logsPath = "/Users/patrickwentz/8th-light/projects/swift/server/Sources/Server/Debug"
public let authCredentials = "YWRtaW46aHVudGVyMg=="
public let defaultPort: UInt16 = 5000

public var routes: [String: Route] = [
  "/logs": Route(allowedMethods: [.Get], auth: authCredentials, includeLogs: true),
  "/log": Route(allowedMethods: [.Get]),
  "/these": Route(allowedMethods: [.Put]),
  "/requests": Route(allowedMethods: [.Head]),
  "/cookie": Route(allowedMethods: [.Get], cookiePrefix: "Eat"),
  "/eat_cookie": Route(allowedMethods: [.Get], cookiePrefix: "mmmm"),
  "/coffee": Route(
    allowedMethods: [.Get],
    customResponse: HTTPResponse(status: FourHundred.Teapot, body: "I'm a teapot")),
  "/tea": Route(allowedMethods: [.Get]),
  "/parameters": Route(allowedMethods: [.Get]),
  "/form": Route(allowedMethods: [.Get, .Post, .Put, .Delete]),
  "/redirect": Route(allowedMethods: [.Get], redirectPath: "/"),
  "/": Route(allowedMethods: [.Get, .Head], includeDirectoryLinks: true),
  "/method_options": Route(allowedMethods: [.Options, .Get, .Head, .Post, .Put]),
  "/method_options2": Route(allowedMethods: [.Options, .Get])
]
