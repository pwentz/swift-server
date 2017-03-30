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
    let headers = [ "WWW-Authenticate": "Basic realm=\"simple\""]
    let providedAuth = getBase64(of: authCredentials)!

    let auth = request.headers["authorization"].flatMap {
      $0.components(separatedBy: " ").last
    } ?? ""

    guard providedAuth == auth else {
      return Response(status: FourHundred.Unauthorized, headers: headers, body: nil)
    }

    updateLogs(request)

    return Response(
      status: TwoHundred.Ok,
      headers: headers,
      body: contents.getBinary(request.pathName)
    )
  }

}
