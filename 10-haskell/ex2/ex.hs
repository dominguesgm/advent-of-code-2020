import System.IO
import Debug.Trace
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


-- Yes I found later I could have used tribonacci. However, I'd rather keep with the solution I came up with myself (even if less efficient)
    -- and optimize it rather than picking up something I looked up

    
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

checkCombinations :: [Int] -> M.Map [Int] Int -> Int -> ([Int], M.Map [Int] Int, Int)
checkCombinations list map acc = do
    trace ("List: " ++ (show list) ++ "\nFound in map?" ++ (show (M.member list map))) (
        if M.member list map
        then (list, map, acc + map M.! list)
        else case list of
            [_] -> (list, M.insert list 1 map, 1)
            [] -> (list, map, 1)
            3 : rest -> do
                let (_, resMap, resAcc) = checkCombinations rest map acc
                (rest, M.insert list resAcc resMap, resAcc + acc)
            head : rest -> do
                let restFirst : restRest = rest
                if head + restFirst > 3
                    then do
                        let (_, resMap, resAcc) = checkCombinations rest map acc
                        (rest, M.insert list resAcc resMap, resAcc + acc)
                    else do
                        let newRest = (head + restFirst) : restRest
                        let (_, resMap, resAcc) = checkCombinations newRest map acc
                        let (_, res2Map, res2Acc) = checkCombinations rest (M.insert newRest resAcc resMap) acc
                        (rest, M.insert rest res2Acc res2Map, res2Acc + resAcc + acc ))
            
    
reducer :: (Int, M.Map [Int] Int) -> [Int] -> (Int, M.Map [Int] Int)
reducer (acc, map) item = do
    let (_, newMap, itemAcc) = checkCombinations item map 0
    trace ("This acc: " ++ show itemAcc ++ "    for list: " ++ show item ) (acc * itemAcc, M.insert item itemAcc newMap)
    

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