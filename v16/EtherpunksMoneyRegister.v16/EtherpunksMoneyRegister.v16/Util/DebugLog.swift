import Foundation

/// Debug-only logging helper. Compiles away in release builds.
@inlinable public func DLog(_ message: @autoclosure () -> String) {
#if DEBUG
    print(message())
#endif
}
