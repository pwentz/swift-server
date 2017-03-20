import Util

public class ControllerFactory {
  public static func getController(_ path: String, logs: [String]) throws -> Controller {
    let contents = try CommandLineReader().getPublicDirectoryContents()

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

    default:
      return DefaultController()
    }
  }
}
