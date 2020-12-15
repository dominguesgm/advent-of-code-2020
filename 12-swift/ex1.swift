import Foundation

let filename = "./data.txt"

let text = try String(contentsOfFile: filename, encoding: .utf8)

let instructionsArr = text.split(separator: "\n")

var orientation = 0 // East is 0, West is 180, north is 90 and south is 270
var distance = (x: 0, y: 0)

func moveForward(_ ammount: Int) {
    //Check if East
    if(orientation % 360 == 0 || orientation == 0) {
        move("E", ammount)
        return
    }
    //Check if South
    if(orientation % 270 == 0) {
        move("S", ammount)
        return
    }
    //Check if East
    if(orientation % 180 == 0) {
        move("W", ammount)
        return
    }
    //Check if East
    if(orientation % 90 == 0) {
        move("N", ammount)
        return
    }
}

func addOrientation(_ baseOrientation: Int, _ ammount: Int) -> Int {
    var newOrientation = baseOrientation + ammount

    while(newOrientation < 0 || newOrientation > 360) {
        if(newOrientation < 0){
            newOrientation = newOrientation + 360
        } else {
            newOrientation = newOrientation - 360
        }
    }

    return newOrientation
}

func move(_ type: Character, _ ammount: Int) {
    switch(type) {
        case "E":
            distance.x = distance.x + Int(ammount)
        case "W":
            distance.x = distance.x - Int(ammount)
        case "N":
            distance.y = distance.y + Int(ammount)
        case "S":
            distance.y = distance.y - Int(ammount)
        case "F":
            moveForward(ammount)
        case "L":
            orientation = addOrientation(orientation, ammount)
        case "R":   
            orientation = addOrientation(orientation, -ammount)
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