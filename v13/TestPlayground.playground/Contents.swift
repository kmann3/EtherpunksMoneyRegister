import UIKit
import DateHelper
import SwiftDate

var greeting = "Hello, playground"

Date().toString(format: .isoYear)

let utcDateFormatter = DateFormatter()
utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let utcDate = utcDateFormatter.string(from: Date())
let utcString = utcDateFormatter.date(from: utcDate)


Date().convertTo(region: .UTC).toString()
Date().toString(format: .isoDateTimeFull)

let localDateFormatter = DateFormatter()
localDateFormatter.locale = .current
localDateFormatter.timeZone = .current
localDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let localDate = localDateFormatter.string(from: utcString!)


let utcDateString = "2024-08-16T12:34:56.789Z"

// Step 1: Create a DateFormatter for UTC
utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

// Step 2: Convert the UTC string to a Date object
if let utcDate = utcDateFormatter.date(from: utcDateString) {

    // Step 3: Create a DateFormatter for the local time zone
    let localDateFormatter = DateFormatter()
    localDateFormatter.timeZone = TimeZone.current
    localDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    // Step 4: Format the UTC Date object to a local time string
    let localDateString = localDateFormatter.string(from: utcDate)

    // Step 5: Convert the local time string back to a Date object in local time
    if let localDate = localDateFormatter.date(from: localDateString) {
        print("Local Date: \(localDate)")
    }
}
