open Types;

let solver = () => {
  let input = Input.readPieces();

  let result = Solver1.solver1(input);
  Console.log(result);
}