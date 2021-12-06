type piece = {
    id: int,
    opposingEdges: array(array(string)),
};

type fileAcc = {
    currentPiece: piece,
    listOfPieces: array(piece)
}

module EdgeMap = Map.Make ({
    type t = string;

    let compare = compare;
});