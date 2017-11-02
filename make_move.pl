%--------------------- Jogadas --------------------%
:-use_module(library(lists)).

possible_move(Line):-
    member(0, Line).

insert_head_line(Player,Line,NLine):-
    remove_first_zero(Line,_temp), append([Player],_temp,NLine).

insert_end_line(Player,Line,NLine):-
    remove_last_zero(Line,_temp), append(_temp,[Player],NLine).
	
remove_first_zero(Line, NLine) :-
	Line = [0 | Line2],
	NLine = Line2.

remove_first_zero(Line, NLine) :-
	Line = [X | Line2],
	X \= 0,
	NLine = [X | NLine2],
	remove_first_zero(Line2, NLine2).

remove_first_zero([],[]).

remove_last_zero(Line, NLine) :- 
	reverse(Line, Line2),
	remove_first_zero(Line2, NLine2),
	reverse(NLine2, NLine).
	