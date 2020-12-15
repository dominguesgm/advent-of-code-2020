import Foundation

let filename = "./data.txt"

let text = try String(contentsOfFile: filename, encoding: .utf8)

let instructionsArr = text.split(separator: "\n")

var orientation = 0 // East is 0, West is 180, north is 90 and south is 270
var distance = (x: 0, y: 0)
var waypointPosition = (x: 10, y: 1)

func moveForward(_ ammount: Int) {
    distance.x = distance.x + (waypointPosition.x * ammount)
    distance.y = distance.y + (waypointPosition.y * ammount)
}

func normalizeOrientation(_ ammount: Int) -> Int {
    var newOrientation = ammount

    while(newOrientation < 0 || newOrientation > 360) {
        if(newOrientation < 0){
            newOrientation = newOrientation + 360
        } else {
            newOrientation = newOrientation - 360
        }
    }

    return newOrientation
}

func updateWaypoint(_ ammount: Int) {
    let tempX = waypointPosition.x
    let tempY = waypointPosition.y

    //Check if East
    if(ammount % 360 == 0 || ammount == 0) {
        return
    }
    //Check if South
    if(ammount % 270 == 0) {
        waypointPosition.x = tempY
        waypointPosition.y = -tempX
        return
    }
    //Check if East
    if(ammount % 180 == 0) {
        waypointPosition.x = -tempX
        waypointPosition.y = -tempY
        return
    }
    //Check if East
    if(ammount % 90 == 0) {
        waypointPosition.x = -tempY
        waypointPosition.y = tempX
        return
    }
}

func move(_ type: Character, _ ammount: Int) {
    switch(type) {
        case "E":
            waypointPosition.x = waypointPosition.x + Int(ammount)
        case "W":
            waypointPosition.x = waypointPosition.x - Int(ammount)
        case "N":
            waypointPosition.y = waypointPosition.y + Int(ammount)
        case "S":
            waypointPosition.y = waypointPosition.y - Int(ammount)
        case "F":
            moveForward(ammount)
        case "L":
            let updatedAmmount = normalizeOrientation(ammount)
            updateWaypoint(updatedAmmount)
        case "R":   
            let updatedAmmount = normalizeOrientation(-ammount)
            print(updatedAmmount)
            updateWaypoint(updatedAmmount)
        default:
            return
    }

    return
}


instructionsArr.forEach { instruction in
    // Well this fucking sucks. Int's cant be used to access string indexes??? you need a Substring.Index type
    let ammountIndex = instruction.index(instruction.startIndex, offsetBy: 1)
    let type = instruction[instruction.startIndex]
    let ammount = instruction[ammountIndex..<instruction.endIndex]

    if let intAmmount = Int(ammount) {
        move(type, intAmmount)
    }
}

let manhattanDistance = abs(distance.x) + abs(distance.y)

print("Distance: (x: \(distance.x), y: \(distance.y))")
print("Manhattan distance: \(manhattanDistance)")