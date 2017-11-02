:-use_module(library(lists)).

%-------------------- Auxiliar predicates -------------------%

possible_move(Line):-
    member(0, Line).

insert_head_line(Player,Line,NLine):-
    append([Player],Line,NLine).

insert_end_line(Player,Line,NLine):-
    append(Line,[Player],NLine).
	
remove_first_zero(Line, NLine) :-
	Line = [0 | Line2],
	NLine = Line2.

remove_first_zero(Line, NLine) :-
	Line = [X | Line2],
	X \= 0,
	NLine = [X | NLine2],
	remove_first_zero(Line2, NLine2).

remove_first_zero([],[]).

remove_last_zero(Line, NLine) :- 
	reverse(Line, Line2),
	remove_first_zero(Line2, NLine2),
	reverse(NLine2, NLine).


%------------------- Obtaining player move ------------------%
get_move(Edge, Row):- 
	repeat,
		get_edge(Edge),
		get_row(Row).

get_edge(Edge):-
    write('Choose a board edge to insert the piece (up, down, left, right): '), nl,
    read(Edge), member(Edge,['up', 'down', 'left', 'right']).

get_edge(Edge):-
    write('Invalid input; Try again.'), nl,
    get_edge(Edge).

get_row(Row):-
    get_integer('Choose a row: ', 1, 7,Row).


%---------------- Insert piece on board edge ----------------%
insert_piece(Board, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces):-
	get_move(Edge, Row),
	insert_piece(Board, Edge, Row, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces).	

insert_piece(Board, left, N, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces):-
    CurrentPieces > 0,
    get_line(N, Board, Line), possible_move(Line),
    remove_first_zero(Line, _line), insert_head_line(CurrentPlayer, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),
    NewCurrentPieces is CurrentPieces - 1.

insert_piece(Board, right, N, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces):-
    CurrentPieces > 0,
    get_line(N, Board, Line), possible_move(Line),
    remove_last_zero(Line, _line), insert_end_line(CurrentPlayer, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),
    NewCurrentPieces is CurrentPieces - 1.

insert_piece(Board, up, N, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces):-
    transpose(Board, _tempInit),
    insert_piece(_tempInit, left, N, CurrentPlayer, _tempEnd, CurrentPieces, OpponentPieces, NewCurrentPieces),
    transpose(_tempEnd, NewBoard).

insert_piece(Board, down, N, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces):-
    transpose(Board, _tempInit),
    insert_piece(_tempInit, right, N, CurrentPlayer, _tempEnd, CurrentPieces, OpponentPieces, NewCurrentPieces),
    transpose(_tempEnd, NewBoard).