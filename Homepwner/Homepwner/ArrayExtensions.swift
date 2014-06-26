// A couple of useful additions to the built in Array
extension Array {
    /**
    * Gets the index of an object. Takes a closure and returns an optional int.
    */
    func indexOf(fn: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if fn(element) {
                return idx
            }
        }
        return nil
    }
}