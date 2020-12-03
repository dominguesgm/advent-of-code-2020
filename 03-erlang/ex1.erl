-module(ex1).
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

descend([_| Rest]) ->
    descend(Rest, {3, 0}, 0).

descend([Head |_], _, NumCollisions) when length(Head) == 0 ->
    NumCollisions;

descend([], _, NumCollisions) ->
    NumCollisions;

descend([Head | Rest], {TupleX, 0}, NumCollisions) ->
    NewNumCollisions = NumCollisions + advance(Head, TupleX rem length(Head)),
    descend(Rest, {TupleX + 3, 0}, NewNumCollisions);

descend([_| Rest], {TupleX, TupleY}, NumCollisions) ->
    descend(Rest, {TupleX, TupleY - 1}, NumCollisions).


exercise() ->
    {ok, Bin} = file:read_file("data.txt"),
   CharList = unicode:characters_to_list(Bin),
   LinesArray = string:split(CharList, "\n", all),
   io:format("Number of Collisions: ~w~n", [descend(LinesArray)]).