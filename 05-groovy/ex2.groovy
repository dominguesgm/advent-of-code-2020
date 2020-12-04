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

    private boolean validateByr(value) {
        try {
            def birthDate = value as int
            if(birthDate >= 1920 && birthDate <= 2002) {
                return true
            } else {
                return false
            }
        } catch (e) {
            return false
        }
    }

    private boolean validateIyr(value) {
        try {
            def issueYear = value as int
            if(issueYear >= 2010 && issueYear <= 2020) {
                return true
            } else {
                return false
            }
        } catch (e) {
            return false
        }
    }

    private boolean validateEyr(value) {
        try {
            def expirationYear = value as int
            if(expirationYear >= 2020 && expirationYear <= 2030) {
                return true
            } else {
                return false
            }
        } catch (e) {
            return false
        }
    }

    private boolean validateEyr(value) {
        try {
            def expirationYear = value as int
            if(expirationYear >= 2020 && expirationYear <= 2030) {
                return true
            } else {
                return false
            }
        } catch (e) {
            return false
        }
    }

    private boolean validateHgt(value) {
        println value[-1]
    }

    
}