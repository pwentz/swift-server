import XCTest
import Foundation
@testable import Util

class MockCalendar: Calendarizable {
  func currentHour(from today: Date) -> Int { return 8 }

  func currentMinute(from today: Date) -> Int { return 45 }

  func currentSecond(from today: Date) -> Int { return 30 }
}

class MockFormatter: DateFormattable {
  var dateFormat: String! = "mm/dd/yyyy"

  func string(from today: Date) -> String {
    return "04/10/2017"
  }
}

class DateHelperTest: XCTestCase {
  func testItFormatsATimestamp() {
    let dateHelper = DateHelper(today: Date(), calendar: MockCalendar(), formatter: MockFormatter())

    let timestamp = dateHelper.formatTimestamp(prefix: "TEST", dateSeparator: "/")
    let expected = "TEST-8:45:30--04/10/2017"

    XCTAssertEqual(timestamp, expected)
  }
}
