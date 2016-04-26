/*:
## 3.4&mdash;Collections and Protocols

_Acknowledgement: This playground follows and simplifies to an intermediate level Section 3.4 of [Advanced Swift]( https://www.objc.io/books/advanced-swift/ ), by Chris Eidhof and Airspeed Velocity._
 
### Overview
 
The third-to-last Chapter in [Apple's Swift book]( https://itunes.apple.com/us/book/swift-programming-language/id881256329?mt=11 ) is about Generics. Even deeper in the book, in the "Language Reference" the second-to-last chapter is about "Generic Parameters and Arguments."
 
Now really, you can't fully understand the collection classes unless you understand both of these things, and that's why Eidhof and Velocity take it on pretty early in their book.
 
A generic is a statement that involves types as variables. If it helps those who know C++, it is pretty much the same thing as a template.
 
If a type couldn't be a variable, then, for example, every type of array would have to have its own definition, and every type of set would have to have its own definition, and every type of dictionary (for each type of key and each type of value) would have to have its own definition.
 
Instead, the declaration for the Array struct has some angle brackets:

    public struct Array<Element> : Collection, MutableCollection, _DestructorSafeContainer {
    ...
    }
 
The type `Element` is a generic representing whatever type the array is declared to hold.
 
Similarly, the declaration for the Dictionary struct has some angle brackets:
 
   struct Dictionary<Key : Hashable, Value> {
   ...
   }

There are two types in this generic. It says a dictionary has a type `Key` and a type `Value`, and that furthermore, whatever you use for keys, they must be `Hashable`, which basically means they have to be able to compute a hashValue.
 
Note: In addition to structs and classes, enums also take generic types. However, [protocols do not take generics]( http://www.russbishop.net/swift-associated-types )! Protocols take typealiases though. The reason is that it moves the specific choice of the typealiases from the declarer of the protocol to the adopter of the protocol.

If you want to use the generic syntax, you could write:
*/


let x: Array<Int> = [1, 2, 3]

let y: Dictionary<String, String> = [ "foo": "bar" ]

let z: Set<String> = [ "foo", "bar" ]

/*:
However,the language supplies some syntax for arrays and dictionaries that we are encouraged to take advantage of:
*/

let x2: [Int] = [1, 2, 3]

let y2: [String: String] = [ "foo": "bar" ]

/*:
and we can even trim this to:
 */

let x3 = [1, 2, 3]

let y3 = ["foo", "bar"]

