%------------------------------------------------TESTS--------------------------------------------------------
%In this module there are several tests with predefined puzzle
debug_fence1:-
	abolish(cell/3),
	P = [
			[1,1,0],
			[1,2,0],
			[1,4,1],
			[1,6,1],
			[2,6,1],
			[3,1,3],
			[3,3,1],
			[4,4,3],
			[4,6,1],
			[5,1,3],
			[6,1,3],
			[6,3,3],
			[6,5,1],
			[6,6,2]
		],
    assertCell(P),
	nl, write('Puzzle Restrictions'),nl,
	display_puzzle(7, 7, P, 1),
    solve_puzzle(7,7, Lines, Columns),
	nl, write('Solution: '),nl,
	display_puzzle(7, 7, Lines, Columns, 1).
	

debug_fence2:-
	abolish(cell/3),
	P = [[1, 5, 0], 
		 [2, 1, 3],
		 [2, 2, 3],
		 [2, 5, 1],
		 [3, 3, 1],
		 [3, 4, 2],
		 [4, 3, 2],
		 [4, 4, 0],
		 [5, 2, 1],
		 [5, 5, 1],
		 [5, 6, 1],
		 [6, 2, 2]],
	assertCell(P),
	nl, write('Puzzle Restrictions: '),nl,
	display_puzzle(7, 7, P, 1),
    solve_puzzle(7,7, Lines, Columns),
	nl, write('Solution: '),nl,
	display_puzzle(7, 7, Lines, Columns, 1).	

debug_fence3:-
	abolish(cell/3),
	P = [[3, 1, 3], 
		 [2, 1, 3]],
	assertCell(P),
	nl, write('Puzzle Restrictions: '),nl,
	display_puzzle(4, 2, P, 1),
    solve_puzzle(4,2, Lines, Columns),
	nl, write('Solution: '),nl, 
	display_puzzle(4, 2, Lines, Columns, 1).
	