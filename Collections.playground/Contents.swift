/*:
# Collections

The first of several playgrounds illustrating Intermediate Swift. See the [GitHub Repository](https://github.com/brianhill/intermediate-swift) for the most complete and current set.

The Collections Playground follows _and_ _simplifies_ the "Collections" Chapter of [Advanced Swift](https://www.objc.io/books/advanced-swift/), by Chris Eidhof and Airspeed Velocity. Although this playground stands on its own, it could be used with that reference to understand the same subject matter at an advanced level.

## Arrays and Mutability

Arrays created with let declarations are immutable.

Arrays created with var declarations are mutable.

When assigned (or passed into a function) arrays always go with by-copy rather than by-reference semantics!

The combination of the preceding two statements can be surprising for those coming from C, e.g.,

    `int *pointerToArrayOfTenInts = malloc(10 * sizeof(int));`

No matter how many copies of pointerToArrayOfTenInts you make, they all point to the same memory that was allocated by malloc(). If you mutate what one of them points at, you are mutating what they all point at.

Also, arrays going by-copy is a surprising language feature because it sounds like a major performance hit. However, Swift has copy-on-write optimization that takes the sting out of passing arrays around with copy semantics.

Here's an example of the suprise:
*/

// Make a new array with a couple of values:
var originalArray = [1, 2]

let copyOfArray = originalArray // this has by-copy semantics

originalArray.append(3)

copyOfArray // Accck!!! Still only contains [1, 2]

/*:
One pattern for dealing with the fact that mutable arrays are not passed by reference is to encapsulate them in a containing object that is passed by reference.

For example, if you are building a window manager, and various operations are going to add and remove windows from the window manager, then instead of passing around the list of windows, pass around the window manager, and let it hold the list of windows.
*/

struct Window {
    let id: Int // need a sequential id generator
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

copyOfWindowManager.windows // Solved the Accck!!! problem. Got 3 windows :)

/*:
I am not sure if this is the design pattern that the authors of Swift intend.

### NSMutableArray

The preceding section was intermediate. This sub-section is definitely advanced.

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

Suppose I have 15 seven-segment display elements and I want to make 15 rectangles, each of whose position is to the right of the previous one:
*/

import CoreGraphics

let elementWidth = CGFloat(11)
let elementHeight = CGFloat(20)

func makeElementRect(elementNumber: Int) -> CGRect {
    let x = elementWidth * CGFloat(elementNumber)
    let y = CGFloat(0.0)
    let rect = CGRectMake(x, y, elementWidth, elementHeight)
    return rect
}

let columnIndices = 0..<15

let rowOfElementRects = columnIndices.map(makeElementRect)

/*:
### Mapping with In-Line Functions

The preceding section was intermediate. This sub-section is definitely advanced.

As a matter of fact, in the example above, you didn't even have to declare the function. You can do it in-line if you don't think you are going to re-use it. Here's an example that puts each rectangle below the previous one:
*/

let rowIndices = 0..<4

let columnOfElementRects = rowIndices.map { element in CGRectMake(CGFloat(0.0), elementHeight * CGFloat(element), elementWidth, elementHeight) } // notice how the declaration or definition of makeElementRect wasn't even used!

columnOfElementRects.count // 4
columnOfElementRects.last  // (0, 60, 11, 20) -- the last has of the four has a y position of 3 * 20 = 60

/*:
Of course the goal isn't too get as much code on one line as possible. The goal is to write code as clearly as possible. Over time, you will find that the brevity of using in-line functions results in clarity. However, initially, it might be easier not to use such compact constructions.
*/
