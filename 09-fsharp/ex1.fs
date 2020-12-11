open System


let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

[<EntryPoint>]
let main argv =
    printfn "Hello World from F#!"
    readLines "../data.txt"
        |> Seq.forall println
    0 // return an integer exit code