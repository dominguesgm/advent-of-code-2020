open Types;
open PieceOperations;

let removeFoundPiece = (piece, list) => list |> Array.fold_left((acc, elem) => {
    elem == piece ? acc : Array.append(acc, [|elem|]);
}, [||])


let matchPieceToLeftEdge = (leftPiece, piecesLeft) => {
    let initialState = {piece: leftPiece, instructions: {found: false, rotate: 0, flip: false}, found: false};
    
    let foundPiece = piecesLeft |> Array.fold_left((acc, elem) => {
        if(acc.found) {
            acc;
        }else {
            let foundEdge = elem.opposingEdges |> Array.fold_left((accT, elemT) => {
                switch(elemT){
                | x when x == leftPiece.opposingEdges[1] => {found: true, rotate: accT.rotate, flip: false}
                | x when x == reverse(leftPiece.opposingEdges[1]) => {found: true, rotate: accT.rotate, flip: true}
                | _ when accT.found == false => {found: false, rotate: accT.rotate - 1, flip: false}
                | _ => {found: true, rotate: accT.rotate, flip: accT.flip}
                }
            }, {found: false, rotate: 3, flip: false});
    
            foundEdge.found ? {piece: elem, instructions: foundEdge, found: true} : acc;
        }
    }, initialState);

    let newPiecesLeft = removeFoundPiece(foundPiece.piece, piecesLeft);

    let updatedPiece = changePieceRight(foundPiece.piece, foundPiece.instructions);

    {piece: updatedPiece, piecesLeft: newPiecesLeft};
}

let matchPieceToTopEdge = (topPiece, piecesLeft) => {
    let foundPiece = piecesLeft |> Array.fold_left((acc, elem) => {
        if(acc.found) {
            acc;
        } else {
            let foundEdge = elem.opposingEdges |> Array.fold_left((accT, elemT) => {
                switch(elemT){
                | x when x == topPiece.opposingEdges[2] => {found: true, rotate: accT.rotate, flip: false}
                | x when x == reverse(topPiece.opposingEdges[2]) => {found: true, rotate: accT.rotate, flip: true}
                | _ when accT.found == false => {found: false, rotate: accT.rotate - 1, flip: false}
                | _ => {found: true, rotate: accT.rotate, flip: accT.flip}
                }
            }, {found: false, rotate: 4, flip: false});
    
            foundEdge.found ? {piece: elem, instructions: foundEdge, found: true} : acc;
        }


    }, {piece: topPiece, instructions: {found: false, rotate: 0, flip: false}, found: false});

    let newPiecesLeft = removeFoundPiece(foundPiece.piece, piecesLeft);

    let updatedPiece = changePieceBottom(foundPiece.piece, foundPiece.instructions);

    {piece: updatedPiece, piecesLeft: newPiecesLeft};
}

let assemblePuzzle = (firstCorner, piecesLeft) => {
    /* let width = 3; for tiny data*/ 
    let width = max_width;

    let heightLeft = width-1;

    let firstLineAcc = Array.make(width-1, 0) |> Array.fold_left((acc, _) => {
        let leftPiece = acc.firstLine[Array.length(acc.firstLine) - 1];

        let matchingResult = matchPieceToLeftEdge(leftPiece, acc.piecesLeft);

        {firstLine: Array.append(acc.firstLine, [| matchingResult.piece |]), piecesLeft: matchingResult.piecesLeft}
    }, {firstLine: [|firstCorner|], piecesLeft: piecesLeft});

    let puzzleMatrixAcc = Array.make(heightLeft, 0) |> Array.fold_left((acc, _) => {
        let topPiece = acc.puzzleMatrix[Array.length(acc.puzzleMatrix) - 1][0];

        let firstMatchingResult = matchPieceToTopEdge(topPiece, acc.piecesLeft);

        let lineAcc = Array.make(width-1, 0) |> Array.fold_left((accT, _) => {
            let leftPiece = accT.firstLine[Array.length(accT.firstLine) - 1];
    
            let matchingResult = matchPieceToLeftEdge(leftPiece, accT.piecesLeft);
            {firstLine: Array.append(accT.firstLine, [| matchingResult.piece |]), piecesLeft: matchingResult.piecesLeft}
        }, {firstLine: [|firstMatchingResult.piece|], piecesLeft: firstMatchingResult.piecesLeft});

        {puzzleMatrix: Array.append(acc.puzzleMatrix, [| lineAcc.firstLine |]), piecesLeft: lineAcc.piecesLeft};
    }, {puzzleMatrix: [| firstLineAcc.firstLine |], piecesLeft: firstLineAcc.piecesLeft})

    puzzleMatrixAcc.puzzleMatrix
}


let printBorderedCanvas = (pieces: array(array(piece2))) => {
    pieces |> Array.iter((row) => {
        Array.init(10, (index) => index ) |> Array.iter((index) => {
          let rowLine = row |> Array.fold_left((accString, piece) => {
            accString ++ " " ++ String.sub(piece.matrix[index], 0, 10);
          }, "");
          Console.log(rowLine);
        });
        Console.log("");
      });
}

let assemblePuzzleMatrixNoBorders = (pieces: array(array(piece2))) => {
    pieces |> Array.fold_left((matrixAcc, row) => {
        let rowArray = Array.init(8, (index) => index + 1) |> Array.fold_left((accRow, index) => {
          let rowLine = row |> Array.fold_left((accString, piece) => {
            accString ++ String.sub(piece.matrix[index], 1, 8);
          }, "");
          /* Console.log(rowLine); */
          Array.append(accRow, [| rowLine |]);
        }, [||]);
        Array.append(matrixAcc, rowArray);
      }, [||]);
}