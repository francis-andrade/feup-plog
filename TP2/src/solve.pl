

lines([
    [L1C1, L1C2, L1C3, L1C4, L1C5, L1C6],
    [L2C1, L2C2, L2C3, L2C4, L2C5, L2C6],
    [L3C1, L3C2, L3C3, L3C4, L3C5, L3C6],
    [L4C1, L4C2, L4C3, L4C4, L4C5, L4C6],
    [L5C1, L5C2, L5C3, L5C4, L5C5, L5C6],
    [L6C1, L6C2, L6C3, L6C4, L6C5, L6C6],
    [L7C1, L7C2, L7C3, L7C4, L7C5, L7C6]
]).

columns([
    [C1L1, C2L1, C3L1, C4L1, C5L1, C6L1, C7L1],
    [C1L2, C2L2, C3L2, C4L2, C5L2, C6L2, C7L2],
    [C1L3, C2L3, C3L3, C4L3, C5L3, C6L3, C7L3],
    [C1L4, C2L4, C3L4, C4L4, C5L4, C6L4, C7L4],
    [C1L5, C2L5, C3L5, C4L5, C5L5, C6L5, C7L5],
    [C1L6, C2L6, C3L6, C4L6, C5L6, C6L6, C7L6]
]).

%cell(Line, Column, Value).
cell(1,1,0).
cell(1,2,0).
cell(1,4,1).
cell(1,6,1).
cell(2,6,1).
cell(3,1,3).
cell(3,3,1).
cell(4,4,3).
cell(4,6,1).
cell(5,1,3).
cell(6,1,3).
cell(6,3,3).
cell(6,5,1).
cell(6,6,2).

%-------------------------------------------------------------%

debug_fence:-
    solve_puzzle(7,7, Lines, Columns),
	display_puzzle(7, 7, Lines, Columns, 1).

solve_puzzle(NL, NC, Lines, Columns):-
    write('Solving puzzle...'), nl,
    Mult is NL * (NC - 1) + NC * (NL - 1),
	length(Vars, Mult),
	domain(Vars, 0, 1),
	convert(Vars, NL, NC, Lines , Columns),
    write('    1. Processed domains'), nl,
    findall(X-Y-L, cell(Y, X, L), Cells), 
    write('    2. Found all numbered cells and processed them'), nl,
    restrict(Lines, Columns, Cells),
    write('    3. Restricted segments in numbered cells'), nl,
    adjacent(Lines, Columns, 1, 1),
    write('    4. Restricted adjacent segments'), nl,
    % TODO criar apenas **UM** caminho
	firstOne(Lines, 1, [XF, YF]), XF1 #= XF + 1,
	loop(Lines, Columns, [[XF1, YF],[XF, YF]]),
    write('    5. Restricted path multiplicity to just one path'), nl,
    write('Labeling variables...'), nl,
	calculateSize(Lines, Columns, Size),
	labeling([ff, maximize(Size)], Vars),
    write('Size: '), write(Size), nl . 

/*debug_fence:-
    lines(L), columns(C),
    solve_puzzle(L,C).	
	
solve_puzzle(Lines, Columns):-
    write('Solving puzzle...'), nl,
    segment_domain(Lines),
    segment_domain(Columns),
    write('    1. Processed domains'), nl,
    findall(X-Y-L, cell(Y, X, L), Cells), write(Cells),
    write('    2. Found all numbered cells and processed them'), nl,
    restrict(Lines, Columns, Cells),
    write('    3. Restricted segments in numbered cells'), nl,
    adjacent(Lines, Columns, 1, 1),
    write('    4. Restricted adjacent segments'), nl,
    % TODO criar apenas **UM** caminho
    %write('    5. Restricted path multiplicity to just one path'), nl,
    write('Labeling variables...'), nl,
	calculateSize(Lines, Columns, Size),
    labeling_matrix(Lines, Size),
    labeling_matrix(Columns, Size),
    write(Lines), nl, write(Columns),nl,
	display_puzzle(7, 7, Lines, Columns, 1), false.	*/

subset_aux(_List, _Indice, Length, Sublist, Sublist_aux):-
	length(Sublist_aux, Length), !,
	reverse(Sublist, Sublist_aux) .

subset_aux(List, Indice, Length, Sublist, Sublist_aux):-
	element(Indice, List, Elem),
	Ind1 #= Indice + 1,
	subset_aux(List, Ind1, Length, Sublist, [Elem | Sublist_aux]).
	
