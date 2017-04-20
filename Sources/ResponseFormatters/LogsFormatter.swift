import Responses
import Util

public class LogsFormatter: ResponseFormatter {
  let serverLogs: [String]?

  public init(logs: [String]? = nil) {
    serverLogs = logs
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard let logs = serverLogs else {
      return response
    }

    return HTTPResponse(
      status: TwoHundred.Ok,
      headers: response.headers,
      body: response.updateBody(with: logs.joined(separator: "\n"))
    )
  }

}
