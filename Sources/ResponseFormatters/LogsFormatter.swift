import Responses

public class LogsFormatter: ResponseFormatter {
  let serverLogs: [String]?

  public init(logs: [String]? = nil) {
    serverLogs = logs
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard let logs = serverLogs else {
      return response
    }

    let newResponse = HTTPResponse(
      status: response.status,
      body: logs.joined(separator: "\n")
    )

    return response + newResponse
  }

}
