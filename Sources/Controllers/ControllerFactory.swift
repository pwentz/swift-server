import Util
import Requests

public class ControllerFactory {

  public static func getController(_ request: Request, with data: ControllerData) -> Controller {
    LogsController(contents: data).updateLogs(request)

    let path = request.path

    switch path {
    case "/logs":
      return LogsController(contents: data)

    case let path where path.contains("cookie"):
      return CookieController()

    case "/":
      return RootController(contents: data)

    case let path where data.fileNames().contains { path == "/\($0)" }:
      return ResourcesController(contents: data)

    case "/foobar":
      return FoobarController()

    case "/coffee":
      return CoffeeController()

    case "/parameters":
      return ParametersController()

    case "/form":
      return FormController(contents: data)

    case "/redirect":
      return RedirectController()

    case let path where path.contains("method_options"):
      return MethodOptionsController()

    default:
      return DefaultController()
    }
  }

}
