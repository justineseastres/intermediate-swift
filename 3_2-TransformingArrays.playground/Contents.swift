/*:
## 3.2&mdash;Transforming Arrays

_Acknowledgement: This playground follows and simplifies to an intermediate level Section 3.2 of [Advanced Swift]( https://www.objc.io/books/advanced-swift/ ), by Chris Eidhof and Airspeed Velocity._

### Map

Suppose I have 15 seven-segment display elements and I want to make 15 rectangles in a row, each of them to the right of the previous one:
*/

import CoreGraphics

var elementWidth = CGFloat(11)
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
_Please don't confuse the functional-programming use of the term "map" with Java's use of it (e.g., in HashMap). In Java it is a class or an interface defining an object having keys and values. Here "map" is a method. What Java calls a HashMap is called a Dictionary in Swift, we'll get to dictionaries in the next playground._

As a matter of fact, in the example above, you didn't even have to give the function a name. You can do it anonymously (without naming it). Here's an example that puts four rectangles in a column:
*/

let rowIndices = 0..<4

let columnOfElementRects = rowIndices.map { index in CGRectMake(CGFloat(0.0), elementHeight * CGFloat(index), elementWidth, elementHeight) }

columnOfElementRects.count // 4
columnOfElementRects.last  // (0, 60, 11, 20)

/*:
The curly braces and everything between them is the anonymous function. The `index in` notation is a way of giving a name to the argument of the anonymous function. An equivalent way of accomplishing exactly the same thing is:
*/

let anEquivalentColumnOfElementRects = rowIndices.map { CGRectMake(CGFloat(0.0), elementHeight * CGFloat($0), elementWidth, elementHeight) }

/*:
The $0 is terse way of supplying the argument to the function.

Of course the goal isn't to get as much code on one line as possible. The goal is to write code clearly. Over time, you will find that the brevity of using map and anonymous functions sometimes helps with clarity. However, initially, it might be easier not to use such elegant constructions. Start by using them in simple situations where your first instinct was to write a for loop. Admire others' elegant constructions. Soon others will be admiring yours.

I've been calling the thing in curly braces an anonymous function. Eidhof and Velocity follow Apple and call it a closure, to emphasize that this function has access to whatever variables were in scope when it was defined.

Specifically, the function has access to `elementHeight` and `elementWidth`. This may seem trivial and obvious, because elementHeight and elementWidth have global scope, and they exist for the entire time our playground is executing, so "of course" `makeElementRect` has access to them when it is called.

However, when `columnIndices.map(makeElementRect)` is evaluated, the function `makeElementRect` is passed to array's implementation of `map`. In whatever file `map` is implemented in, it would be a wild coincidence if `elementWidth` and `elementHeight` were defined there, and if they were, there would be no relation whatsoever to our `elementWidth` and `elementHeight`, because that file has some other scope.

And yet, `makeElementRect` is executed repeatedly by map, and it is freely able to access `elementHeight` and `elementWidth`. By the way, you can create yourself a world of hurt if you also allow `elementHeight` or `elementWidth` to be mutable and then compound the crime by mutating them in `makeElementRect`. For now, I'd say, only use closures with immutable variables.

Here's an example of the power of closures. The following two functions differ by only 1 lousy character:
*/

func squared(base: Int) -> Int {
    var result = 1
    for _ in 0 ..< 2 {
        result *= base
    }
    return result
}

func cubed(base: Int) -> Int {
    var result = 1
    for _ in 0 ..< 3 {
        result *= base
    }
    return result
}

/*:
It would be very nice to define fourthPower, fifthPower, etc. if there is some way to avoid all the copy and pasting. Here's how you do it once and for all with closures:
*/

func anyPower(n: Int) -> (Int->Int) {
    func nthPower(base: Int) -> Int {
        var result = 1
        for _ in 0 ..< n {
            result *= base
        }
        return result
    }
    return nthPower
}

let fourthPower = anyPower(4)

fourthPower(10) // 10,000

let oneTwoThree = [1, 2, 3]

let someThing = oneTwoThree.map {varr in fourthPower(varr) }

someThing.last //81
/*:
### Filter

You can filter an array with a function that takes a closure. The closure in this case is an anonymous function.

Here is a filter that returns only the numbers in an array that are divisible by 3:

*/

let divisibleByThree = [2, 4, 6, 8, 10, 12, 14, 16, 18].filter{ value in value % 2 == 0 }

divisibleByThree // [6, 12, 18]

/*:
### Reduce

You can reduce an array down to a single value. Often times this is a running total. For example, you might have an array of car rentals, each rental has a price, and you want to sum the prices. You'd do that like this:
*/

struct CarRental {
    var price = 0.0
    var hours = 0.0
}

let thisMonthsRentals = [
    CarRental(price: 29.99, hours: 24.0),
    CarRental(price: 99.50, hours: 168.0),
    CarRental(price: 15.25, hours: 2.5)
]

let balanceForward = 77.50 // prior rentals
var total: Double = 0.0

func totalHours(rentals: [CarRental]) -> Double {
    total = thisMonthsRentals.reduce(balanceForward) {total, rentals in total + rentals.hours}
    return total
}


total = thisMonthsRentals.reduce(balanceForward) {total, rentals in total + rentals.hours}
total
// 222.24 = 77.50 + 29.99 + 99.50 + 15.25

