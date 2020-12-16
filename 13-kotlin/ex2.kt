import java.io.File
import kotlin.math.ceil

fun main () {
    var fileName = "./data.txt"
    var lines = File(fileName).useLines { it.toList() }

    var buses = lines[1].split(",").map { if(it == "x") { -1 } else { it.toInt() }}

    var baseVal = 0
    var notFound: Boolean

    do {
        notFound = false
        baseVal = baseVal + buses[0]

        for(i in 0..buses.size-1) {
            if(buses[i] == -1) {
                continue
            }

            if((baseVal + i) % buses[i] == 0) {
                continue
            } else {
                notFound = true
                break
            }
        }
    } while(notFound)

    println("Result: $baseVal")
}