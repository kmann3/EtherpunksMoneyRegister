import Foundation

/// Debug-only logging helper. Compiles away in release builds.
@inlinable public func DLog(_ message: @autoclosure () -> String) {
#if DEBUG
    print(message())
#endif
}

/// Debug-only logging helper with category/context.
/// TODO: Replace category with enum. Perhaps us nav?
//@inlinable public func DLog(_ category: String, _ message: @autoclosure () -> String) {
//#if DEBUG
//    print("[\(category)] \(message())")
//#endif
//}
