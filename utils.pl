:-use_module(library(lists)).

sublist(L1,L):- append(_x,L1,L2), !, append(L2,_z,L).

get_line(N, Board, Line):-
    nth1(N, Board, Line).

replace_nth([_|Rest], 1, X, [X|Rest]).
replace_nth([X|Rest], N, Elem, [X|NRest]):-
    N > 1, N1 is N-1, replace_nth(Rest, N1, Elem, NRest).


%--------------------- Obter inputs --------------------%
get_integer(Prompt, Min, Max, Option):-
    write(Prompt), nl,
    read(Option), integer(Option),
    Option >= Min, Option =< Max.

get_integer(Prompt, Min, Max, Option):-
    write('Invalid input; Try again.'), nl, get_integer(Prompt, Min, Max, Option).