subset(List, InitialIndice, Length, Sublist):-
	subset_aux(List, InitialIndice, Length, Sublist, []).
	
	
convert_aux(Vars,L, C, Lines, Columns, Lines_aux, Columns_aux, Ind):-
	Mult #= L * (C - 1),
	Ind #=< Mult, !, C1 is C - 1,
	subset(Vars, Ind, C1, SVars),
	Indnew #= Ind + C1,
	convert_aux(Vars, L, C, Lines, Columns, [SVars | Lines_aux], Columns_aux, Indnew).

convert_aux(Vars,L, C, Lines, Columns, Lines_aux, Columns_aux, Ind):-
	Mult #= L * (C - 1) + C * (L - 1),
	Ind #=< Mult, !,
	subset(Vars, Ind, C, SVars),
	Indnew #= Ind + C,
	convert_aux(Vars, L, C, Lines, Columns, Lines_aux, [SVars | Columns_aux], Indnew).	

convert_aux(_Vars,_L, _C, Lines, Columns, Lines_aux, Columns_aux, _Ind):-
	reverse(Lines_aux, Lines),
	reverse(Columns_aux, Columns).
	
convert(Vars,L, C, Lines,Columns):-
	convert_aux(Vars, L, C, Lines, Columns, [],[], 1).
	
segment_domain([]).
segment_domain([Line|Tail]):-
    domain(Line, 0, 1),
    segment_domain(Tail).


