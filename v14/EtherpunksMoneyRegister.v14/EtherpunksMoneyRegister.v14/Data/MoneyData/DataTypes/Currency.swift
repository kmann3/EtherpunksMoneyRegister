//
//  Currency.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 7/4/24.
//
import Foundation

/// Struct representing a currency value with an amount and a currency code.
/// Conforms to `Codable` for easy serialization.
struct Currency: Codable {
    /// The monetary amount.
    var amount: Decimal = 0

    /// The currency code, using the `CurrencyCode` enum.
    var code: CurrencyCode = .USD

    /// Initializes a `Currency` instance with a specified amount.
    /// You probably want to use this one.
    ///
    /// - Parameter amount: The amount of currency.
    init(_ amount: Decimal) {
        self.amount = amount
        self.code = CurrencyCode.inferFromLocale()
    }

    /// Initializes `Currency` with the amount and infers the currency code from the device's locale. This will infer the currency from the devices locale.
    ///
    /// - Parameter amount: The monetary amount.
    init(amount: Decimal) {
        self.amount = amount
        self.code = CurrencyCode.inferFromLocale()
    }

    /// Initializes a `Currency` instance with a specified integer amount.
    ///
    /// - Parameter amount: The amount of currency as an integer.
    init(_ amount: Int) {
        self.amount = Decimal(amount)
        self.code = CurrencyCode.inferFromLocale()
    }

    /// Initializes a `Currency` instance with a specified double amount.
    ///
    /// - Parameter amount: The amount of currency as a double.
    init(_ amount: Double) {
        self.amount = Decimal(amount)
        self.code = CurrencyCode.inferFromLocale()
    }

    /// Initializes a new `Currency` instance with the specified amount and currency code.
    ///
    /// - Parameters:
    ///   - amount: The monetary amount.
    ///   - code: The currency code.
    init(amount: Decimal, code: CurrencyCode) {
        self.amount = amount
        self.code = code
    }

    /// Converts a `Currency` instance to a `Decimal`.
    ///
    /// - Returns: The `Decimal` value equivalent to the amount of currency.
    func decimalValue() -> Decimal {
        return amount
    }

    /// Initializes a `Currency` instance from a `Decimal` value.
    ///
    /// - Parameter decimal: The `Decimal` value to convert to `Currency`.
    /// - Returns: A new `Currency` instance with the specified `Decimal` amount.
    static func fromDecimal(_ decimal: Decimal) -> Currency {
        return Currency(decimal)
    }

    /// Adds two `Currency` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The right-hand side `Currency` instance.
    /// - Returns: A new `Currency` instance with the sum of `lhs` and `rhs`.
    static func + (lhs: Currency, rhs: Currency) -> Currency {
        return Currency(lhs.amount + rhs.amount)
    }

    /// Adds two `Currency` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The right-hand side `Decimal` instance.
    /// - Returns: A new `Currency` instance with the sum of `lhs` and `rhs`.
    static func + (lhs: Currency, rhs: Decimal) -> Currency {
        return Currency(lhs.amount + rhs)
    }

    /// Adds two `Currency` instances.
    ///
    /// - Parameters:
    ///   - lhs: The right-hand side `Decimal` instance.
    ///   - rhs: The left-hand side `Currency` instance.
    /// - Returns: A new `Currency` instance with the sum of `lhs` and `rhs`.
    static func + (lhs: Decimal, rhs: Currency) -> Currency {
        return Currency(lhs + rhs.amount)
    }

    /// Subtracts one `Currency` instance from another.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The right-hand side `Currency` instance.
    /// - Returns: A new `Currency` instance with the difference of `lhs` minus `rhs`.
    static func - (lhs: Currency, rhs: Currency) -> Currency {
        return Currency(lhs.amount - rhs.amount)
    }

    /// Subtracts one `Currency` instance from another.
    ///
    /// - Parameters:
    ///   - lhs: The right-hand side `Currency` instance.
    ///   - rhs: The left-hand side `Decimal` instance.
    /// - Returns: A new `Currency` instance with the difference of `lhs` minus `rhs`.
    static func - (lhs: Currency, rhs: Decimal) -> Currency {
        return Currency(lhs.amount - rhs)
    }

