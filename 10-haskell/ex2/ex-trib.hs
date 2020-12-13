import System.IO
import Data.List
import qualified Data.Map as M

fileReadLoop :: Handle -> IO [String]
fileReadLoop handle = do 
    ineof <- hIsEOF handle
    if ineof
        then return []
        else do
            inpStr <- hGetLine handle
            futureVal <- (fileReadLoop handle)
            return ((:) inpStr futureVal)

-- Generate intervals between values

generatorAux :: Integer -> (Integer, [Integer]) -> (Integer, [Integer])
generatorAux item (lastVal, acc) = do
    let diff = lastVal - item
    (item, diff : acc)

generateIntervals :: [Integer] -> [Integer]
generateIntervals list = do
    let (_, result) = foldr generatorAux (maximum list + 3, []) (0 : list)
    result

-- Determine number of combinations
            
groupOnes :: [Integer] -> []
groupOnes list acc= do
    let head : rest = list
    let 


main :: IO ()
main = do
    inputHandler <- openFile "../data.txt" ReadMode
    stringArray <- fileReadLoop inputHandler
    let sorted = sort (map (read :: String -> Integer) stringArray)
    let intervals = generateIntervals sorted
    let result = checkCombinations intervals M.empty 0
    putStrLn $ show result