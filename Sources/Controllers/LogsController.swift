import Requests
import Responses
import Util

public class LogsController {
  let request: Request

  public init(_ request: Request) {
    self.request = request
  }

  public func process(logs: [String]) -> Response {
    let auth = request.headers["authorization"].map { $0.components(separatedBy: " ").last ?? "" }

    let status = auth == getBase64(of: "admin:hunter2") ? 200 : 401

    let headers = ["WWW-Authenticate" : "Basic realm=\"simple\""]

    let body = logs.reduce("", { $0 + ($1 + "\n") }) +
                "\(request.verb) \(request.path) HTTP/1.1"

    return Response(status: status, headers: headers, body: body)
  }
}
