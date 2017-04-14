import Foundation
import SocksCore
import Router
import Util
import Errors
import Shared
import Requests
import Responses
import FileIO
import Routes
import Responders

let defaultPort: UInt16 = 5000
let reader = CommandLineReader(args: CommandLine.arguments)
var contents: [String: Data] = [:]

do {
  let port = try reader.portArgs() ?? defaultPort

  let address = InternetAddress.localhost(port: port)
  let socket = try TCPInternetSocket(address: address)

  let publicDir = try reader.publicDirectoryArgs() ?? ""
  let fileNames = try DirectoryReader(FileManager.default).getFileNames(at: publicDir)

  for file in fileNames {
    contents[file] = try Data(contentsOf: URL(fileURLWithPath: publicDir + "/" + file))
  }

  let persistedData = ControllerData(contents)

  let customTeapotResponse = HTTPResponse(status: FourHundred.Teapot, body: "I'm a teapot")

  var routes: [String: Route] = [
    "/logs": Route(auth: authCredentials, includeLogs: true, allowedMethods: [.Get]),
    "/log": Route(allowedMethods: [.Get]),
    "/these": Route(allowedMethods: [.Put]),
    "/requests": Route(allowedMethods: [.Head]),
    "/cookie": Route(cookiePrefix: "Eat", allowedMethods: [.Get]),
    "/eat_cookie": Route(cookiePrefix: "mmmm", allowedMethods: [.Get]),
    "/coffee": Route(allowedMethods: [.Get], customResponse: customTeapotResponse),
    "/tea": Route(allowedMethods: [.Get]),
    "/parameters": Route(allowedMethods: [.Get]),
    "/form": Route(allowedMethods: [.Get, .Post, .Put, .Delete]),
    "/redirect": Route(allowedMethods: [.Get], redirectPath: "/"),
    "/": Route(allowedMethods: [.Get, .Head], includeDirectoryLinks: true),
    "/method_options": Route(allowedMethods: [.Options, .Get, .Head, .Post, .Put]),
    "/method_options2": Route(allowedMethods: [.Options, .Get])
  ]

  persistedData.fileNames.forEach {
    routes["/\($0)"] = Route(allowedMethods: [.Get, .Patch])
  }

  let responder = RouteResponder(routes: routes, data: persistedData)

  let router = Router(socket: socket, data: persistedData, threadQueue: DispatchQueue.global(qos: .userInteractive), port: port, responder: responder)

  try router.listen()

  while true {
    try router.receive()
  }
} catch {
  let fileName = DateHelper(today: Date(), calendar: Calendar.current, formatter: DateFormatter()).formatTimestamp(prefix: "FAILURE")
  let urlPath = URL(fileURLWithPath: logsPath + "/" + fileName).appendingPathExtension("txt")
  try urlPath.write(writableContent: "ERROR: \(error)\r\nARGS: \(reader.join("\r\n"))")

  throw error
}
