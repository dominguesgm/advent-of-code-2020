sourceA = open("./data.txt", "r") do file
    linesArr = readlines(file)
    return map(linesArr) do line
        collect(Char, line)
    end
end

sourceB = deepcopy(sourceA)

function sourceAndDestination(iteration, matrixA, matrixB)
    if iteration % 2 == 0
        return (source= matrixA, destination= matrixB)
    else
        return (source= matrixB, destination= matrixA)
    end
end

function lineOfSight(source, size, index, operation)
    x = index.x + operation.x
    y = index.y + operation.y

    if (x > size.width || x < 1 || y > size.height || y < 1) || source[y][x] == 'L'
        return false
    end

    if source[y][x] == '#'
        return true
    end

    return lineOfSight(source, size, (x= x , y= y), operation)
end

function checkNeighbours(source, index, size)
    count = 0
    # TL
    lineOfSight(source, size, index, (x=-1, y=-1)) && (count = count + 1)
    # T
    lineOfSight(source, size, index, (x=0, y=-1)) && (count = count + 1)
    # TR
    lineOfSight(source, size, index, (x=1, y=-1)) && (count = count + 1)
    # R
    lineOfSight(source, size, index, (x=1, y=0)) && (count = count + 1)
    # BR
    lineOfSight(source, size, index, (x=1, y=1)) && (count = count + 1)
    # B
    lineOfSight(source, size, index, (x=0, y=1)) && (count = count + 1)
    # BL
    lineOfSight(source, size, index, (x=-1, y=1)) && (count = count + 1)
    # L
    lineOfSight(source, size, index, (x=-1, y=0)) && (count = count + 1)

    return count
end

function seatOcupationIteration!(source, destination, size)
    changeCount = 0
    for y in 1:size.height
        for x in 1:size.width
            neighbourCount = checkNeighbours(source, (x=x, y=y), size)

            if neighbourCount == 0 && source[y][x] == 'L'
                destination[y][x] = '#'
                changeCount = changeCount + 1
            elseif neighbourCount >= 5 && source[y][x] == '#'
                destination[y][x] = 'L'
                changeCount = changeCount + 1
            else
                destination[y][x] = source[y][x]
            end
        end
    end

    return (changeCount, destination)
end

function countOcupation(matrix)
    return mapfoldl(+, matrix) do list
        return mapfoldl(+, list) do char
            return char == '#' ? 1 : 0
        end
    end
end

function seatOcupation(matrixA, matrixB)
    iterationNum = 0
    finalMatrix = matrixA

    size = (width=length(matrixA[1]), height=length(matrixA))

    while(true)
        currMtx = sourceAndDestination(iterationNum, matrixA, matrixB)
        (numChanges, finalMatrix) = seatOcupationIteration!(currMtx.source, currMtx.destination, size)

        if numChanges == 0
            break
        end

        iterationNum = iterationNum + 1
    end

    ocupation = countOcupation(finalMatrix)

    

    println("Ocupation: $ocupation")

end

seatOcupation(sourceA, sourceB)