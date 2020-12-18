object Main {
  def main(args: Array[String]): Unit = {
    var game = new Game(Array(11,18,0,20,1,7,16))
    
    var latestValue = 0
    for(i <- 1 to 30000000) {
      latestValue = game.playRound()
    }

    println(s"Result: $latestValue")
  }
}