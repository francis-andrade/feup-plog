:-use_module(library(lists)).


sublist_start([],L):- ! .

sublist_start(L1, L):- L1=[X | L12], L=[X | L2], sublist_start(L12 , L2).

sublist(L1, L) :- sublist_start(L1, L).

sublist(L1,L) :- L=[X | L2], sublist(L1 , L2).


rate_count(Elem, [], N, N):- ! .

rate_count(Elem, List, N, Count):-
    List=[X | L2],
    ((X=Elem,C1 is Count + 1, rate_count(Elem, L2, N, C1));
    (X \= Elem, rate_count(Elem, L2, N, Count))). 

    
              
rate(Elem, List, N):-
    rate_count(Elem, List, N, 0).


max_list_aux([], Position, Value, Position, Value, Ind):- ! .

max_list_aux(List, Position, Value, Position_tmp, Value_tmp, Ind):-
    List=[X | L2],
    Ind1 is Ind + 1,(
    (X > Value_tmp,
    max_list_aux(L2, Position, Value, Ind, X, Ind1)); 
    (\+ ( X > Value_tmp),
    max_list_aux(L2, Position, Value, Position_tmp, Value_tmp, Ind1))).
    

max_list(List, Position, Value):-
    max_list_aux(List,Position, Value, -1, -10000, 1).

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

