// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System
open System.IO

let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let isNotSumAux ( list : int64 list ) ( initialVal : int64 ) ( target : int64 ) =
    list |>
        List.exists (fun x -> 
            x + initialVal = target)

let isNotSum (list:int64 list) (target:int64) = 
    list
        |> List.exists (fun x -> isNotSumAux list x target )
        |> not

let appendToList (limit:int) (list:int64 list) (item:int64) = 
    let newlist = item :: list
    newlist.[..limit-1]

let solveExercise (source : string) (limit:int) =
    readLines source
        |> Seq.fold (fun (initialList, brokenValue) strValue ->
            let intValue = strValue |> int64
            let newList = intValue |> appendToList limit initialList

            if List.length initialList = limit
                then match brokenValue with
                    | None -> (newList, if isNotSum initialList intValue then Some(intValue) else None)
                    | v1 -> (newList, v1)
                else (newList, None)
        ) ([], None)

[<EntryPoint>]
let main argv =
    let (_, value) = solveExercise "../data.txt" 25
    match value with
        | None -> printfn "No result found"
        | Some resolvedVal -> printfn $"Found value {resolvedVal}"
    0 // return aninteger exit code