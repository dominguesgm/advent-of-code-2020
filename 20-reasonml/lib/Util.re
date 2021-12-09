open Types;


let printPuzzle = (pieces: array(array(piece2))) => {
  pieces |> Array.fold_left((matrixAcc, row) => {
    let rowArray = Array.init(10, (index) => index) |> Array.fold_left((accRow, index) => {
      let rowLine = row |> Array.fold_left((accString, piece) => {
        accString ++ piece.matrix[index];
      }, "");
      Console.log(rowLine);
      Array.append(accRow, [| rowLine |]);
    }, [||]);
    Array.append(matrixAcc, rowArray);
  }, [||]);
}

let printPuzzleIds = (pieces: array(array(piece2))) => {
  pieces |> Array.iter((row) => {
    let string = row |> Array.fold_left((acc, piece) => {
      acc ++ " " ++ Stdlib.string_of_int(piece.id);
    }, "");
    Console.log(string)
  });
}

let solver = () => {
  let input = Input2.readPieces();

  let result = Solver2.solver(input);

  let _ = printPuzzle(result);
  printPuzzleIds(result);
}