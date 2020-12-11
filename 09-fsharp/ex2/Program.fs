// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System
open System.IO

let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let rec last (list : 'a list) =
    match list with
        | [x] -> x
        | _ :: tail -> last tail
        | _ -> failwith "Empty list"

let rec handleExcess (newValue : int64) (currAcc : int64, currList : int64 list, found : bool) (target : int64)=
    if newValue + currAcc = target
        then (newValue + currAcc, newValue :: currList, true)
        else if newValue + currAcc < target
            then (newValue + currAcc, newValue :: currList, false)
            else handleExcess newValue (currAcc - (last currList), currList.[..(List.length currList - 2)], false) target



let solveExercise (source : string) (target : int64)=
    readLines source
        |> Seq.fold (fun (currAcc, currList, found) strValue ->
            let intValue = strValue |> int64

            printfn $"target: {target}"
            printfn $"data {(currAcc, currList, found)}"
            if found
                then (currAcc, currList, found)
                else handleExcess intValue (currAcc, currList, found) target
    ) (0 |> int64, [], false)

[<EntryPoint>]
let main argv =
    let (currAcc, currList, found) = 373803594 |> int64 |> solveExercise "../data.txt"
    printfn $"was it found? {found}"
    printfn $"what was the value? {(List.max currList) + (List.min currList)}"
    0 // return aninteger exit code