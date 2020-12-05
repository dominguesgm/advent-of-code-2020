class Main {
    public static void main(String[] args) {

        def seatMap = [:]

        (0..640).each {it -> 
            seatMap[it] = false
        }
        
        // Initiate file reading
        new File('./data.txt').eachLine { line ->
            String rowDescriptor = line[0..6]
                .replaceAll('B', '1')
                .replaceAll('F', '0')
            String lineDescriptor = line[7..-1]
                .replaceAll('R', '1')
                .replaceAll('L', '0')

            int rowNumber = Integer.parseInt(rowDescriptor, 2)
            int lineNumber = Integer.parseInt(lineDescriptor, 2)

            def seatId = calculateSeatId(rowNumber, lineNumber)

            seatMap[seatId] = true
        }

        seatMap.each { key, value -> 
            if(value) {
                return
            } 

            def hasNeighbourBefore = false
            def hasNeighbourAfter = false

            if(key > 0) {
                hasNeighbourBefore = seatMap[key - 1]
            }

            if(key < 640) {
                hasNeighbourAfter = seatMap[key + 1]
            }

            if(hasNeighbourBefore && hasNeighbourAfter) {
                println key
            }
        }
    }

    private static int calculateSeatId(int row, int line) {
        return row * 8 + line
    }
}