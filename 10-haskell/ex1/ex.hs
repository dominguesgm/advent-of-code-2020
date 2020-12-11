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

determineDifferences :: M.Map Integer Integer -> Integer -> M.Map Integer Integer
determineDifferences acc val = do
    let diff = val - (acc M.! 0)
    M.insert 0 val (M.insertWith (+) diff 1 acc)

main :: IO ()
main = do
    inputHandler <- openFile "../data.txt" ReadMode
    stringArray <- fileReadLoop inputHandler
    let sorted = sort (map (read :: String -> Integer) stringArray)
    let result = foldl determineDifferences (M.fromList [(0, 0), (1, 0), (2, 0), (3, 1)]) sorted
    let final = (result M.! 1) * (result M.! 3)
    putStrLn $ show final