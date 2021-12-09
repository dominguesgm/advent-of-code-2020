let max_width = 12;

type piece = {
    id: int,
    opposingEdges: array(array(string)),
};

type fileAcc = {
    currentPiece: piece,
    listOfPieces: array(piece)
}

type piece2 = {
    id: int,
    mutable matrix: array(string),
    opposingEdges: array(string),
};

type fileAcc2 = {
    currentPiece: piece2,
    listOfPieces: array(piece2)
}

type pieceMatchingInstructions = { 
    found: bool,
    rotate: int,
    flip: bool
}

type pieceMatchingAcc = {
    found: bool,
    instructions: pieceMatchingInstructions,
    piece: piece2
}

type pieceMatchingResult = {
    piece: piece2,
    piecesLeft: array(piece2)
}

type assemblyLineAcc = {
    piecesLeft: array(piece2),
    firstLine: array(piece2),
}

type assemblyMatrixAcc = {
    piecesLeft: array(piece2),
    puzzleMatrix: array(array(piece2)),
}

module EdgeMap = Map.Make ({
    type t = string;

    let compare = compare;
});