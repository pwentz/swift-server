import Requests
import Responses

public class FormController: Controller {
  static var formData: String = ""
  let form: String

  public init() {
    self.form = FormController.formData
  }

  static public func updateForm(_ request: Request) {
    if let body = request.body {
      formData = body
    }
    else if request.verb == "DELETE" {
      formData = ""
    }
  }

  public func process(_ request: Request) -> Response {
    FormController.updateForm(request)

    let body = form.isEmpty || request.verb != "GET" ? nil : Array(form.utf8)

    return Response(
      status: 200,
      headers: [:],
      body: body
    )
  }
}
