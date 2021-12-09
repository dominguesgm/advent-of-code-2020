open Types

let readPieces = (): array(piece2) => {
    let file_in_channel = Stdlib.open_in("data.txt");

    let file_stream =
        Stream.from(_i => {
            switch(Stdlib.input_line(file_in_channel)) {
            | line => Some(line)
            | exception(End_of_file) => None
            };
        });

    let listOfLines = ref([||]);

    file_stream |> Stream.iter(line => {
        listOfLines := Array.append(listOfLines^, [|line|])
    });

    let result = listOfLines^ |> Array.fold_left((acc: fileAcc2, line: string) => {
        switch(line) {
        | "" =>
            {currentPiece: {id: 0, opposingEdges: [||], matrix: [||]}, listOfPieces: Array.append(acc.listOfPieces, [|acc.currentPiece|])}
        | x when String.length(x) == 10 && String.compare(String.sub(x, 0, 4), "Tile") == 0 =>
            {...acc, currentPiece: {id: Stdlib.int_of_string(String.sub(x, 5, 4)), opposingEdges: [||], matrix: [||]}}
        | a when String.length(a) == 10 && Array.length(acc.currentPiece.opposingEdges) == 0 =>
            {...acc, currentPiece: {...acc.currentPiece, opposingEdges: [| line, String.make(1, line.[9]), "", String.make(1, line.[0]) |], matrix: Array.append(acc.currentPiece.matrix, [|line|]) }}
        | b when String.length(b) == 10 && String.length(acc.currentPiece.opposingEdges[1]) == 9 =>
            {...acc, currentPiece:
                {...acc.currentPiece, opposingEdges: [|
                        acc.currentPiece.opposingEdges[0],
                        acc.currentPiece.opposingEdges[1] ++ String.make(1, line.[9]),
                        line,
                        acc.currentPiece.opposingEdges[3] ++ String.make(1, line.[0]) |],
                    matrix: Array.append(acc.currentPiece.matrix, [|line|])
                }}
        | c when String.length(c) == 10 =>
            {...acc, currentPiece:
                {...acc.currentPiece, opposingEdges: [|
                        acc.currentPiece.opposingEdges[0],
                        acc.currentPiece.opposingEdges[1] ++ String.make(1, line.[9]),
                        acc.currentPiece.opposingEdges[2],
                        acc.currentPiece.opposingEdges[3] ++ String.make(1, line.[0]) |],
                    matrix: Array.append(acc.currentPiece.matrix, [|line|])
                }}
        | _ => acc
        }
    }, {listOfPieces: [||], currentPiece: {id: 0, opposingEdges: [||], matrix: [||]}});

    result.listOfPieces;
};
