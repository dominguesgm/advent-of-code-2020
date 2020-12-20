import ballerina/io;
import ballerina/lang.'int;
import ballerina/log;
import ballerina/stringutils;

function process(io:ReadableCharacterChannel sc) returns @tainted string[] | error {
    string | io:Error character = sc.read(1);

    string[] result = [""];
    int currentIndex = 0;

    while(character is string) {
        if(character == "\n"){
            currentIndex += 1;
            result.push("");

            character = sc.read(1);
        } else {
            result[currentIndex] = result[currentIndex].concat(character);

            character = sc.read(1);
        }
    }

    return result;
}

function closeRc(io:ReadableCharacterChannel ch) {
    var cr = ch.close();
    if (cr is error) {
        log:printError("Error occurred while closing the channel: ", cr);
    }
}

public function main() returns @tainted error? {

    io:ReadableByteChannel readableFieldResult =
                                check io:openReadableFile("./data.txt");
    io:ReadableCharacterChannel sourceChannel =
                                new (readableFieldResult, "UTF-8");

    var splitLines = check process(sourceChannel);

    closeRc(sourceChannel);

    // Restructuring data
    // I could do this in a function and return a tuple with these (not sure if tuples have to be pairs or not in ballerina)
    // My original idea was using a map but apparently, ballerina map values are required to be of the same type

    [[int, int], [int, int]][] ranges = [];
    int[] ticket = [];
    int[][] nearbyTickets = [];

    int stage = 0;
    
    foreach var line in splitLines {
        if(line == "") {
            continue;
        }

        if(line == "your ticket:") {
            stage += 1;
            continue;
        }

        if(line == "nearby tickets:") {
            stage += 1;
            continue;
        }

        if(stage == 0) {
            string[] stringRanges = stringutils:split(stringutils:split(line, ": ")[1], " or ");

            string[] bounds_1 = stringutils:split(stringRanges[0], "-");
            [int, int] firstTuple = [check 'int:fromString(bounds_1[0]), check 'int:fromString(bounds_1[1])];

            string[] bounds_2 = stringutils:split(stringRanges[1], "-");
            [int, int] secondTuple = [check 'int:fromString(bounds_2[0]), check 'int:fromString(bounds_2[1])];

            [[int, int], [int, int]] newTuple = [firstTuple, secondTuple];

            ranges.push(newTuple);
        }

        if(stage == 1) {
            foreach var value in stringutils:split(line, ",") {
                ticket.push(check 'int:fromString(value));
            }
        }

        if(stage == 2) {
            int[] tempTicket = [];
            foreach var value in stringutils:split(line, ",") {
                tempTicket.push(check 'int:fromString(value));
            }

            nearbyTickets.push(tempTicket);
        }
    }

    // Actually solve the problem now
    int accumulator = 0;

    foreach var item in nearbyTickets {
        foreach var value in item {
            boolean matchesAny = false;
            foreach var set in ranges {
                if(matchesAny) {
                    break;
                }

                foreach var range in set {
                    if(matchesAny) {
                        break;
                    }

                    if(value >= range[0] && value <= range[1]) {
                        matchesAny = true;
                    }
                }
            }

            if(!matchesAny) {
                accumulator += value;
            }
        }
    }

    io:println("Result: ", accumulator);
}