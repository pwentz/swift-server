import Requests
import Responses
import Util

public class LogsController: PersistentDataController {
  static var aggregateLogs: [String] = []

  public static func update(_ request: Request) {
    aggregateLogs.append("\(request.verb) \(request.path) HTTP/1.1")
  }

  public static func process(_ request: Request) -> HTTPResponse {
    let auth = request.headers["authorization"].map { $0.components(separatedBy: " ").last ?? "" }

    let combinedLogs = aggregateLogs.joined(separator: "\n")

    let status = getBase64(of: authCredentials).map { auth == $0 ? 200 : 401 } ?? 401

    let body: [UInt8]? = status == 200 ? Array(combinedLogs.utf8) : nil

    let headers = ["WWW-Authenticate": "Basic realm=\"simple\""]

    return Response(
      status: status,
      headers: headers,
      body: body
    )
  }

}
