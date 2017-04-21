import Foundation

public class MockCalendar: Calendarizable {
  let hour: Int
  let minute: Int
  let second: Int

  public init(hour: Int, minute: Int, second: Int) {
    self.hour = hour
    self.minute = minute
    self.second = second
  }

  public func currentHour(from today: Date) -> Int {
    return hour
  }

  public func currentMinute(from today: Date) -> Int {
    return minute
  }

  public func currentSecond(from today: Date) -> Int {
    return second
  }
}

