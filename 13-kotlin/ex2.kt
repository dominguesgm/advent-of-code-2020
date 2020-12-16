import java.io.File
import kotlin.math.ceil
import kotlin.math.abs

fun extendedEuclideanAlg (a: Long, b: Long): Pair<Long, Long> {
    var old_r = a
    var r = b
    var old_s = 1.toLong()
    var s = 0.toLong()
    var old_t = 0.toLong()
    var t = 1.toLong()

    while(r != 0.toLong()) {
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

    println("Bezouts coefficients: m1: $old_s, m2: $old_t")
    println("Greatest common divisor: $old_r")
    println("quotients by the gcd: $t, $s")

    return Pair(old_s, old_t)
}

fun normalizeVal(value: Long, multiple: Long): Long {
    var newVal = value

    while(newVal < 0.toLong() || newVal > multiple) {
        if(newVal < 0.toLong()) {
            newVal = newVal + multiple
        }

        if(newVal > multiple) {
            newVal = newVal - multiple
        }
    }

    return newVal
}

fun existanceProof(a1: Long, m1: Long, n1: Long, a2: Long, m2: Long, n2: Long): Long {
    return (a2 * m1 * n1) + (a1 * m2 * n2)
}

fun main () {
    var fileName = "./data.txt"
    var lines = File(fileName).useLines { it.toList() }

    var buses = lines[1].split(",").map { if(it == "x") { -1.toLong() } else { it.toLong() }}

    var accMultiple = buses[0]

    var lastRemainder = 0.toLong()

    for(i in 1..buses.size-1) {
        if(buses[i] == -1.toLong()) {
            continue
        }

        var bus = buses[i]

        println("For item $bus, of index $i")

        var bernoutIdent = extendedEuclideanAlg(accMultiple, buses[i])

        println("bernout ident: $bernoutIdent")

        var existance = existanceProof(lastRemainder, bernoutIdent.first, accMultiple, abs((buses[i] - i) % buses[i]), bernoutIdent.second, buses[i])

        println("existance: $existance")

        accMultiple = accMultiple * buses[i]

        println("acc Multiple: $accMultiple")

        lastRemainder = normalizeVal(existance, accMultiple)

        println("last remainder: $lastRemainder")
    }

    println("Result: $lastRemainder")
}