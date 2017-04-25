import Requests
import Responses
import Responders
import Util

public class Router {
  let port: UInt16
  let socket: Socket
  let threadQueue: ThreadQueue
  let responder: Respondable
  let dateHelper: DateHelper
  var onReceive: ((_ timestamp: String) -> (_ content: String) throws -> Void)?

  public init(socket: Socket, threadQueue: ThreadQueue, port: UInt16, responder: Respondable, dateHelper: DateHelper) {
    self.port = port
    self.socket = socket
    self.threadQueue = threadQueue
    self.responder = responder
    self.dateHelper = dateHelper
  }

  public func listen(onReceive: @escaping (_ timestamp: String) -> (_ content: String) throws -> Void) throws {
    self.onReceive = onReceive
    try socket.bind()
    try socket.listen()
  }

  public func receive() throws {
    let client = try socket.acceptSocket()
    let data = try client.recv()

    if !data.isEmpty {
      let request = HTTPRequest(for: try data.toString())
      let badRequestResponse = HTTPResponse(status: FourHundred.BadRequest)

      let response = request.map(responder.response) ?? badRequestResponse

      let timestamp = dateHelper.formatTimestamp(prefix: "SUCCESS")

      try onReceive.map { callback throws in
        let write = callback(timestamp)
        let printedResponse = String(response: response) ?? "Unreadable Response"
        let content = "REQUEST: \(try data.toString())\r\nRESPONSE: \(printedResponse)"
        try write(content)
      }

      dispatch(getDispatchCallback(response, client: client))
    }
  }

  internal func dispatch(_ callback: @escaping () -> Void) {
    threadQueue.async(callback)
  }

  internal func getDispatchCallback(_ response: HTTPResponse, client: Socket) -> () -> Void {
    return {
      try! client.send(data: response.format(dateHelper: self.dateHelper))
      try! client.close()
    }
  }

}
