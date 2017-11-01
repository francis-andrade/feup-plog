:-use_module(library(lists)).

%TODO arranjar isto
sublist(L1,L):- append(L1,_,L).
sublist(L1,L):- append(_,L1,L).
sublist(L1,L):- append([_x|L1],_y,L).

get_line(N, Board, Line):-
    nth1(N, Board, Line).