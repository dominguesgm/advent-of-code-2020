{:ok, file} = File.read("./data.txt")
linesList = String.split(file, "\n")

defmodule ExerciseFile do
    def readFileIntoMatrix(filename) do
        {:ok, file} = File.read(filename)
        linesList = String.split(file, "\n")
    end
        

    def printFile(lines) do
        IO.puts(lines)
        IO.puts(length(lines))
    end
end

defmodule Exercisesolver do
    def checkNeighbors(baseX, baseY, baseZ, map) do
        countNeighbors = 0
        Enum.each(-1..1, fn (z) ->

            if map[baseZ + z] do
                Enum.each(-1..1, fn (y) ->

                    if map[baseZ + z][baseY + y] != nil do
                        Enum.each(-1..1, fn(x) ->

                            if map[baseZ + z][baseY + y][baseX + x] == "#" do
                                countNeighbors = countNeighbors + 1
                            end
                        end)
                    end
                end)
            end
        end)
    end

    def updateSpace(currentSpace) do
        newSpaceSizeZ = length(currentSpace)
        newSpaceSizeY = length(currentSpace[0])
        newSpaceSizeX = length(currentSpace[0][0])

        Enum.reduce(0..newSpaceSizeZ, %{}, fn elemZ, accZ -> 
            Map.put(accZ, elemZ, Enum.reduce(-newSpa))
        end)
    end
end

ExerciseFile.printFile(linesList)