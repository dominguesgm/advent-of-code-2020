defmodule ExerciseFile do
    def readFileIntoMatrix(filename) do
        {:ok, file} = File.read(filename)
        linesList = String.split(file, "\n")

        # Feed into 3d map
        {mapY, _} = Enum.reduce(linesList, {%{}, 0}, fn elemY, accY ->
            {mapY, indexY} = accY

            {mapX, _} = Enum.reduce(String.graphemes(elemY), {%{}, 0}, fn elemX, accX ->
                {mapX, indexX} = accX

                {Map.put(mapX, indexX, elemX), indexX + 1}
            end)

            {Map.put(mapY, indexY, mapX), indexY + 1}
        end)

        %{0 => %{0 => mapY}}
    end

    def printFile(lines) do
        IO.puts(lines)
        IO.puts(length(lines))
    end
end

defmodule ExerciseSolver do
    def checkNeighbors(baseX, baseY, baseZ, baseW, map) do
        Enum.reduce(-1..1, 0, fn w, accW ->
            case map[baseW + w] do
                nil -> accW
                _ -> Enum.reduce(-1..1, accW, fn z, accZ ->
                        case map[baseW + w][baseZ + z] do
                            nil -> accZ
                            _ -> Enum.reduce(-1..1, accZ, fn y, accY ->
                                    case map[baseW + w][baseZ + z][baseY + y] do
                                        nil -> accY
                                        _ -> Enum.reduce(-1..1, accY, fn x, accX ->
                                                case map[baseW + w][baseZ + z][baseY + y][baseX + x] do
                                                    "#" when w == 0 and z == 0 and y == 0 and x == 0 -> accX
                                                    "#" -> accX + 1
                                                    _ -> accX
                                                end
                                            end)
                                    end
                                end)
                        end
                end)
            end
        end)
    end

    def updateSpace(currentSpace) do
        newSpaceRangeW = (Enum.min(Map.keys(currentSpace))-1)..(Enum.max(Map.keys(currentSpace))+1)
        newSpaceRangeZ = (Enum.min(Map.keys(currentSpace[0]))-1)..(Enum.max(Map.keys(currentSpace[0]))+1)
        newSpaceRangeY = (Enum.min(Map.keys(currentSpace[0][0]))-1)..(Enum.max(Map.keys(currentSpace[0][0]))+1)
        newSpaceRangeX = (Enum.min(Map.keys(currentSpace[0][0][0]))-1)..(Enum.max(Map.keys(currentSpace[0][0][0]))+1)

        Enum.reduce(newSpaceRangeW, %{}, fn elemW, accW -> 
            Map.put(accW, elemW, Enum.reduce(newSpaceRangeZ, %{}, fn elemZ, accZ -> 
                    Map.put(accZ, elemZ, Enum.reduce(newSpaceRangeY, %{}, fn elemY, accY ->
                        Map.put(accY, elemY, Enum.reduce(newSpaceRangeX, %{}, fn elemX, accX ->
                            neighborCount = checkNeighbors(elemX, elemY, elemZ, elemW, currentSpace)
                            elemValue = Map.get(Map.get(Map.get(Map.get(currentSpace, elemW, %{}), elemZ, %{}), elemY, %{}), elemX, ".")

                            case {elemValue, neighborCount} do
                                {"#", count} when count == 3 or count == 2 ->
                                    Map.put(accX, elemX, "#")
                                {"#", _} -> 
                                    Map.put(accX, elemX, ".")
                                {".", count} when count == 3 ->
                                    Map.put(accX, elemX, "#")
                                {".", _} ->
                                    Map.put(accX, elemX, ".")
                            end
                        end))
                    end))
                end))
            end)
    end

    def countActive(space) do
        Enum.reduce(space, 0, fn {_, elemW}, accW ->
            accW + Enum.reduce(elemW, 0, fn {_, elemZ}, accZ ->
                accZ + Enum.reduce(elemZ, 0, fn {_, elemY}, accY ->
                    accY + Enum.reduce(elemY, 0, fn {_, elemX}, accX ->
                        case elemX do
                            "#" -> accX + 1
                            "." -> accX
                        end
                    end)
                end)
            end)
        end)
    end

    def solveProblem(startingSpace) do
        Enum.reduce(1..6, startingSpace, fn _, acc -> 
            updateSpace(acc)
        end)
    end
end

solvedSpace = ExerciseFile.readFileIntoMatrix("./data.txt") |> ExerciseSolver.solveProblem
IO.puts ExerciseSolver.countActive(solvedSpace)