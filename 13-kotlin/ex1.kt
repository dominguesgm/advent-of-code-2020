import java.io.File
import kotlin.math.ceil

fun main () {
    var fileName = "./data.txt"
    var lines = File(fileName).useLines { it.toList() }

    var time = lines[0].toInt()

    var buses = lines[1].split(",").filter { it != "x"}.associateBy({it.toInt()}, {
        ceil(time.toDouble() / it.toInt()).toInt() * it.toInt()
    })

    var pair = buses.minByOrNull {
        (_, value) -> value
    }

    var timeToWait = pair!!.value - time

    var result = pair.key * timeToWait

    println("Result: $result")
}