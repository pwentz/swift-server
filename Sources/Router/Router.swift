import Requests
import Responses
import Controllers
import Util
import Responders

public class Router {
  let port: UInt16
  let socket: Socket
  let persistedData: ControllerData
  let threadQueue: ThreadQueue
  let responder: Responder?

  public init(socket: Socket, data: ControllerData, threadQueue: ThreadQueue, port: UInt16, responder: Responder? = nil) {
    self.port = port
    self.socket = socket
    self.persistedData = data
    self.threadQueue = threadQueue
    self.responder = responder
  }

  public func listen() throws {
    try socket.bind()
    try socket.listen()
  }

  public func receive() throws {
    let client = try socket.acceptSocket()
    let data = try client.recv()

    if !data.isEmpty {
      let request = try HTTPRequest(for: data.toString())
      let response = responder?.responses(for: request).flatMap { $0 }.first ?? factoryResponse(request)

      dispatch(getDispatchCallback(response, client: client))
    }
  }

  internal func dispatch(_ callback: @escaping () throws -> Void) {
    threadQueue.async(callback)
  }

  internal func getDispatchCallback(_ response: Response, client: Socket) -> () throws -> Void {
    return {
      try client.send(data: response.formatted)
      try client.close()
    }
  }

  private func factoryResponse(_ request: Request) -> Response {
    let controller = ControllerFactory.getController(request, with: persistedData)
    return controller.process(request)
  }

}
