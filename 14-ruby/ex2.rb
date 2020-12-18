$memory = {}
$currentMask = ""

def setMask(maskString)
    $currentMask = maskString
end

# A -> 0 and B -> 1 (to simplify generating masks)
def recurrValueAssignment(baseLocation, value, maskXsStr)
    if !maskXsStr.include? "X"
        mask1s = maskXsStr.gsub("A", "0").gsub("B", "1").to_i(2)
        mask0s = (~0) ^ maskXsStr.gsub("A", "1").gsub("B", "0").to_i(2)

        location = (baseLocation | mask1s) & mask0s

        $memory[location] = value

        return
    end

    recurrValueAssignment(baseLocation, value, maskXsStr.sub("X", "A"))
    recurrValueAssignment(baseLocation, value, maskXsStr.sub("X", "B"))
end

def assignValue(locationString, valueString)
    location = locationString.to_i
    value = valueString.to_i
    mask1s = $currentMask.gsub("X", "0").to_i(2)
    maskXsStr = $currentMask.gsub("1", "0")

    baseLocation = location | mask1s

    recurrValueAssignment(baseLocation, value, maskXsStr)
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