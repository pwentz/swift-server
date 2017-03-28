import Util
import Responses
import Requests

public class ControllerFactory {

  public static func process(_ request: Request) throws -> HTTPResponse {
    let publicDir = try CommandLineReader().publicDirectoryArgs()
    let contents = try FileReader(at: publicDir ?? "").read()
    LogsController.update(request)
    let path = request.path

    switch path {
    case "/logs":
      return LogsController.process(request)

    case let path where path.contains("cookie"):
      return CookieController.process(request)

    case "/":
      RootController.setData(contents: contents)
      return RootController.process(request)

    case let path where contents.keys.contains { file in path == "/\(file)" }:
      ResourcesController.setData(contents: contents)
      return ResourcesController.process(request)

    case "/foobar":
      return FoobarController.process(request)

    case "/coffee":
      return CoffeeController.process(request)

    case "/parameters":
      return ParametersController.process(request)

    case "/form":
      return FormController.process(request)

    case "/redirect":
      return RedirectController.process(request)

    case let path where path.contains("method_options"):
      return MethodOptionsController.process(request)

    default:
      return DefaultController.process(request)
    }
  }

}
