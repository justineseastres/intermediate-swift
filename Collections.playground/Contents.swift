/*:
# Intermediate Swift -- Collections

## Arrays

Arrays created with let declarations are immutable. Arrays created with var declarations are mutable.

When assigned or passed into a function, arrays are always copied at the time of assignment.

The combination of the preceding two statements can be surprising.

*/

var originalArray = [1, 2]

let copyOfArray = originalArray

originalArray.append(3)

copyOfArray // Accck!!! Still only contains [1, 2]

/*:
One pattern I am using for dealing with the fact that mutable arrays are not passed by reference is to encapsulate them in a containing object that is passed by reference.

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

// Make a new window manager with a couple of windows
let originalWindowManager = WindowManager()
originalWindowManager.addWindow(Window(id: 1))
originalWindowManager.addWindow(Window(id: 2))

originalWindowManager.windows // gives you the two windows

let copyOfWindowManager = originalWindowManager

originalWindowManager.addWindow(Window(id: 3))

originalWindowManager.windows // Solved the Accck!!! problem. Got 3 windows :)

/*:
I am not sure if this is the design pattern that the authors of Swift intend.
*/
