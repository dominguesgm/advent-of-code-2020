open Types;

let reverse = str => {
    let len = String.length(str);
    String.init(len, i => str.[len - 1 - i]);
};

let flattenArray = (arr: array(array('a))): array('a) =>
  Array.(concat(to_list(arr)));

let sortUsages = (pieces: array(piece2)) => {
    pieces |> Array.fold_left((acc, elem) => {
        elem.opposingEdges |> flattenArray |> Array.fold_left((accT, elemT) => {
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

let checkMissingEdgeUse = (usages, acc, elem) => {
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

let solver2 = (pieces: array(piece2)) => {
    let usages = sortUsages(pieces);

    pieces |> Array.fold_left((acc, elem) => {
        let missingNorthSouth = elem.opposingEdges[0] |> Array.fold_left(checkMissingEdgeUse(usages), false)
        let missingEastWest = elem.opposingEdges[1] |> Array.fold_left(checkMissingEdgeUse(usages), false)

        if(missingNorthSouth && missingEastWest) {
            acc * elem.id;
        } else {
            acc;
        }
    }, 1);
}