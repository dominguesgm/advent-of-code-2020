open Types;
open PieceOperations;


let sortUsages = (pieces: array(piece2)) => {
    pieces |> Array.fold_left((acc, elem) => {
        elem.opposingEdges |> Array.fold_left((accT, elemT) => {
            switch(elemT) {
            | x when EdgeMap.mem(x, acc) => {
                EdgeMap.add(x, EdgeMap.find(x, accT) + 1, accT)
            }
            | y when EdgeMap.mem(y |> reverse, acc) => {
                EdgeMap.add(y |> reverse, EdgeMap.find(y |> reverse, accT) + 1, accT)
            }
            | z => EdgeMap.add(z, 1, accT)
            }
        }, acc);
    }, EdgeMap.empty);
}

let checkMissingEdgeUseFolding = (usages, acc, elem) => {
    switch(elem) {
    | x when EdgeMap.mem(x, usages) && EdgeMap.find(x, usages) == 1 => {
        true
    }
    | y when EdgeMap.mem(y |> reverse, usages) && EdgeMap.find(y |> reverse, usages) == 1 => {
        true
    }
    | z => acc
    }
}

let checkMissingEdgeUse = (usages, element) => {
    (EdgeMap.mem(element, usages) && EdgeMap.find(element, usages) == 1) ||
        (EdgeMap.mem(element |> reverse, usages) && EdgeMap.find(element |> reverse, usages) == 1)
}



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

    Console.log(Array.length(piecesLeft))
    let newPiecesLeft = removeFoundPiece(foundPiece.piece, piecesLeft);
    Console.log(Array.length(newPiecesLeft));

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

    Console.log(Array.length(piecesLeft))
    let newPiecesLeft = removeFoundPiece(foundPiece.piece, piecesLeft);
    Console.log(Array.length(newPiecesLeft));

    let updatedPiece = changePieceBottom(foundPiece.piece, foundPiece.instructions);

    {piece: updatedPiece, piecesLeft: newPiecesLeft};
}

let assemblePuzzle = (firstCorner, piecesLeft) => {
    let width = 3;

    let heightLeft = width-1;

    let firstLineAcc = Array.make(width-1, 0) |> Array.fold_left((acc, _) => {
        let leftPiece = acc.firstLine[Array.length(acc.firstLine) - 1];

        let matchingResult = matchPieceToLeftEdge(leftPiece, acc.piecesLeft);

        Console.log(matchingResult.piece);

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

let assemblePuzzleMatrixNoBorders = (pieces: array(array(piece2))) => {
    pieces |> Array.fold_left((matrixAcc, row) => {
        let rowArray = Array.init(10, (index) => index) |> Array.fold_left((accRow, index) => {
          let rowLine = row |> Array.fold_left((accString, piece) => {
            accString ++ String.sub(piece.matrix[index], 1, 8);
          }, "");
          Console.log(rowLine);
          Array.append(accRow, [| rowLine |]);
        }, [||]);
        Array.append(matrixAcc, rowArray);
      }, [||]);
}

let solver = (pieces: array(piece2)) => {
    let usages = sortUsages(pieces);

    let firstTile = pieces |> Array.to_list |> List.find((elem) => {
        let missingNorthSouth = [| elem.opposingEdges[0], elem.opposingEdges[2] |] |> Array.fold_left(checkMissingEdgeUseFolding(usages), false)
        let missingEastWest = [| elem.opposingEdges[1], elem.opposingEdges[3] |] |> Array.fold_left(checkMissingEdgeUseFolding(usages), false)

        missingNorthSouth && missingEastWest
    });
    
    let piecesWithoutFirst = pieces |> Array.fold_left((acc, elem) => {
        elem == firstTile ? acc : Array.append(acc, [|elem|]);
    }, [||])

    let firstCorner = Array.make(3, 0) |> Array.fold_left((acc, _) => {
        let missingNorth = acc.opposingEdges[0] |> checkMissingEdgeUse(usages);
        let missingEast = acc.opposingEdges[3] |> checkMissingEdgeUse(usages);
        missingNorth && missingEast ? acc : rotatePiece(acc);
    }, firstTile);

    let puzzle = assemblePuzzle(firstCorner, piecesWithoutFirst);

    Console.log(assemblePuzzleMatrixNoBorders(puzzle));

    puzzle;
}