    /// Subtracts one `Currency` instance from another.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Decimal` instance.
    ///   - rhs: The right-hand side `Currency` instance.
    /// - Returns: A new `Currency` instance with the difference of `lhs` minus `rhs`.
    static func - (lhs: Decimal, rhs: Currency) -> Currency {
        return Currency(lhs - rhs.amount)
    }

    /// Multiplies a `Currency` instance by a `Decimal` scalar.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The `Currency` scalar to multiply by.
    /// - Returns: A new `Currency` instance with the product of `lhs` multiplied by `rhs`.
    static func * (lhs: Currency, rhs: Currency) -> Currency {
        return Currency(lhs.amount * rhs.amount)
    }

    /// Multiplies a `Currency` instance by a `Decimal` scalar.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The `Decimal` scalar to multiply by.
    /// - Returns: A new `Currency` instance with the product of `lhs` multiplied by `rhs`.
    static func * (lhs: Currency, rhs: Decimal) -> Currency {
        return Currency(lhs.amount * rhs)
    }

    /// Multiplies a `Currency` instance by a `Decimal` scalar.
    ///
    /// - Parameters:
    ///   - lhs: The `Decimal` scalar to multiply by.
    ///   - rhs: The left-hand side `Currency` instance.
    /// - Returns: A new `Currency` instance with the product of `lhs` multiplied by `rhs`.
    static func * (lhs: Decimal, rhs: Currency) -> Currency {
        return Currency(lhs * rhs.amount)
    }

    /// Divides a `Currency` instance by a `Decimal` scalar.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The `Currency` scalar to divide by.
    /// - Returns: A new `Currency` instance with the quotient of `lhs` divided by `rhs`.
    /// - Note: Division by zero will result in a fatal error.
    static func / (lhs: Currency, rhs: Currency) -> Currency {
        guard rhs != 0 else {
            fatalError("Division by zero")
        }
        return Currency(lhs.amount / rhs.amount)
    }

    /// Divides a `Currency` instance by a `Decimal` scalar.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The `Decimal` scalar to divide by.
    /// - Returns: A new `Currency` instance with the quotient of `lhs` divided by `rhs`.
    /// - Note: Division by zero will result in a fatal error.
    static func / (lhs: Currency, rhs: Decimal) -> Currency {
        guard rhs != 0 else {
            fatalError("Division by zero")
        }
        return Currency(lhs.amount / rhs)
    }

    /// Divides a `Currency` instance by a `Decimal` scalar.
    ///
    /// - Parameters:
    ///   - lhs: The `Decimal` scalar to divide by.
    ///   - rhs: The left-hand side `Currency` instance.
    /// - Returns: A new `Currency` instance with the quotient of `lhs` divided by `rhs`.
    /// - Note: Division by zero will result in a fatal error.
    static func / (lhs: Decimal, rhs: Currency) -> Currency {
        guard rhs != 0 else {
            fatalError("Division by zero")
        }
        return Currency(lhs / rhs.amount)
    }

    /// Checks inequality between a `Currency` instance and a `Decimal`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Currency` instance.
    ///   - rhs: The `Decimal` value to compare against.
    /// - Returns: `true` if the amounts are not equal, `false` otherwise.
    static func != (lhs: Currency, rhs: Decimal) -> Bool {
        return lhs.amount != rhs
    }

    /// Checks inequality between a `Currency` instance and a `Decimal`.
    ///
    /// - Parameters:
    ///   - lhs: The `Decimal` value to compare against.
    ///   - rhs: The left-hand side `Currency` instance.
    /// - Returns: `true` if the amounts are not equal, `false` otherwise.
    static func != (lhs: Decimal, rhs: Currency) -> Bool {
        return lhs != rhs.amount
    }

