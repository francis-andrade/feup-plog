:-use_module(library(lists)).

sublist(L1,L):- append(_x,L1,L2), !, append(L2,_z,L).

get_line(N, Board, Line):-
    nth1(N, Board, Line).

%--------------------- Obter inputs --------------------%
get_integer(Prompt, Min, Max, Option):-
    write(Prompt), nl,
    read(Option), integer(Option),
    Option >= Min, Option =< Max.

get_integer(Prompt, Min, Max, Option):-
    write('Invalid input; Try again.'), nl, get_integer(Prompt, Min, Max, Option).

