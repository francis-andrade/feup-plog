:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-include('solve.pl').

fence:-
    get_arguments(NL, NC, P),
	assertCell(P),
	display_puzzle(NL, NC, P, 1).
	/*,
    display_puzzle(M),
    solve(L,C),
    display_puzzle(L)*/

display_point(1):- !,
	write('.').

display_point(L):-
	L > 1,
	write('. '), L1 is L - 1,
	display_point(L1).

display_restriction(NC, _P, _IndLine, IndCol) :- IndCol is NC + 1 ,! .


	display_restriction(NC, P, IndLine, IndCol):-
	member([IndLine, IndCol, Amount], P), !,
	write(' '),
	write(Amount),
	IndCol1 is IndCol + 1,
	display_restriction(NC, P, IndLine, IndCol1).

display_restriction(NC, P, IndLine, IndCol):-
	write('  '),
	IndCol1 is IndCol + 1,
	display_restriction(NC, P, IndLine, IndCol1).

display_puzzle(NL, _NC, _P, Ind):- Ind is NL + 1, ! .

display_puzzle(NL, NC, P, Ind):-
	display_point(NC),
	write('\n'),
	display_restriction(NC,  P, Ind, 1),
	write('\n'), Ind1 is Ind + 1,
	display_puzzle(NL, NC, P, Ind1).

display_lines_aux(NC, _L, _IndLine, NC):- ! .

display_lines_aux(_NC,L, IndLine, IndCol):-
	nth1(IndLine, L, LineIndL),
	nth1(IndCol, LineIndL, 0),!,
	write(' ').

display_lines_aux(_NC, L, IndLine, IndCol):-
	nth1(IndLine, L, LineIndL),
	nth1(IndCol, LineIndL, 1),!,
	write('_').

display_lines(NC, _L, _C, _IndLine, IndCol):- IndCol is NC + 1, ! .

display_lines(NC, L, C, IndLine, IndCol):-
	IndL1 is IndLine -1,
	nth1(IndL1, C, ColIndL),
	nth1(IndCol, ColIndL, 1), !,
	write('|'),display_lines_aux(NC, L, IndLine, IndCol),
	IndCol1 is IndCol + 1,
	display_lines(NC, L, C, IndLine, IndCol1).

display_lines(NC, L, C, IndLine, IndCol):-
	write(' '),display_lines_aux(NC, L, IndLine, IndCol),
	IndCol1 is IndCol + 1,
	display_lines(NC, L, C, IndLine, IndCol1).



display_puzzle(NL, NC, L, C, Ind):-
	display_lines(NC, L, C, Ind, 1), Ind1 is Ind +1,
	write('\n'),
	display_puzzle(NL, NC,L,C, Ind1).


assertCell([]):- !.

assertCell( [[Arg1, Arg2, Arg3]| P2]):-
	assert(cell(Arg1, Arg2, Arg3)),
	assertCell(P2).


get_arguments(NL, NC, P):-
	get_dimensions(NL, NC),
	get_puzzle(NL, NC, P).

get_puzzle(NL, NC, P):-
	NC1 is NC - 1, NL1 is NL - 1,
	write('Line Cell (Press 0 if you have finished adding restrictions to the grid)'),
	get_integer(LC, 0, NL1), (
	(LC = 0, P = []);
	(write('Column Cell (Press 0 if you have finished adding restrictions to the grid)'),
	get_integer(CC, 0, NC1), (
	(CC = 0, P = []);
	(write('Amount of line segments used by that cell (Press -1 if you have finished adding restrictions to the grid)'),
	get_integer(A, -1, 4), (
	(A = -1, P =[]) ;
	 ( P = [[LC, CC, A] | P2] , get_puzzle(NL, NC, P2))))))).

get_dimensions(NL, NC) :-
		write('Type the number of lines in the board: '),
		get_integer(NL, 1, 10000),
		write('Type the number of columns in the board'),
		get_integer(NC, 1, 10000).


get_integer(I,Min, Max):-
	read(N), isinteger(N, N2, Min, Max),
	(
	(integer(N) , N =< Max, N >= Min, N = I);
	(integer(N2), N2 =< Max, N2 >= Min, N2 = I)).

isinteger(I, _I2,Min, Max) :-
	integer(I), I =< Max , I >= Min .

isinteger(I, I2,Min, Max) :-
	integer(I), I < Min,
	write('Your input must be greater or equal to '), write(Min),
	write('. Please type again '),
	get_integer(I2, Min, Max).

isinteger(I, I2,Min, Max):-
	integer(I), I > Max,
	write('Your input must be smaller or equal to '), write(Max),
	write('. Please type again '),
	get_integer(I2,Min, Max).

isinteger(_I, I2 ,Min, Max) :-
	write('Your input must be a number. Please type again '),
	get_integer(I2,Min, Max).

test1:-
	P = [[1,1,0],[1,2,0],/*[1,3,0],[1,4,0],*/[1,5,0],[4,5,2]],
	display_point(7),write('\n'),
	display_restriction(7, P, 1, 1).

test2:-
	P = [[1,1,0],[1,2,0],[1,5,2],[4,5,2]],
	display_puzzle(7, 7, P, 1).

/*
Lines

[
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0]
]

Columns
  [
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0]
]
*/

test31:-
	L = [
    [1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 1, 1]
],
	C =
    [
    [1, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1]
],
	display_lines(7, L, C, 1, 1).

test3:-
	L = [
    [1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 1, 1]
],
	C =
    [
    [1, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1]
],
display_puzzle(7, 7, L, C, 1).