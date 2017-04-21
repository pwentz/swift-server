import XCTest
@testable import Util

class DateHelperTest: XCTestCase {
  func testItFormatsATimestamp() {
    let mockCalendar = MockCalendar(hour: 8, minute: 45, second: 30)
    let mockFormatter = MockFormatter(month: "04", day: "10", year: "2017")
    let dateHelper = DateHelper(today: Date(), calendar: mockCalendar, formatter: mockFormatter)

    let timestamp = dateHelper.formatTimestamp(prefix: "TEST", dateSeparator: "/")
    let expected = "TEST-8:45:30--04/10/2017"

    XCTAssertEqual(timestamp, expected)
  }
}
