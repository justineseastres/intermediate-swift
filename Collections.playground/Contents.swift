/*:
# Collections

The first of several playgrounds illustrating Intermediate Swift. See the [GitHub Repository](https://github.com/brianhill/intermediate-swift) for the most complete and current set.

The Collections Playground follows _and_ _simplifies_ to an intermediate level the "Collections" Chapter of [Advanced Swift](https://www.objc.io/books/advanced-swift/), by Chris Eidhof and Airspeed Velocity. Although this playground stands on its own, it could be used with that reference in hand to take your understanding to an advanced level.

## Arrays and Mutability

Arrays created with let declarations are immutable.

Arrays created with var declarations are mutable.

When assigned (or passed into a function) arrays always go with by-copy rather than by-reference semantics!

The combination of the preceding two statements can be surprising for those coming from C, e.g.,

`int *ptr_to_ints = malloc(10 * sizeof(int)); // a pointer to ten ints`

`int *copy_of_ptr = ptr_to_ints; // a copy of the pointer`

No matter how many copies of `ptr_to_ints` you make, they will all point to the same memory, so if you mutate the memory that any of them points to, you are mutating what they all point to.

Also, even if you aren't coming from C, but perhaps thinking of Objective-C's `NSArray` or Java's `ArrayList`, arrays going by-copy is a surprising language feature because it sounds like a major performance hit. However, Swift has copy-on-write optimization that takes the sting out of passing arrays around with copy semantics.

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

In the example below copyOfMutableArray would appear to be immutable, doubly so, because it was declared with both let and as an NSArray. However, it is mutable!
*/

import Foundation

let originalMutableArray: NSMutableArray = NSMutableArray(array: ["foo", "bar"])

let copyOfMutableArray = originalMutableArray as NSArray

copyOfMutableArray.lastObject // "bar"

originalMutableArray.addObject("baz")

copyOfMutableArray.lastObject // "baz" -- mutated -- Accck!!!

/*:
## Map

Suppose I have 15 seven-segment display elements and I want to make 15 rectangles in a row, each of them to the right of the previous one:
*/

import CoreGraphics

let elementWidth = CGFloat(11)
let elementHeight = CGFloat(20)

let columnIndices = 0..<15

func makeElementRect(index: Int) -> CGRect {
    return CGRectMake(elementWidth * CGFloat(index), CGFloat(0.0), elementWidth, elementHeight)
}

/*:
Here's where we use the function makeElementRect as the argument to map():
*/

let rowOfElementRects = columnIndices.map(makeElementRect)

/*:
_Please don't confuse the functional-programming use of the term "map" with Java's use of it (e.g., in HashMap). In Java it is a class or an interface defining an object having keys and values. Here "map" is a method. What Java calls a HashMap is called a Dictionary in Swift, and we'll get to dictionaries shortly._

### Map with In-Line Functions

As a matter of fact, in the example above, you didn't even have to declare the function. You can do it in-line if you don't think you are going to re-use it. Here's an example that puts four rectangles in a column:
*/

let rowIndices = 0..<4

let columnOfElementRects = rowIndices.map { index in CGRectMake(CGFloat(0.0), elementHeight * CGFloat(index), elementWidth, elementHeight) }

columnOfElementRects.count // 4
columnOfElementRects.last  // (0, 60, 11, 20)

/*:
Of course the goal isn't to get as much code on one line as possible. The goal is to write code as clearly as possible. Over time, you will find that the brevity of using in-line functions sometimes helps with clarity because you don't have to refer elsewhere to see the implementation. However, initially, it might be easier not to use such compact constructions.

### Your Turn
*/

import XCTest

class PlaygroundTestSuite: XCTestCase {
    
    func test_InvokeThisPlease() {
        XCTFail("failed, yaay!")
    }
}

/*:
The following arcanum isn't revealed in [Apple's XCTest Library](https://github.com/apple/swift-corelibs-xctest). I gratefully acknowledge Stuart Sharpe for sharing it in his blog post, [TDD in Swift Playgrounds](http://initwithstyle.net/2015/11/tdd-in-swift-playgrounds/).
*/

class PlaygroundTestObserver : NSObject, XCTestObservation {
    @objc func testCase(testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: UInt) {
        print("Test failed on line \(lineNumber): \(testCase.name), \(description)")
    }
}

XCTestObservationCenter.sharedTestObservationCenter().addTestObserver(PlaygroundTestObserver())

PlaygroundTestSuite.defaultTestSuite().runTest()
