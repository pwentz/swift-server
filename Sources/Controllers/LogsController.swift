import Requests
import Responses
import Util

public class LogsController: Controller {
  public let contents: ControllerData

  public init(contents: ControllerData) {
    self.contents = contents
  }

  public func updateLogs(_ request: Request) {
    let existingLogs = contents.get("logs")
    contents.update("logs", withVal: existingLogs + "\n\(request.verb) \(request.path) HTTP/1.1")
  }

  public func process(_ request: Request) -> Response {
    let pathName = request.path.substring(from: request.path.index(after: request.path.startIndex))

    updateLogs(request)

    let auth = request.headers["authorization"].map { $0.components(separatedBy: " ").last ?? "" }

    let status = getBase64(of: authCredentials).map { auth == $0 ? 200 : 401 } ?? 401

    let body: [UInt8]? = status == 200 ? contents.getBinary(pathName) : nil

    let headers = ["WWW-Authenticate": "Basic realm=\"simple\""]

    return Response(
      status: status,
      headers: headers,
      body: body
    )
  }

}
