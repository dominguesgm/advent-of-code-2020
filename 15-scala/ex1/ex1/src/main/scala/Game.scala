class Game(initialValues: Array[Int]) {
    var round = 1
    var countMap = collection.mutable.Map[Int, Int]()
    var lastRoundMap = collection.mutable.Map[Int, Int]()
    var numbersSpoken = collection.mutable.ArrayBuffer[Int]()

    def playRound(): Int = {
        val thisRound = round
        round = round + 1
        if(thisRound <= initialValues.length) {
            val currentValue = initialValues(thisRound - 1)

            numbersSpoken += currentValue
            lastRoundMap(currentValue) = thisRound
            countMap(currentValue) = countMap.getOrElse(currentValue, 0) + 1

            return currentValue
        }

        val lastVal = numbersSpoken(thisRound - 2)

        var newVal = 0 

        if(countMap(lastVal) > 1) {
            newVal = ((thisRound - 1) - lastRoundMap(lastVal))
        }

        lastRoundMap(lastVal) = thisRound - 1
        countMap(newVal) = countMap.getOrElse(newVal, 0) + 1

        numbersSpoken += newVal

        return newVal
    }
}