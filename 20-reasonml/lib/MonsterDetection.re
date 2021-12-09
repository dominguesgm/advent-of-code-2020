open Types;
open PieceOperations;

let findDragons = (canvas: array(string)) => {
    Array.init((max_width * 8) - 3, (index) => index) |> Array.fold_left((acc, yIndex) => {
        Array.init((max_width * 8) - 20, (index) => index) |> Array.fold_left((accT, xIndex) => {
            if(
                canvas[yIndex + 0].[xIndex + 18] == '#' &&
                canvas[yIndex + 1].[xIndex + 0] == '#' &&
                canvas[yIndex + 1].[xIndex + 5] == '#' &&
                canvas[yIndex + 1].[xIndex + 6] == '#' &&
                canvas[yIndex + 1].[xIndex + 11] == '#' &&
                canvas[yIndex + 1].[xIndex + 12] == '#' &&
                canvas[yIndex + 1].[xIndex + 17] == '#' &&
                canvas[yIndex + 1].[xIndex + 18] == '#' &&
                canvas[yIndex + 1].[xIndex + 19] == '#' &&
                canvas[yIndex + 2].[xIndex + 1] == '#' &&
                canvas[yIndex + 2].[xIndex + 4] == '#' &&
                canvas[yIndex + 2].[xIndex + 7] == '#' &&
                canvas[yIndex + 2].[xIndex + 10] == '#' &&
                canvas[yIndex + 2].[xIndex + 13] == '#' &&
                canvas[yIndex + 2].[xIndex + 16] == '#'
            ) {
                accT + 1;
            } else {
                accT;
            }
        }, acc);
    }, 0);
}

let checkForDragons = (canvas: array(string)) => {
    let changedCanvas = canvas;

    let maxVal = Stdlib.max(0, findDragons(changedCanvas));
    let changedCanvas = rotateMatrix(canvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));
    let changedCanvas = rotateMatrix(changedCanvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));
    let changedCanvas = rotateMatrix(changedCanvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));

    let changedCanvas = rotateMatrix(changedCanvas);
    
    let changedCanvas = flipHorizontalMatrix(changedCanvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));
    let changedCanvas = rotateMatrix(changedCanvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));
    let changedCanvas = rotateMatrix(changedCanvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));
    let changedCanvas = rotateMatrix(changedCanvas);
    let maxVal = Stdlib.max(maxVal, findDragons(changedCanvas));

    maxVal;
}