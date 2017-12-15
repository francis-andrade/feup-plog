fence:-
    get_arguments(NL, NC, P),
	assertCell(P),
	/*,	
    display_puzzle(M),
    solve(L,C),
    display_puzzle(L)*/.

display_point(1):- !,
	write('.').
	
display_point(L):-
	L > 1,
	write('. '), L1 is L - 1,
	display_point(L1).
	
display_puzzle(NL, NC, P, Ind):-
	display_point(NC),
	write('\n '),
	display_restriction(NC, Ind,  P).
	
	
assertCell([]):- !.

assertCell( [[Arg1, Arg2, Arg3]| P2]):-
	assert(cell(Arg1, Arg2, Arg3))
	assertCell(P2).
	
	
get_arguments(NL, NC, P):-
	get_dimensions(NL, NC),
	get_puzzle(NL, NC, P).

get_puzzle(NL, NC, P):-
	write('Line Cell (Press -1 if you have finished adding restrictions to the grid)'),
	get_integer(LC, -1, NL), (
	(LC = -1, P = []);
	(write('Column Cell (Press -1 if you have finished adding restrictions to the grid)'),
	get_integer(CC, -1, NC), (
	(CC = -1, P = []);
	(write('Amount of line segments used by that cell (Press -1 if you have finished adding restrictions to the grid)'),
	get_integer(A, 0, 4), (
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
	