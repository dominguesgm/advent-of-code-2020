import System.IO
import Debug.Trace
import Data.Hashable
import Data.List
import Data.List.Split
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

determineDifferences :: M.Map Int Int -> Int -> M.Map Int Int
determineDifferences acc val = do
    let diff = val - (acc M.! 0)
    M.insert 0 val (M.insertWith (+) diff 1 acc)

    
-- Generate intervals between values

generatorAux :: Int -> (Int, [Int]) -> (Int, [Int])
generatorAux item (lastVal, acc) = do
    let diff = lastVal - item
    (item, diff : acc)

generateIntervals :: [Int] -> [Int]
generateIntervals list = do
    let (_, result) = foldr generatorAux (maximum list + 3, []) (0 : list)
    result

-- Determine number of combinations

checkCombinations :: [Int] -> M.Map Int Int -> Int -> ([Int], M.Map Int Int, Int)
checkCombinations list map acc = do
    trace ("List: " ++ (show list) ++ "\nFound in map?" ++ (show (M.member (hash list) map))) (
        if M.member (hash list) map
        then (list, map, acc + map M.! (hash list))
        else case list of
            [_] -> (list, M.insert (hash list) 1 map, acc + 1)
            [] -> (list, map, acc)
            3 : rest -> checkCombinations rest map acc
            head : rest -> do
                let restFirst : restRest = rest
                if head + restFirst > 3
                    then
                        checkCombinations rest map acc
                    else do
                        let newRest = (head + restFirst) : restRest
                        let (_, newMap, newAcc) = checkCombinations newRest map acc
                        checkCombinations rest newMap newAcc)
            
    
reducer :: (Int, M.Map Int Int) -> [Int] -> (Int, M.Map Int Int)
reducer (acc, map) item = do
    let (_, newMap, itemAcc) = checkCombinations item map 0
    trace ("This acc: " ++ show itemAcc ++ "    for list: " ++ show item ) (acc * itemAcc, newMap)
    

main :: IO ()
main = do
    inputHandler <- openFile "../data.txt" ReadMode
    stringArray <- fileReadLoop inputHandler
    let sorted = sort (map (read :: String -> Int) stringArray)
    let intervals = generateIntervals sorted
    let intervalList = splitOn [3] intervals
    let filteredIntervalList = filter (\x -> length x > 1) intervalList
    let result = foldl reducer (1, M.empty) filteredIntervalList 
    --let result = checkCombinations intervals M.empty 0
    putStrLn $ show result