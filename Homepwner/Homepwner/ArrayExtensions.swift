// A couple of useful additions to the built in Array
extension Array {
    /**
    * Gets the index of an object. Takes a closure and returns an optional int.
    */
    func indexOf(fn: T -> Bool) -> Int? {
        for (i, element) in enumerate(self) {
            if fn(element) {
                return i
            }
        }
        return nil
    }

    /**
    * Retusn an optional value at the specified index.
    */
    func objectAtIndex(index: Int) -> T? {
        for (i, element) in enumerate(self) {
            if i == index {
                return element
            }
        }
        return nil
    }
}
