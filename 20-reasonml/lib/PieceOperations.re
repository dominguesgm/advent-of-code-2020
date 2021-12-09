open Types;

let reverse = str => {
    let len = String.length(str);
    String.init(len, i => str.[len - 1 - i]);
};

let rotateMatrix = (matrix: array(string)) => {
    let accStart = Array.make(Array.length(matrix), "");

    matrix |> Array.fold_left((acc, elem) => {
        elem |> String.iteri((index, character) => {
            acc[index] = String.make(1, character) ++ acc[index];
        })
        acc;
    }, accStart)
}

let rotateArray = (uncycled: array(string)) => {
    uncycled |> Array.mapi((index, elem) => {
        switch(index) {
        | 0 => reverse(uncycled[Array.length(uncycled) - 1])
        | x when x mod 2 == 0 => reverse(uncycled[x - 1])
        | x => uncycled[x - 1]
        }
    })
}

let rotatePiece = (currPiece: piece2) => {
    {...currPiece, opposingEdges: rotateArray(currPiece.opposingEdges), matrix: rotateMatrix(currPiece.matrix)}
}

let rec flipHorizontalMatrix = (matrix: array(string)) => {
    if(Array.length(matrix) == 1) {
        [|matrix[0]|];
    } else {
        Array.append(flipHorizontalMatrix(Array.sub(matrix, 1, Array.length(matrix) - 1)), [|matrix[0]|]);
    }
}

let flipHorizontalArray = (currArray: array(string)) => {
    [|
        currArray[2], 
        reverse(currArray[1]),
        currArray[0],
        reverse(currArray[3]),
    |]
}

let flipHorizontalPiece = (currPiece: piece2) => {
    {...currPiece, opposingEdges: flipHorizontalArray(currPiece.opposingEdges), matrix: flipHorizontalMatrix(currPiece.matrix)}
}


let rec flipVerticalMatrix = (matrix: array(string)) => {
    matrix |> Array.map((elem) => elem |> reverse);
}

let flipVerticalArray = (currArray: array(string)) => {
    [|
        reverse(currArray[0]), 
        currArray[3],
        reverse(currArray[2]),
        currArray[1],
    |]
}

let flipVerticalPiece = (currPiece: piece2) => {
    {...currPiece, opposingEdges: flipVerticalArray(currPiece.opposingEdges), matrix: flipVerticalMatrix(currPiece.matrix)}
}

let changePieceRight = (piece: piece2, instructions: pieceMatchingInstructions) => {
    let needToFlip = instructions.flip != (instructions.rotate >= 2)

    let rotatedPiece = Array.make(instructions.rotate, 0) |> Array.fold_left((acc, elem) => {
        acc |> rotatePiece;
    }, piece);
    
    needToFlip ? flipHorizontalPiece(rotatedPiece) : rotatedPiece;
}

let changePieceBottom = (piece: piece2, instructions: pieceMatchingInstructions) => {
    let needToFlip = instructions.flip != (instructions.rotate <= 2)

    let rotatedPiece = Array.make(instructions.rotate, 0) |> Array.fold_left((acc, elem) => {
        acc |> rotatePiece;
    }, piece);

    needToFlip ? flipVerticalPiece(rotatedPiece) : rotatedPiece;
}