import Requests
import Responses

public class FormController: PersistentDataController {
  static var formData: String = ""

  public static func update(_ request: Request) {
    if let body = request.body {
      formData = body
    }
    else if request.verb == "DELETE" {
      formData = ""
    }
  }

  public static func process(_ request: Request) -> HTTPResponse {
    update(request)

    let body = formData.isEmpty || request.verb != "GET" ? nil
                                                         : Array(formData.utf8)

    return Response(
      status: 200,
      headers: [:],
      body: body
    )
  }

}
