open Types;


let solver = () => {
  let input = Input2.readPieces();

  let result = Solver2.solver(input);

  Console.log("Result is " ++ Stdlib.string_of_int(result));
}