/*:
because the compiler can infer the types from the literals.

### What is the reference for the material in this playground?
 
There are five places you can learn about Swift in this level of detail. The first two are totally authoritative. The second, third and fourth are the most practical:
 
(1) Go straight to [the source for the Array class]( https://github.com/apple/swift/blob/master/stdlib/public/core/Arrays.swift.gyb ). Well, that isn't terribly practical for three reasons: (a) the file actually contains the source for three classes &mdash; Array, ArraySlice and ContiguousArray &mdash; and you would have to run a Python script on Arrays.swift.gyb before you even get the file you'd like to see, which is Array.swift. (b) Thanks to a Swift language feature called extensions, not all the definition for the Array class has to be in this file, for example, Array conforms to the _Reflectable protocol, and _Reflectable doesn't appear anywhere in Arrays.swift.gyb. (By the way, any protocol, method, variable, et cetera, that begins with an underscore is intended to _not_ be a part of the public API.) (c) Even if you didn't have to run a Python script on this file to turn it into an actual Swift file, and even if all of Array were defined in this file, reading the source can be pretty rough going.
 
(2) Go to [Swift's automatically-generated documentation]( http://swiftdoc.org ). This documentation is generated from the comments in the source files. Here's [the documentation for Array]( http://swiftdoc.org/v2.2/type/Array/ ). Here's [the documentation for Dictionary]( http://swiftdoc.org/v2.2/type/Dictionary/ ). Here's [the documentation for Set]( http://swiftdoc.org/v2.2/type/Set/ ).
 
(3) You can quickly get to similar (but not identical!) documentation by opening up the "Quick Help" in Xcode.
 
(4) Read [Eidhof and Velocity]( https://www.objc.io/books/advanced-swift/ ).
 
(5) Read [Apple's Swift book]( https://itunes.apple.com/us/book/swift-programming-language/id881256329?mt=11 ) (see the Chapters mentioned above). However, we are getting to the limits of what is in Apple's Swift book. For example, search the book for `CollectionType`, and you won't find much &mdash; and even what you do find is scattered around.

### Generators
 
If you looked at the doc for Array, Dictionary and Set, you might have noticed that they all conform to CollectionType. If you look at CollectionType, you'll see that it is the composition of the protocols Indexable and SequenceType.
 
If you look at SequenceType, you'll see that it requires four methods for conformance, and one of those is generate().
 
That method is required to return a GeneratorType.
 
A GeneratorType has exactly one method, next().
 
This method is very important. It is required to return an Element or nil.
 
If it helps those who know Java, it is pretty much the same thing as an Iterator, except in Java if you call an Iterator that doesn't have anything more to iterate over, it throws instead of returning nil. To avoid the throw in Java, you are first supposed to call hasNext().
 
If you need more motivation for learning generators, I'll just add that the `for i in x { ... }` is actually just calling x.generate() and then calling next() repeatedly on whatever that returns. So by learning generators, really you are learning how Swift's for loop works!

Without further ado, here is what you can glean from the [Swift doc for GeneratorType]( http://swiftdoc.org/v2.2/protocol/GeneratorType/ ):

```
protocol GeneratorType {
   associatedtype Element
   mutating func next() -> Element?
}
```
 
Eidhof and Velocity give us a truly simple example of a generator
*/

class ConstantGenerator: GeneratorType {
    typealias Element = Int
    func next() -> Element? {
        return 1
    }
}

let aConstantGenerator = ConstantGenerator()

for i in 0..<5 {
    print("\(aConstantGenerator.next()!)")
}

/*:
Amazingly, the type inference system even allows you to elide the typealias:
*/

class ConstantGenerator2: GeneratorType {
    func next() -> Int? {
        return 2
    }
}

/*:
Then Eidhof and Velocity give a more interesting generator. One that has some state and can generate the Fibonacci series:
*/

class FibonacciGenerator: GeneratorType {
    var state = (0, 1)
    func next() -> Int? {
        let returnValue = state.0
        state = (state.1, state.0 + state.1)
        return returnValue
    }
}

let aFibonacciGenerator = FibonacciGenerator()

for i in 0..<10 {
    print("\(aFibonacciGenerator.next()!)")
}

/*:
### Sequences
 
So that you can make multiple generators from a single underlying object, there is a protocol called SequenceType, which you can glean from the [Swift doc for SequenceType]( http://swiftdoc.org/v2.2/protocol/SequenceType/ )
 
```
protocol SequenceType {
   associatedtype Generator : GeneratorType
   associatedtype SubSequence
   func generate() -> Generator
   func dropFirst(n: Int) -> Self.SubSequence
   func dropLast(n: Int) -> Self.SubSequence
   func prefix(maxLength: Int) -> Self.SubSequence
}
 
```
So now you know how `for i in x { print("\(i)") }` works. You could implement it in terms of a while loop as:
*/

var g = x.generate()
while var i = g.next() {
    print("\(i)")
}

/*:
### Function-Based Generators and Sequences

Swift provides a very capable class called AnyGenerator whose init method just takes a function block. Here is how you could use it to generate the Fibonacci numbers:
*/

var state = (0, 1)
var anyGenerator: AnyGenerator<Int> = AnyGenerator { let returnValue = state.0; state = (state.1, state.0 + state.1); return returnValue }
for i in 0..<10 {
    print("\(anyGenerator.next()!)")
}

