$memory = {}
$currentMask = ""

def setMask(maskString)
    $currentMask = maskString
end

def assignValue(locationString, valueString)
    location = locationString.to_i
    value = valueString.to_i
    mask1s = $currentMask.gsub("X", "0").to_i(2)
    mask0s = $currentMask.gsub("X", "1").to_i(2) | ( ~0 << $currentMask.length)

    assignedValue = (value & mask0s) | mask1s

    $memory[location] = assignedValue
end

File.readlines('./data.txt').each do | line |
    instructionParts = line.split(" = ")

    if instructionParts[0] == "mask" then
        setMask(instructionParts[1])
    else
        instructionParts[0]["mem["] = ""
        instructionParts[0]["]"] = ""
        assignValue(instructionParts[0], instructionParts[1])
    end
end

result = $memory.values.reduce(:+)

puts "Result: " + result.to_s