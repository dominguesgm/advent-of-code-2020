class Main {
    public static void main(String[] args) {

        def map = [
            byr: false,
            iyr: false,
            eyr: false,
            hgt: false,
            hcl: false,
            ecl: false,
            pid: false,
            cid: false
        ]

        def countValid = 0
        
        // Initiate file reading
        new File('./data.txt').eachLine { line ->
            if (line == '') {
                if(map.byr == true && map.iyr == true && map.eyr == true &&
                    map.hgt == true && map.hcl == true && map.ecl == true && map.pid == true) {
                    countValid++
                }

                map = [
                    byr: false,
                    iyr: false,
                    eyr: false,
                    hgt: false,
                    hcl: false,
                    ecl: false,
                    pid: false,
                    cid: false
                ]
                return false
            }

            String[] lineFields = line.split(' ')

            lineFields.each {
                String key = it.split(':')[0]

                map[key] = true
            }
        }

        println countValid
    }
}