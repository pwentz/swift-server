import Requests
import Responses
import Controllers
import Util

public class Router {
  let port: UInt16
  let socket: Socket
  let persistedData: ControllerData
  let threadQueue: ThreadQueue

  public init(socket: Socket, data: ControllerData, threadQueue: ThreadQueue, port: UInt16) {
    self.port = port
    self.socket = socket
    self.persistedData = data
    self.threadQueue = threadQueue
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
      try dispatch(request, client: client)
    }

    if threadQueue.operationCount == threadQueue.maxConcurrentOperationCount {
      threadQueue.waitUntilAllOperationsAreFinished()
    }
  }

  private func dispatch(_ request: Request, client: Socket) throws {
    let controller = ControllerFactory.getController(request, with: persistedData)

    let response = controller.process(request)

    let newOperation = RespondOperation(response: response, client: client)

    threadQueue.add(operation: newOperation)
  }

}
