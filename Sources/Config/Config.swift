import Responses
import Routes

public var routes: [String: Route] = [
  "/logs": Route(auth: authCredentials, includeLogs: true, allowedMethods: [.Get]),
  "/log": Route(allowedMethods: [.Get]),
  "/these": Route(allowedMethods: [.Put]),
  "/requests": Route(allowedMethods: [.Head]),
  "/cookie": Route(cookiePrefix: "Eat", allowedMethods: [.Get]),
  "/eat_cookie": Route(cookiePrefix: "mmmm", allowedMethods: [.Get]),
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

public let logsPath = "/Users/patrickwentz/8th-light/projects/swift/server/Sources/Server/Debug"
public let defaultPublicDirPath = "/Users/patrickwentz/cob_spec/public"
public let authCredentials = "YWRtaW46aHVudGVyMg=="
