open Types;
open PieceOperations;
open PuzzleAssembly;
open MonsterDetection;

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

let countHashesInMap = (puzzle: array(string)) => {
    puzzle |> Array.fold_left((acc, line) => {
        Array.init(String.length(line), (i) => i) |> Array.fold_left((accT, index) => {
            line.[index] == '#' ? accT + 1 : accT;
        }, acc);
    }, 0);
};

let solver = (pieces: array(piece2)) => {
    /* Find how many times each edge is used, store it in hashmap */
    let usages = sortUsages(pieces);

    /* Find the first piece with two unused edges */
    let firstTile = pieces |> Array.to_list |> List.find((elem) => {
        let missingNorthSouth = [| elem.opposingEdges[0], elem.opposingEdges[2] |] |> Array.fold_left(checkMissingEdgeUseFolding(usages), false)
        let missingEastWest = [| elem.opposingEdges[1], elem.opposingEdges[3] |] |> Array.fold_left(checkMissingEdgeUseFolding(usages), false)

        missingNorthSouth && missingEastWest
    });
    
    /* Create an array of pieces without the first piece selected */
    let piecesLeft = pieces |> Array.fold_left((acc, elem) => {
        elem == firstTile ? acc : Array.append(acc, [|elem|]);
    }, [||])

    /* Rotate and flip first piece selected to fit top left corner */
    let alignedFirstCorner = Array.make(3, 0) |> Array.fold_left((acc, _) => {
        let missingNorth = acc.opposingEdges[0] |> checkMissingEdgeUseFolding(usages, false);
        let missingEast = acc.opposingEdges[3] |> checkMissingEdgeUseFolding(usages, false);
        missingNorth && missingEast ? acc : rotatePiece(acc);
    }, firstTile);

    /* Build puzzle starting from top left corner */
    let puzzle = assemblePuzzle(alignedFirstCorner, piecesLeft);

    /* Remove borders from each piece and connect puzzle */
    let assembledAndTrimmedPuzzle = assemblePuzzleMatrixNoBorders(puzzle);

    /* Find number of monsters, rotating and flipping map if necessary */
    let numberOfMonsters = checkForDragons(assembledAndTrimmedPuzzle);
    
    let countHash = countHashesInMap(assembledAndTrimmedPuzzle);
    let dragonSize = 15;

    countHash - (dragonSize * numberOfMonsters);
}