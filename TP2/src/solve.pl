

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

fence:-
    lines(L), columns(C),
    solve_puzzle(L,C).

solve_puzzle(Lines, Columns):-
    write('Solving puzzle...'), nl,
    segment_domain(Lines),
    segment_domain(Columns),
    write('    1. Processed domains'), nl,
    findall(X-Y-L, cell(X, Y, L), Cells),
    write('    2. Found all numbered cells and processed them'), nl,
    restrict(Lines, Columns, Cells),
    write('    3. Restricted segments in numbered cells'), nl,
    adjacent(Lines, Columns, 1, 1),
    write('    4. Restricted adjacent segments'), nl,
    % TODO criar apenas **UM** caminho
    %write('    5. Restricted path multiplicity to just one path'), nl,
    write('Labeling variables...'), nl,
    labeling_matrix(Lines),
    labeling_matrix(Columns).

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
    Up + Down + Left + Right #= Limit,
    restrict(Lines, Columns, Tail).

%adjacent(Lines, Columns, X, Y)
adjacent(_, _, _, 8).
adjacent(Lines, Columns, 8, Y):- NewY is Y+1, adjacent(Lines, Columns, 1, NewY).
adjacent(Lines, Columns, X, Y):-
    %checking lines (example matrix is 7x6)
    nth1(Y, Lines, Line),
    (X =< 6, element(X, Line, Right); X = 7, Right #= 0),
    (X >= 2, PrevX is X-1, element(PrevX, Line, Left); X=1, Left #= 0),

    %checking columns (example matrix is 6x7)
    (Y =< 5, nth1(Y, Columns, ColsDn), element(X, ColsDn, Down); Y = 6, Down #= 0),
    (Y >= 2, PrevY is Y-1, nth1(PrevY, Columns, ColsUp), element(X, ColsUp, Up); Y = 1, Up #= 0),

    %restricting and continuing to process the matrix (go through dots horizontally)
    (Left + Right + Up + Down #= 0 #\/ Left + Right + Up + Down #= 2) #<=> B,
    B #= 1,
    NewX is X+1,
    adjacent(Lines, Columns, NewX, Y).

labeling_matrix([]).
labeling_matrix([Line|Tail]):-
    labeling([ff], Line),
    labeling_matrix(Tail).