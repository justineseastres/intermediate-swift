/*:
## 4.3&mdash;Dictionaries and Sets

_Acknowledgement: This playground follows and simplifies to an intermediate level Section 4.3 of [Advanced Swift]( https://www.objc.io/books/advanced-swift/ ), by Chris Eidhof and Airspeed Velocity._

First off, it is good to contrast how you make arrays from literals, dictionaries from literals and sets from literals.


// Here is an array of the first 5 alphabetically out of a list of 100 important and frequently encountered words one encounters in Shakespeare -- source http://www.shakespeareswords.com/FEW


*/

let shakespeareWords = ["afeard", "anon", "apace", "apparel", "arrant"]

/*:
These will stay alphabetized because arrays don't scramble the order of their elements.

Here is a dictionary which includes a definition for each word.
*/

let shakespeareDictionary = [
    "afeard": "afraid, frightened, scared",
    "anon": "soon, shortly, presently",
    "apace": "quickly, speedily, at a great rate",
    "apparel": "clothes, clothing, dress",
    "arrant": "downright, absolute, unmitigated"
]

shakespeareDictionary["arrant"] // "downright, absolute, unmitigated"

let firstWordAndDefinition = shakespeareDictionary.first!

firstWordAndDefinition.0 // the word -- not "afeard"
firstWordAndDefinition.1 // the definition -- not "afraid, frightened, scared"

let shakespeareWordsAsSet: Set = ["afeard", "anon", "apace", "apparel", "arrant"]

/*:
### Mutation
*/

var physicistDictionary: [String: String]

physicistDictionary = [
    "trivial": "true and could not be otherwise",
    "obvious": "true but requires an argument to see",
]

physicistDictionary["interesting"] = "probably true, but it requires a crafty argument"

var physicistWordsAsSet: Set<String>

physicistWordsAsSet = ["trivial", "obvious"]

physicistWordsAsSet.insert("interesting")

if physicistWordsAsSet.contains("counter-intuitive") {
    print("Counter-intuitive is alaready in the set.")
} else {
    print("Counter-intuitive needs to be added.")
}
