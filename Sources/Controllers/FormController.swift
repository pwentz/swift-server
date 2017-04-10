import Requests
import Responses
import Util

public class FormController: Controller {
  let contents: ControllerData

  public init(contents: ControllerData) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    guard request.verb == .Get else {
      contents.update(request.pathName, withVal: request.body ?? "")

      return HTTPResponse(status: TwoHundred.Ok)
    }

    return HTTPResponse(
      status: TwoHundred.Ok,
      body: contents.get(request.pathName).flatMap { $0.isEmpty ? nil : $0 }
    )
  }

}
