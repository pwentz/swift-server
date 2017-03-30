import Requests
import Responses
import Util

public class FormController: Controller {
  let contents: ControllerData

  public init(contents: ControllerData) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    guard request.verb == "GET" else {
      contents.update(request.pathName, withVal: request.body ?? "")

      return Response(status: TwoHundred.Ok, headers: [:], body: nil)
    }

    let form = contents.get(request.pathName)

    return Response(
      status: TwoHundred.Ok,
      headers: [:],
      body: form.isEmpty ? nil : Array(form.utf8)
    )
  }

}