    /// Returns the formatted string representation of the currency value.
    ///
    /// - Parameter locale: The locale to use for formatting. Defaults to the current locale.
    /// - Returns: A string representation of the currency value, or `nil` if formatting fails.
    func formattedString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = code.rawValue
        return formatter.string(from: amount as NSDecimalNumber)
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case amount
        case code
    }

    /// Decodes a `Currency` instance from a decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if decoding fails.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let amountString = try container.decode(String.self, forKey: .amount)
        if let decimalAmount = Decimal(string: amountString) {
            self.amount = decimalAmount
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .amount, in: container,
                debugDescription: "Amount is not a valid decimal number")
        }
        self.code = try container.decode(CurrencyCode.self, forKey: .code)
    }

    /// Encodes a `Currency` instance to an encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(amount)", forKey: .amount)
        try container.encode(code, forKey: .code)
    }

    /// Prints some examples for someone to use.
    func printExamples() {

        let decimalValue: Decimal = 100.0

        // Implicit conversion from Decimal to Currency using the global function
        let currencyValue = +decimalValue
        debugPrint("Currency Value: \(currencyValue.amount)")  // Output: Currency Value: 100.0

        // If you want to just let it infer
        let currency = Currency(100)
        debugPrint("Amount: \(currency.formattedString() ?? "N/A")")  // Prints the formatted amount based on the device's locale

        // OR you can manually set it
        let usdPrice = Currency(amount: Decimal(19.99), code: .USD)
        let eurPrice = Currency(amount: Decimal(5.99), code: .EUR)
        let nlPrice = Currency(amount: Decimal(3.47), code: .NL)
        let gbpPrice = Currency(amount: Decimal(9.99), code: .GBP)
        let jpyPrice = Currency(amount: Decimal(1000), code: .JPY)
        let cnyPrice = Currency(amount: Decimal(50), code: .CNY)

        if let formattedUsd = usdPrice.formattedString(),
            let formattedEur = eurPrice.formattedString(),
            let formattedNl = nlPrice.formattedString(),
            let formattedGbp = gbpPrice.formattedString(),
            let formattedJpy = jpyPrice.formattedString(),
            let formattedCny = cnyPrice.formattedString()
        {
            debugPrint("USD Price: \(formattedUsd)")  // USD Price: $19.99
            debugPrint("EUR Price: \(formattedEur)")  // EUR Price: 5,99 €
            debugPrint("Netherlands Price: \(formattedNl)")  // EUR Price: 3,47 €
            debugPrint("GBP Price: \(formattedGbp)")  // GBP Price: £9.99
            debugPrint("JPY Price: \(formattedJpy)")  // JPY Price: ¥1,000
            debugPrint("CNY Price: \(formattedCny)")  // CNY Price: ¥50.00
        }
    }
}

/// Enables implicit conversion from `Decimal` to `Currency`.
///
/// - Parameter decimal: The `Decimal` value to convert to `Currency`.
/// - Returns: A new `Currency` instance with the specified `Decimal` amount.
prefix func + (decimal: Decimal) -> Currency {
    return Currency(decimal)
}

// Example for use in a view:

// Viewmodel:
//    class CurrencyViewModel: ObservableObject {
//        @Published var currency: Currency
//
//        init(currency: Currency) {
//            self.currency = currency
//        }
//
//        func updateAmount(from string: String) {
//            if let decimalAmount = Decimal(string: string) {
//                currency.amount = decimalAmount
//            }
//        }
//    }

// View:
//    struct ContentView: View {
//        @StateObject private var viewModel = CurrencyViewModel(currency: Currency(amount: Decimal(100), code: .USD))
//
//        var body: some View {
//            VStack {
//                TextField("Amount", value: $viewModel.currency.amount, format: .currency(code: viewModel.currency.code.rawValue))
//#if os(iOS)
//                    .keyboardType(.decimalPad)
//                    .padding()
//#endif
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Picker("Currency", selection: $viewModel.currency.code) {
//                    ForEach(CurrencyCode.allCases) { code in
//                        Text(code.rawValue).tag(code)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                if let formattedString = viewModel.currency.formattedString() {
//                    Text("Formatted: \(formattedString)")
//                }
//            }
//            .padding()
//        }
//    }
//}
