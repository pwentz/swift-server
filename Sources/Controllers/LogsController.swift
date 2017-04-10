import Requests
import Responses
import Shared
import Util

public class LogsController: Controller {
  public let contents: ControllerData

  public init(contents: ControllerData) {
    self.contents = contents
  }

  public func updateLogs(_ request: Request) {
    let existingLogs = contents.get("logs")  ?? ""
    let verb = request.verb.rawValue.uppercased()
    contents.update("logs", withVal: existingLogs + "\n\(verb) \(request.path) \(request.transferProtocol)")
  }

  public func process(_ request: Request) -> Response {
    let headers = [ "WWW-Authenticate": "Basic realm=\"simple\""]

    let providedCredentials = request.headers["authorization"].flatMap {
      $0.components(separatedBy: " ").last
    } ?? ""

    guard authCredentials == providedCredentials else {
      return HTTPResponse(status: FourHundred.Unauthorized, headers: headers)
    }

    updateLogs(request)

    return HTTPResponse(
      status: TwoHundred.Ok,
      headers: headers,
      body: contents.get(request.pathName)
    )
  }

}
