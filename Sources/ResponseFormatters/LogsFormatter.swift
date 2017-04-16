import Responses
import Requests
import Util

public class LogsFormatter: ResponseFormatter {
  let request: HTTPRequest
  let logs: [String]?

  public init(for request: HTTPRequest, logs: [String]? = nil) {
    self.request = request
    self.logs = logs
  }

  public func execute(on response: inout HTTPResponse) {
    logs.map { serverLogs in
      response.appendToBody(serverLogs.joined(separator: "\n"))
    }
  }
}
