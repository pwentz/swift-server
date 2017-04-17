import Responses
import Util

public class LogsFormatter: ResponseFormatter {
  let serverLogs: [String]?

  public init(logs: [String]? = nil) {
    serverLogs = logs
  }

  public func execute(on response: inout HTTPResponse) {
    guard let logs = serverLogs else {
      return
    }

    response.appendToBody(logs.joined(separator: "\n"))
  }
}
