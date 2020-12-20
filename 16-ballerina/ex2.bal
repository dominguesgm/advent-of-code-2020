import ballerina/io;
import ballerina/lang.'int;
import ballerina/lang.'array;
import ballerina/lang.'string;
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

function isValidTicketGenerator(map<[[int, int], [int, int]]> ranges) returns (function(int[]) returns boolean) {
    return function (int[] ticket) returns boolean {
        foreach var value in ticket {
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
                return false;
            }
        }

        return true;
    };
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

    map<[[int, int], [int, int]]> ranges = {};
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
            string[] nameAndRanges = stringutils:split(line, ": ");
            string name = nameAndRanges[0];
            string[] stringRanges = stringutils:split(nameAndRanges[1], " or ");

            string[] bounds_1 = stringutils:split(stringRanges[0], "-");
            [int, int] firstTuple = [check 'int:fromString(bounds_1[0]), check 'int:fromString(bounds_1[1])];

            string[] bounds_2 = stringutils:split(stringRanges[1], "-");
            [int, int] secondTuple = [check 'int:fromString(bounds_2[0]), check 'int:fromString(bounds_2[1])];

            [[int, int], [int, int]] newTuple = [firstTuple, secondTuple];

            ranges[name] = newTuple;
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

    int[][] validTickets = 'array:filter(nearbyTickets, isValidTicketGenerator(ranges));

    map<int> usedRanges = {};
    int[] unusedColumns = [];

    int counter = 0;
    foreach var ticketVal in ticket {
        unusedColumns.push(counter);
        counter += 1;
    }

    while(usedRanges.keys().length() != ranges.keys().length()) {
        foreach var rangeSetKey in ranges.keys() {
            int[] matchingColumns = [];
            foreach var column in unusedColumns {
                boolean valid = true;
                foreach var tempTicket in validTickets {
                    var currentValue = tempTicket[column];
                    [[int, int], [int, int]]? rangeSet = ranges[rangeSetKey];

                    if(rangeSet is [[int, int], [int, int]]) {
                        if(!(currentValue >= rangeSet[0][0] && currentValue <= rangeSet[0][1]) &&
                            !(currentValue >= rangeSet[1][0] && currentValue <= rangeSet[1][1])) {
                                valid = false;
                                break;
                        }
                    }
                }

                if(valid) {
                    matchingColumns.push(column);
                }
            }

            if(matchingColumns.length() == 1) {
                int? column = matchingColumns[0];
                if(column is int) {
                    int? indexOfColumn = 'array:indexOf(unusedColumns, column);
                    if(indexOfColumn is int) {
                        _ = 'array:remove(unusedColumns, indexOfColumn);
                        usedRanges[rangeSetKey] = column;
                    }
                }
            }
        }
    }

    int accumulator = 1;
    foreach var rangesKey in usedRanges.keys() {
        if('string:startsWith(rangesKey, "departure")) {
            int? index = usedRanges[rangesKey];
            if(index is int) {
                int? ticketValue = ticket[index];
                if(ticketValue is int) {
                    accumulator = accumulator * ticketValue;
                }
            }
        }
    }



    io:println("Result: ", accumulator);
}