-module(ex2).
-export([exercise/0]).

% Advance along the X axis

advance([], _) -> 0;

advance([Head | _], 0) when Head == 46 ->
    0;

advance([Head | _], 0) when Head == 35 ->
    1;

advance([_| Rest], Steps) ->
    advance(Rest, Steps - 1).

% Descend along the Y axis

descend([_| Rest], {MovementX, MovementY}) ->
    descend(Rest, {MovementX, MovementY}, {MovementX, MovementY}, 0).

descend([Head |_], _, _, NumCollisions) when length(Head) == 0 ->
    NumCollisions;

descend([], _, _, NumCollisions) ->
    NumCollisions;

descend([Head | Rest], {MovementX, MovementY}, {TupleX, 0}, NumCollisions) ->
    NewNumCollisions = NumCollisions + advance(Head, TupleX rem length(Head)),
    descend(Rest, {MovementX, MovementY}, {TupleX + MovementX, MovementY}, NewNumCollisions);

descend([_| Rest], {MovementX, MovementY}, {TupleX, TupleY}, NumCollisions) ->
    descend(Rest, {MovementX, MovementY}, {TupleX, TupleY - 1}, NumCollisions).


exercise() ->
    {ok, Bin} = file:read_file("data.txt"),
   CharList = unicode:characters_to_list(Bin),
   LinesArray = string:split(CharList, "\n", all),
   First = descend(LinesArray, {1, 0}),
   Second = descend(LinesArray, {3, 0}),
   Third = descend(LinesArray, {5, 0}),
   Fourth = descend(LinesArray, {7, 0}),
   Fifth = descend(LinesArray, {1, 1}),
   io:format("Number of 1x1: ~w~n", [First]),
   io:format("Number of 5x1: ~w~n", [Second]),
   io:format("Number of 7x1: ~w~n", [Third]),
   io:format("Number of 1x2: ~w~n", [Fourth]),
   io:format("Number of 1x2: ~w~n", [Fifth]),
   io:format("Result: ~w~n", [First * Second * Third * Fourth * Fifth]).