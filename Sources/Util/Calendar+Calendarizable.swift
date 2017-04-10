import Foundation

extension Calendar: Calendarizable {
  public func currentHour(from today: Date) -> Int {
    return self.component(.hour, from: today)
  }

  public func currentMinute(from today: Date) -> Int {
    return self.component(.minute, from: today)
  }

  public func currentSecond(from today: Date) -> Int {
    return self.component(.second, from: today)
  }
}
