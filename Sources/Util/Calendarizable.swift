import Foundation

public protocol Calendarizable {
  func currentHour(from today: Date) -> Int
  func currentMinute(from today: Date) -> Int
  func currentSecond(from today: Date) -> Int
}
