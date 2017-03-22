import Requests
import Responses
import Util

public class LogsController: Controller {
  let logs: [String]

  public init(_ logs: [String]) {
    self.logs = logs
  }

  public func process(_ request: Request) -> Response {
    let auth = request.headers["authorization"].map { $0.components(separatedBy: " ").last ?? "" }

    let combinedLogs = logs.reduce("") { $0 + ($1 + "\n") } +
                       "\(request.verb) \(request.path) HTTP/1.1"

    let status = auth == getBase64(of: "admin:hunter2") ? 200 : 401
    let body = status == 200 ? combinedLogs : ""

    let headers = ["WWW-Authenticate": "Basic realm=\"simple\""]


    return Response(status: status, headers: headers, body: body)
  }

}
