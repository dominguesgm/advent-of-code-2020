class Main {
    public static void main(String[] args) {

        def max = 0
        
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

            if(seatId > max) {
                max = seatId
            }
        }

        println max
    }

    private static int calculateSeatId(int row, int line) {
        return row * 8 + line
    }
}