import Util

public class ControllerFactory {

  public static func getController(_ path: String, logs: [String]) throws -> Controller {
    let publicDir = try CommandLineReader().publicDirectoryArgs()
    let contents = try FileReader(at: publicDir ?? "").read()

    switch path {
    case "/logs":
      return LogsController(logs)

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

    default:
      return DefaultController()
    }
  }

}
