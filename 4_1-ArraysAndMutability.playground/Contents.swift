/*:
## 4.1&mdash;Arrays and Mutability

_Acknowledgement: This playground follows and simplifies to an intermediate level Section 4.1 of [Advanced Swift]( https://www.objc.io/books/advanced-swift/ ), by Chris Eidhof and Airspeed Velocity._

Arrays created with let declarations are immutable.

Arrays created with var declarations are mutable.

When assigned (or passed into a function) arrays always go with by-copy rather than by-reference semantics whether they are mutable or immutable!

The combination of the preceding two statements can be surprising for those coming from C, e.g.,

`int *ptr_to_ints = malloc(10 * sizeof(int)); // a pointer to ten ints`

`int *copy_of_ptr = ptr_to_ints; // a copy of the pointer`

In C, no matter how many copies of `ptr_to_ints` you make, they will all point to the same memory, so if you mutate the memory that any of them points to, you are mutating what they all point to.

Also, even if you aren't coming from C, but perhaps thinking of Objective-C's `NSArray` or Java's `ArrayList`, arrays going by-copy is a surprising language feature because it sounds like a major performance hit. However, Swift has copy-on-write optimization that takes the sting out of always passing arrays around with copy semantics.

Here's an example of the surprise:
*/

// Make a new array with a couple of values:
var originalArray = [1, 2]

let copyOfArray = originalArray // this has by-copy semantics

originalArray.append(3)

copyOfArray // Accck!!! Don't get the appended value in copyOfArray.

/*:
One pattern for dealing with the fact that mutable arrays are not passed by reference is to encapsulate them in a containing object that is passed by reference.

For example, if you are building a window manager, and various operations are going to add and remove windows from the window manager, then instead of passing around the list of windows, pass around the window manager, and let it hold the list of windows.
*/

struct Window {
    let id: Int
}

class WindowManager {
    var windows: [Window] = []
    
    func addWindow(window: Window) {
        windows.append(window)
    }
    
}

/*:
Here's how you'd use this encapsulation pattern to supply you with an up-to-date list of windows:
*/

// Make a new window manager with a couple of windows:
let originalWindowManager = WindowManager()
originalWindowManager.addWindow(Window(id: 1))
originalWindowManager.addWindow(Window(id: 2))

originalWindowManager.windows

let copyOfWindowManager = originalWindowManager // this has by-reference semantics

originalWindowManager.addWindow(Window(id: 3))

copyOfWindowManager.windows // Solved the problem. Get all 3 windows :)

/*:
I am not sure if this is the design pattern that the authors of Swift intend. Perhaps they intended you to use NSArray and NSMutableArray.

### NSMutableArray

In addition to the language-level arrays, when you import the Foundation framework, you get NSArray and NSMutableArray, and these have by-reference semantics, because they are objects.

In the example below copyOfMutableArray would appear to be immutable, doubly so in fact, because it was declared with both let and as an NSArray. However, it is mutable!
*/

import Foundation

let originalMutableArray: NSMutableArray = NSMutableArray(array: ["foo", "bar"])

let copyOfMutableArray = originalMutableArray as NSArray

copyOfMutableArray.lastObject // "bar"

originalMutableArray.addObject("baz")

copyOfMutableArray.lastObject // "baz" -- mutated -- Accck!!!
