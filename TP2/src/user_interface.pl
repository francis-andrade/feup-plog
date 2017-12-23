%displays the main menu
display_main_menu:-
		display_options, nl .

%displays the menu options
display_options:-
    write('+------------------------------------+'), nl,
    write('  1. Input Puzzle Restrictions'), nl,
    write('  2. Generate Puzzle Restrictions'), nl,
    write('  0. Exit'), nl,
    write('+------------------------------------+').


%---------------------- DISPLAY_PUZZLE ----------------------%
%This version of display_puzzle displays the puzzle restrictions
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

%---------------------- DISPLAY_PUZZLE ----------------------%
%This version of display_puzzle displays the final solution
display_puzzle([LineElem1, LineElem2], [ColElem], Cells, IndL, IndC):-
	display_line(LineElem1),
	display_columns(ColElem, Cells, IndL, IndC),
	display_line(LineElem2).

display_puzzle([LineElem|LT], [ColElem|CT], Cells, IndL, IndC):-
	display_line(LineElem),
	display_columns(ColElem, Cells, IndL, IndC),
	NewIndL is IndL+1,
	display_puzzle(LT, CT, Cells, NewIndL, IndC).

display_line([Elem]):-
	write('+'),
	(Elem = 0, write('   '); Elem = 1, write('---')),
	write('+'), nl.

display_line([Elem|T]):-
	write('+'),
	(Elem = 0, write('   '); Elem = 1, write('---')),
	display_line(T).

display_columns([Elem], _Cells, _IndL, _IndC):-
	(Elem = 0, write(' '); Elem = 1, write('|')), nl.

display_columns([Elem|T], Cells, IndL, IndC):-
	member([IndL, IndC, Amount], Cells), !,
	(Elem = 0, write(' '); Elem = 1, write('|')),
	write(' '), write(Amount), write(' '),
	NewIndC is IndC + 1,
	display_columns(T, Cells, IndL, NewIndC).

display_columns([Elem|T], Cells, IndL, IndC):-
	(Elem = 0, write(' '); Elem = 1, write('|')),
	write('   '),
	NewIndC is IndC + 1,
	display_columns(T, Cells, IndL, NewIndC).

/*
create_empty(NL,NC,ZeroedL,ZeroedC):-
	AuxNC is NC-1, AuxNL is NL-1,
	create_list(NL, AuxNC, ZeroedL),
	create_list(AuxNC, NL, ZeroedC).

create_list(N, L, List):- create_list(N, L, [], List).
create_list(0, _, List, List).
create_list(N, L, Accum, List):-
	N>0, NewN is N-1, build_value(0, L, Temp),
	append(Accum, [Temp], Accum2),
	create_list(NewN, L, Accum2, List).

build_value(X, L, List):- build_value(X, L, [], List).
build_value(_, 0, List, List).
build_value(X, L, Accum, List):-
	L>0, NewL is L-1,
	append(Accum, [X], Accum2),
	build_value(X, NewL,Accum2, List).

build_value(X, L, List)  :-
	length(List, L),
	maplist(=(X), List).
*/

%--------------------------------------------------%

%Asks the user for the arguments of the puzzle (i.e. its dimensions and restrictions)
get_arguments(NL, NC, P):-
	get_dimensions(NL, NC),
	get_restrictions(NL, NC, P).

%Asks the user for the puzzle restrictions
get_restrictions(NL, NC, P):-
	NC1 is NC - 1, NL1 is NL - 1,
	write('Line Cell (Press f if you have finished adding restrictions to the grid)'),
	get_integer(LC, 1, NL1), (
	(LC = 'f', P = []);
	(write('Column Cell (Press f if you have finished adding restrictions to the grid)'),
	get_integer(CC, 1, NC1), (
	(CC = 'f', P = []);
	(write('Amount of line segments used by that cell (Press f if you have finished adding restrictions to the grid)'),
	get_integer(A, 0, 4), (
	(A = 'f', P =[]) ;
	 ( P = [[LC, CC, A] | P2] , get_restrictions(NL, NC, P2))))))).

%Asks the user the dimensions of the puzzle
get_dimensions(NL, NC) :-
		write('\nType the number of lines in the board: '),
		get_integer(NL, 2, 10000),
		write('Type the number of columns in the board'),
		get_integer(NC, 2, 10000).


%---------------------------------------------GET_INTEGER-----------------------------------------------
%Asks the user for an integer in a certain interval
get_integer(I,Min, Max):-
	read(N),
	((N = 'f',I = 'f');
	(isinteger(N, N2, Min, Max),
	(
	(((integer(N) ,N =< Max, N >= Min) ; N = 'f'), N = I);
	(((integer(N2), N2 =< Max, N2 >= Min) ; N2 = 'f'), N2 = I)))).

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


