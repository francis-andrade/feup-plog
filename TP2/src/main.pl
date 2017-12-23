:-dynamic cell/3 .

:-use_module(library(clpfd)).
:-use_module(library(lists)).
:- use_module(library(random)).
:-include('solve.pl').
:-include('test.pl').
:-include('user_interface.pl').



%main function
fence:-
    display_main_menu,
	get_integer(Option, 0, 2),!,
	menu_options(Option).


%exits game
menu_options(0).

%asks the user to input the puzzle restrictions
menu_options(1):-
	get_arguments(NL, NC, P),
	abolish(cell/3),
	asserta(cell(0,0,0)),
	assertCell(P),
	nl, write('Puzzle Restrictions: '),nl,
	create_empty(NL,NC,ZeroedL,ZeroedC),
	display_puzzle(ZeroedL, ZeroedC, P, 1, 1), !,
	((solve_puzzle(NL, NC, Lines, Columns),
	write('\nSolution: '),nl,
	display_puzzle(Lines, Columns, P, 1, 1));
	(write('\nThe puzzle does not have any solutions.'))),nl.

%generates the puzzle in a semi-random way
menu_options(2):-
	generate_puzzle(NL, NC, P),
	write('Number of Lines: '), write(NL), nl,
	write('Number of Columns: '), write(NC),nl,
	abolish(cell/3),
	asserta(cell(0,0,0)),
	assertCell(P),
	nl, write('Puzzle Restrictions: '),nl,
	create_empty(NL,NC,ZeroedL,ZeroedC),
	display_puzzle(ZeroedL, ZeroedC, P, 1, 1), !,
	((solve_puzzle(NL, NC, Lines, Columns),
	write('\nSolution: '),nl,
	display_puzzle(Lines, Columns, P, 1, 1));
	(write('\nThe puzzle does not have any solutions.'))),nl.


%--------------------- GENERATE_PUZZLE ----------------------%
%Generates a puzzle in a semi-random fashion
generate_puzzle_aux(NL, _NC, P, P_aux, IndL,_IndC):- IndL = NL, !, P = P_aux .
generate_puzzle_aux(NL, NC, P, P_aux, IndL,IndC):- IndC = NC, !,IndL1 is IndL + 1, generate_puzzle_aux(NL, NC, P, P_aux, IndL1, 1).
generate_puzzle_aux(NL, NC, P, P_aux, IndL,IndC):-
	IndC1 is IndC + 1,
	random(0, 100, Amount),
	(
	(Amount > 20,!,  generate_puzzle_aux(NL, NC, P, P_aux, IndL,IndC1)) ;
	(Amount = 20, !,
	generate_puzzle_aux(NL, NC, P, [[IndL, IndC, 3] | P_aux], IndL,IndC1)
	);
	(Amount > 17, !,
	generate_puzzle_aux(NL, NC, P, [[IndL, IndC, 3] | P_aux], IndL,IndC1)
	);
	(Amount > 13, !,
	generate_puzzle_aux(NL, NC, P, [[IndL, IndC, 2] | P_aux], IndL,IndC1)
	);
	(Amount > 6, !,
	generate_puzzle_aux(NL, NC, P, [[IndL, IndC, 1] | P_aux], IndL,IndC1)
	);
	generate_puzzle_aux(NL, NC, P, [[IndL, IndC, 0] | P_aux], IndL,IndC1)
	).

generate_puzzle(NL, NC, P):-
	random(2, 8, NL),
	random(2, 8, NC),
	generate_puzzle_aux(NL, NC, P, [], 1, 1).


%asserts the restrictions of the puzzle
assertCell([]):- !.

assertCell( [[Arg1, Arg2, Arg3]| P2]):-
	asserta(cell(Arg1, Arg2, Arg3)),
	assertCell(P2).


