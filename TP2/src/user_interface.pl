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


%--------------------------------------------------------DISPLAY_PUZZLE------------------------------------------------------------
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

%--------------------------------------------------------DISPLAY_PUZZLE------------------------------------------------------------
%This version of display_puzzle displays the final solution	
display_line_aux(NC, _L, _IndLine, NC):- ! .

display_line_aux(_NC,L, IndLine, IndCol):-
	nth1(IndLine, L, LineIndL),
	nth1(IndCol, LineIndL, 0),!,
	write(' ').

display_line_aux(_NC, L, IndLine, IndCol):-
	nth1(IndLine, L, LineIndL),
	nth1(IndCol, LineIndL, 1),!,
	write('_').

display_line(NC, _L, _C, _IndLine, IndCol):- IndCol is NC + 1, ! .

display_line(NC, L, C, IndLine, IndCol):-
	IndL1 is IndLine -1,
	nth1(IndL1, C, ColIndL),
	nth1(IndCol, ColIndL, 1), !,
	write('|'),display_line_aux(NC, L, IndLine, IndCol),
	IndCol1 is IndCol + 1,
	display_line(NC, L, C, IndLine, IndCol1).

display_line(NC, L, C, IndLine, IndCol):-
	write(' '),display_line_aux(NC, L, IndLine, IndCol),
	IndCol1 is IndCol + 1,
	display_line(NC, L, C, IndLine, IndCol1).


display_puzzle(NL, _NC, _L, _C, Ind):- Ind is NL + 1, ! . 
	
display_puzzle(NL, NC, L, C, Ind):-
	display_line(NC, L, C, Ind, 1), Ind1 is Ind +1,
	write('\n'),
	display_puzzle(NL, NC,L,C, Ind1).

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


