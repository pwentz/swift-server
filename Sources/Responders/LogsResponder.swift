import Responses
import Requests
import Util

class LogsResponder: ResponseFormatter {
  let request: Request
  let logs: [String]?

  public init(for request: Request, logs: [String]? = nil) {
    self.request = request
    self.logs = logs
  }

  func execute(on response: inout HTTPResponse) {
    logs.map { serverLogs in
      if !isAnImage(request.path) {
        response.appendToBody(serverLogs.joined(separator: "\n"))
      }
    }
  }
}
