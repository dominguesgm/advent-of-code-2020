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
    opposingEdges: array(array(string)),
    canvas: array(string),
};

type fileAcc2 = {
    currentPiece: piece2,
    listOfPieces: array(piece2)
}

module EdgeMap = Map.Make ({
    type t = string;

    let compare = compare;
});