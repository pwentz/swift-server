import XCTest
@testable import Util
import Errors

class CommandLineReaderTest: XCTestCase {
  func testItCanJoinArgs() {
    let args = ["/path/to/somewhere", "-p", "5000"]

    let reader = CommandLineReader(args: args)

    let expected = "/path/to/somewhere\r\n-p\r\n5000"

    XCTAssertEqual(reader.join("\r\n"), expected)
  }

  func testItCanGrabPortArgument() {
    let args = ["/path/to/somewhere", "-p", "5000", "-d", "some/other/path"]

    let reader = CommandLineReader(args: args)

    let port = try! reader.portArgs()

    let expected = UInt16("5000")!

    XCTAssertEqual(port!, expected)
  }

  func testItCanGrabDirectoryArgument() {
    let args = ["/path/to/somewhere", "-p", "5000", "-d", "some/other/path"]

    let reader = CommandLineReader(args: args)

    let publicDir = try! reader.publicDirectoryArgs()

    XCTAssertEqual(publicDir!, "some/other/path")
  }

  func testItCanThrowIfDirectoryArgumentIsInaccessible() {
    let args = ["/path/to/somewhere", "-p", "5000", "-d"]

    let reader = CommandLineReader(args: args)

    XCTAssertThrowsError(try reader.publicDirectoryArgs()) { error in
      XCTAssertEqual(error as! ServerStartError, ServerStartError.MissingArgumentFor(flag: "-d"))
    }
  }

  func testItCanThrowIfPortArgumentIsInaccessible() {
    let args = ["/path/to/somewhere", "5000", "-d", "-p"]

    let reader = CommandLineReader(args: args)

    XCTAssertThrowsError(try reader.portArgs()) { error in
      XCTAssertEqual(error as! ServerStartError, ServerStartError.MissingArgumentFor(flag: "-p"))
    }
  }
}
