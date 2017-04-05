import Requests
import Controllers
import SocksCore
import Responses
import Foundation
import Util

class RespondOperation: Operation {
  override var isAsynchronous: Bool {
    return true
  }

  override var isConcurrent: Bool {
    return true
  }

  override var isExecuting: Bool {
    return currentlyExecuting
  }

  override var isFinished: Bool {
    return currentlyFinished
  }

  var currentlyExecuting: Bool = false
  var currentlyFinished: Bool = false

  let request: Request
  let persistedData: ControllerData
  let client: TCPInternetSocket

  init(request: Request, persistedData: ControllerData, client: TCPInternetSocket) {
    self.request = request
    self.persistedData = persistedData
    self.client = client
  }

  override func start() {
    do {
      currentlyExecuting = true

      let controller = ControllerFactory.getController(request, with: persistedData)

      let response = controller.process(request)

      try client.send(data: response.formatted)

      // let fileContents = "REQUEST: \(try data.toString())\r\n" +
      //                    "RESPONSE: \(String(response: response))"

      // try FileWriter(at: logsPath, with: fileContents)
      //               .write(to: formatTimestamp(prefix: "SUCCESS"))

      // print(fileContents)

      currentlyFinished = true
      currentlyExecuting = false

      try client.close()
    } catch {}
  }
}
