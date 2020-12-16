import java.io.File
import kotlin.math.ceil
import kotlin.math.abs
import java.math.BigInteger

fun extendedEuclideanAlg (a: BigInteger, b: BigInteger): Pair<BigInteger, BigInteger> {
    var old_r = a
    var r = b
    var old_s = 1.toBigInteger()
    var s = 0.toBigInteger()
    var old_t = 0.toBigInteger()
    var t = 1.toBigInteger()

    while(r != 0.toBigInteger()) {
        var quotient = old_r / r

        var tempR = r
        r = old_r - (quotient * r)
        old_r = tempR

        var tempS = s
        s = old_s - (quotient * s)
        old_s = tempS

        var tempT = t
        t = old_t - (quotient * t)
        old_t = tempT
    }

    return Pair(old_s, old_t)
}

fun normalizeVal(value: BigInteger, multiple: BigInteger): BigInteger {
    var newVal = value

    var approxDivisor = value / multiple

    if(newVal >= 0.toBigInteger() && newVal <= multiple) {
        return newVal
    }

    newVal = value - approxDivisor * multiple

    while(newVal < 0.toBigInteger() || newVal > multiple) {
        if(newVal < 0.toBigInteger()) {
            approxDivisor = approxDivisor - 1.toBigInteger()
            newVal = value - approxDivisor * multiple
        }

        if(newVal > multiple) {
            approxDivisor = approxDivisor + 1.toBigInteger()
            newVal = value - approxDivisor * multiple
        }
    }

    return newVal
}

fun existenceProof(a1: BigInteger, m1: BigInteger, n1: BigInteger, a2: BigInteger, m2: BigInteger, n2: BigInteger): BigInteger {
    return (a2 * m1 * n1) + (a1 * m2 * n2)
}

fun main () {
    var fileName = "./data.txt"
    var lines = File(fileName).useLines { it.toList() }

    var buses = lines[1].split(",").map { if(it == "x") { -1.toBigInteger() } else { it.toBigInteger() }}

    var accMultiple = buses[0]

    var lastRemainder = 0.toBigInteger()

    for(i in 1..buses.size-1) {
        if(buses[i] == -1.toBigInteger()) {
            continue
        }

        var bernoutIdent = extendedEuclideanAlg(accMultiple, buses[i])

        var remainder = buses[i] - (i.toBigInteger() % buses[i])

        var existence = existenceProof(lastRemainder, bernoutIdent.first, accMultiple, remainder, bernoutIdent.second, buses[i])

        accMultiple = accMultiple * buses[i]

        lastRemainder = normalizeVal(existence, accMultiple)
    }

    println("Result: $lastRemainder")


    // This block validates the result to avoid checking in AoC and increasing timeout
    var correct = true

    for(i in 0..buses.size-1) {
        if(buses[i] == -1.toBigInteger()) {
            continue
        }

        if((lastRemainder + i.toBigInteger()) % buses[i] == 0.toBigInteger()) {
            continue
        } else {
            correct = false
            break
        }
    }


    println("Correct result: $correct")
}