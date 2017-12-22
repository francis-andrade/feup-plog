

%-------------------------------------------------------------%

solve_puzzle(NL, NC, Lines, Columns):-
    write('Solving puzzle...'), nl,
    Mult is NL * (NC - 1) + NC * (NL - 1),
	length(Vars, Mult),
	domain(Vars, 0, 1),
	convert(Vars, NL, NC, Lines , Columns),
    write('    1. Processed domains'), nl,
    findall(X-Y-L, (cell(Y, X, L), X > 0), Cells), 
    write('    2. Found all numbered cells and processed them'), nl,
    restrict(Lines, Columns, Cells),
    write('    3. Restricted segments in numbered cells'), nl,
    adjacent(Lines, Columns, 1, 1),
    write('    4. Restricted adjacent segments'), nl,
	%firstOne(Lines, 1, [XF, YF]), XF1 #= XF + 1,
	%element(XL, Vars, 1), XL #=< NL * (NC - 1), YF #= (XL / (NC - 1)) + 1, XF #= XL mod (NC - 1), XF1 #= XF + 1,    
	%loop(Lines, Columns, [[XF1, YF],[XF, YF]]),write('b2'),
    write('    5. Restricted path multiplicity to just one path'), nl,	
    write('Labeling variables...'), nl,
	%calculateSize(Lines, Columns, Size),
	labeling([], Vars),
	firstOne(Lines, 1, [XF, YF]), XF1 #= XF + 1
	,loop(Lines, Columns, [[XF1, YF],[XF, YF]])
	%,firstOne(Lines, 1, [XF, YF]), XF1 #= XF + 1
	. 

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
	

%restrict(Lines, Columns, X, Y).
restrict(_, _, []):- ! .
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
    Left + Right + Up + Down #= 0 #\/ Left + Right + Up + Down #= 2,
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
	%write(
	Ind1 #= Ind + 1,
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
	
	 
	


