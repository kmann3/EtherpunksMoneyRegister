import UIKit

let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
formatter.timeZone = TimeZone(abbreviation: "UTC")
let _createdOnUTC = formatter.string(from: Date())

let formatter2 = DateFormatter()
formatter2.dateFormat = "HH:mm:ss.SSS"
formatter2.timeZone = TimeZone(abbreviation: "CDT")
let _createdOnLocal = formatter.string(from: Date())
let myDate = Date()
