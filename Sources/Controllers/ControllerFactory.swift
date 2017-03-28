import Util
import Requests

public class ControllerFactory {

  public static func getController(_ request: Request) throws -> Controller {
    let publicDir = try CommandLineReader().publicDirectoryArgs()
    let contents = try FileReader(at: publicDir ?? "").read()
    LogsController.updateLogs(request)
    let path = request.path

    switch path {
    case "/logs":
      return LogsController()

    case let path where path.contains("cookie"):
      return CookieController()

    case "/":
      return RootController(contents: contents)

    case let path where contents.keys.contains { file in path == "/\(file)" }:
      return ResourcesController(contents: contents)

    case "/foobar":
      return FoobarController()

    case "/coffee":
      return CoffeeController()

    case "/parameters":
      return ParametersController()

    case "/form":
      return FormController()

    case "/redirect":
      return RedirectController()

    default:
      return DefaultController()
    }
  }

}