%restrict(Lines, Columns, X, Y).
restrict(_, _, []).
restrict(Lines, Columns, [X-Y-Limit|Tail]) :-
    %checking horizontal edges - left C(X, Y) and right C(X+1, Y)
    NewX is X+1,
    nth1(Y, Columns, Cols),
    element(X, Cols, Left),
    element(NewX, Cols, Right),

    %checking vertical edges- up L(X, Y) and down L(X, Y+1)
    NewY is Y+1,
    nth1(Y, Lines, LineT),
    nth1(NewY, Lines, LineB),
    element(X, LineT, Up),
    element(X, LineB, Down),

    %restrict and continue
    sum([Up, Down, Left, Right], #=, Limit),
    restrict(Lines, Columns, Tail).

%adjacent(Lines, Columns, X, Y)
adjacent(Lines, _, _, Y):- length(Lines, Y1),  Y1 #= Y - 1, ! .

adjacent(Lines, Columns, X, Y):- 
	nth1(Y, Lines, Line), 
	length(Line, NLine1), 
	X #= NLine1 + 2, !,
	NewY is Y + 1, adjacent(Lines, Columns, 1, NewY).


/*adjacent(_, _, _, 8).

adjacent(Lines, Columns, 8, Y):- NewY is Y+1, adjacent(Lines, Columns, 1, NewY).	*/
	
adjacent(Lines, Columns, X, Y):-
	length(Lines, NLines),
	nth1(Y, Lines, Line), length(Line, NLine1), NLine #= NLine1 + 1,
    %checking lines (example matrix is 7x6)
    %write('adjacent '), write(X), write(', '), write(Y), write(' ||'),
    nth1(Y, Lines, Line),
    (X < NLine, element(X, Line, Right); X = NLine, Right #= 0),
    (X >= 2, PrevX is X-1, element(PrevX, Line, Left); X=1, Left #= 0),

    %checking columns (example matrix is 6x7)
    (Y < NLines, nth1(Y, Columns, ColsDn), element(X, ColsDn, Down); Y = NLines, Down #= 0),
    (Y >= 2, PrevY is Y-1, nth1(PrevY, Columns, ColsUp), element(X, ColsUp, Up); Y = 1, Up #= 0),

    %restricting and continuing to process the matrix (go through dots horizontally)
    (Left + Right + Up + Down #= 0 #\/ Left + Right + Up + Down #= 2) #<=> B,
    B #= 1,
    NewX is X+1,
    adjacent(Lines, Columns, NewX, Y).


	

firstOne_aux(Line, _X, X_aux):- 
	length(Line, X1), X_aux #= X1 + 1,!, false.
	
firstOne_aux(Line, X, X_aux):-
	element(X_aux, Line, 1), ! ,X #= X_aux.

firstOne_aux(Line, X, X_aux):-
	X1 #= X_aux + 1,
	firstOne_aux(Line,X, X1) .   
	
firstOne(Lines, Ind, [_X , _Y]):- length(Lines, Ind1), Ind1 #= Ind - 1,!, false . 
	
firstOne(Lines, Ind, [X , Y]):-
	nth1(Ind, Lines, Line), 
	firstOne_aux(Line, X, 1),  Ind #= Y, ! .
	
firstOne(Lines, Ind, [X , Y]):-
	Ind1 is Ind + 1,
	firstOne(Lines, Ind1, [X , Y]).	


nextVertice([X, Y], [Xant, Yant],[Xnext, Ynext], [_Left, Right, Up, Down]):-
	Xant #= X - 1, Yant #= Y, !,
	((Right #= 1, Xnext #= X + 1, Ynext #= Y);
	(Up #= 1, Ynext #= Y - 1, Xnext #= X);
	(Down #= 1, Ynext #= Y + 1, Xnext #= X)).

nextVertice([X, Y], [Xant, Yant],[Xnext, Ynext], [Left, _Right, Up, Down]):-
	Xant #= X + 1, Yant #= Y, !,
	((Left #= 1, Xnext #= X - 1, Ynext #= Y);
	(Up #= 1, Ynext #= Y - 1, Xnext #= X);
	(Down #= 1, Ynext #= Y + 1, Xnext #= X)).

nextVertice([X, Y], [Xant, Yant],[Xnext, Ynext], [Left, Right, _Up, Down]):-
	Xant #= X, Yant #= Y - 1, !,
	((Right #= 1, Xnext #= X + 1, Ynext #= Y);
	(Left #= 1, Xnext #= X - 1, Ynext #= Y);
	(Down #= 1, Ynext #= Y + 1, Xnext #= X)).

nextVertice([X, Y], [Xant, Yant],[Xnext, Ynext], [Left, Right, Up, _Down]):-
	Xant #= X, Yant #= Y + 1, !,
	((Right #= 1, Xnext #= X + 1, Ynext #= Y);
	(Left #= 1, Xnext #= X - 1, Ynext #= Y);
	(Up #= 1, Ynext #= Y - 1, Xnext #= X)).	

calculateSize_aux(Lines, Ind, TmpSize, Size):-
	length(Lines, NLines),
	Ind #= NLines + 1, !, TmpSize #= Size .

calculateSize_aux(Lines, Ind, TmpSize, Size):-
	nth1(Ind, Lines, Line),
	count(1, Line, #=, Amount), 
	NewSize #= TmpSize + Amount,
	Ind1 #= Ind + 1,
	calculateSize_aux(Lines, Ind1, NewSize, Size).	
	
	
calculateSize(Lines, Columns, Size):-
	calculateSize_aux(Lines, 1, 0, LSize),
	calculateSize_aux(Columns, 1, 0, CSize),
	LSize + CSize #= Size .
		
	
loop(Lines, Columns, [[X, Y] | [[_Xant, _Yant] | Tail]]):-
		%write([X,Y]),nl,
		length(Tail, TailN),TailN #> 0, 
		nth1(TailN, Tail, TailFirst), 
		[X,Y] = TailFirst,!,
		calculateSize(Lines, Columns, Size), 
		%write(Size), write(TailN),
		Size #= TailN + 1 
		.
		
		
	
loop(Lines, Columns, [[X, Y] | [[Xant, Yant] | Tail]]):-
	%write([X,Y]),nl,
	length(Lines, NLines),
	nth1(Y, Lines, Line), length(Line, NLine1), NLine #= NLine1 + 1,
	
    (X < NLine, element(X, Line, Right); X = NLine, Right #= 0),
    (X >= 2, PrevX is X-1, element(PrevX, Line, Left); X=1, Left #= 0),

    %checking columns (example matrix is 6x7)
    (Y < NLines, nth1(Y, Columns, ColsDn), element(X, ColsDn, Down); Y = NLines, Down #= 0),
    (Y >= 2, PrevY is Y-1, nth1(PrevY, Columns, ColsUp), element(X, ColsUp, Up); Y = 1, Up #= 0),

    %restricting and continuing to process the matrix (go through dots horizontally)
    Left + Right + Up + Down #= 2,
	%write(nextVertice([X, Y], [Xant, Yant], [Xnext, Ynext], [Left, Right, Up, Down])),
	nextVertice([X, Y], [Xant, Yant], [Xnext, Ynext], [Left, Right, Up, Down]),
	loop(Lines, Columns, [[Xnext, Ynext] | [[X, Y] | [[Xant, Yant] | Tail]]]).
	
	 
	
	
labeling_matrix([]).
labeling_matrix([Line|Tail]):-
    labeling([ff], Line),
    labeling_matrix(Tail).
	

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
