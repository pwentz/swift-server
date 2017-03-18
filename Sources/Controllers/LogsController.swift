import Requests
import Responses
import Util

public class LogsController: Controller {
  static public func process(_ request: Request) -> Response {
    let auth = request.headers["authorization"].map { $0.components(separatedBy: " ").last ?? "" }

    let status = auth == getBase64(of: "admin:hunter2") ? 200 : 401

    let headers = ["WWW-Authenticate" : "Basic realm=\"simple\""]

    return Response(status: status, headers: headers, body: "")
  }
}
