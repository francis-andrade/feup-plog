debug_fence1:-
	%cell(Line, Column, Value).
	abolish(cell/3),
	asserta(cell(1,1,0)),
	asserta(cell(1,2,0)),
	asserta(cell(1,4,1)),
	asserta(cell(1,6,1)),
	asserta(cell(2,6,1)),
	asserta(cell(3,1,3)),
	asserta(cell(3,3,1)),
	asserta(cell(4,4,3)),
	asserta(cell(4,6,1)),
	asserta(cell(5,1,3)),
	asserta(cell(6,1,3)),
	asserta(cell(6,3,3)),
	asserta(cell(6,5,1)),
	asserta(cell(6,6,2)),
    solve_puzzle(7,7, Lines, Columns),
	display_puzzle(7, 7, Lines, Columns, 1).
	

debug_fence2:-
	%cell(Line, Column, Value).
	abolish(cell/3),
	asserta(cell(1,5,0)),
	asserta(cell(2,1,3)),
	asserta(cell(2,2,3)),
	asserta(cell(2,5,3)),
	asserta(cell(3,3,1)),
	asserta(cell(3,4,2)),
	asserta(cell(4,3,2)),
	asserta(cell(4,4,0)),
	asserta(cell(5,2,1)),
	asserta(cell(5,5,1)),
	asserta(cell(5,6,1)),
	asserta(cell(6,2,2)),
    solve_puzzle(7,7, Lines, Columns),
	display_puzzle(7, 7, Lines, Columns, 1).	


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












testsol1:-
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
	
	Vars = 
	[1, 1, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1,
    0, 0, 0, 0, 1, 1,
	1, 0, 0, 1, 0, 0, 0,
    1, 0, 0, 1, 0, 0, 0,
    1, 0, 0, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 1, 1],
	
	convert(Vars, 7, 7, LT, CT),
	write(LT),nl, write(CT),
	LT = L,
	CT = C .
	
testsol2 :-
	domain([X], 1, 2), X = Y, Y = 2,
	labeling([], [X]),
	write(X), false.

testsol3 :-
	X = Y, X = 3,
	write(Y).
	
testsol4 :-
		length(L, 3),
		domain(L, 1, 3),
		reverse(L2 , L),
		element(1, L2, E1),
		element(2, L2, E2),
		element(3, L2, E3),
		E3 #= 3,
		E2 #= 2, 
		E1 #= 1,
		labeling([ff], L),
		write(L), false.

testsol5:-
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
display_puzzle(7, 7, L, C, 1),
firstOne(L, 1, [Xant, Yant]), 
write([Xant, Yant]),nl,
X #= Xant + 1,
loop(L, C, [[X, Yant] | [[Xant, Yant] | []]]) 
.

testsol6:-
Vars = [0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1,1,0,1,0,0,1,1,1,1,0,1,0,0,0,1,1,0,1,1,1,0,0,0,0,1,1,0,0,0,1,1,1,1,0,1,1,1,0,0,1,0,1,0,0,1,0,0,0,0,1,0,0,0,0,1,1,0,1,1,0,0,1],

convert(Vars, 7, 7, L, C),
display_puzzle(7, 7, L, C, 1),
firstOne(L, 1, [Xant, Yant]), 
X #= Xant + 1,
loop(L, C, [[X, Yant] | [[Xant, Yant] | []]]).




