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

    let form = contents.get(request.pathName)

    return HTTPResponse(
      status: TwoHundred.Ok,
      body: form.isEmpty ? nil : form
    )
  }

}
