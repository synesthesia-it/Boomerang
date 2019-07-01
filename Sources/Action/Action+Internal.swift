import Foundation
import RxSwift

// Note: Actions performed in this extension are _not_ locked
// So be careful!
internal extension NSObject {

    // Uses objc_sync on self to perform a locked operation.
    func doLocked(_ closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        closure()
    }
}
