:-use_module(library(lists)).


sublist_start([],L).

sublist_start(L1, L):- L1=[X | L12], L=[X | L2], sublist_start(L12 , L2).

sublist(L1, L) :- sublist_start(L1, L).

sublist(L1,L) :- L=[X | L2], sublist(L1 , L2).

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

get_boolean(Prompt, Option):-
	write(Prompt), nl,
	read(Option), member(Option, ['yes', 'no']).

