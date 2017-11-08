/*
Move is represented by [edge , row]
*/

:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('check_win.pl').


valid_move(Board, Player,  Move, NewBoard) :- 
	Move=['left', N],
	N>0, N<8,
	get_line(N, Board, Line), possible_move(Line),
    remove_first_zero(Line, _line), insert_head_line(Player, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),!.
	
valid_move(Board, Player,  Move, NewBoard) :- 
	Move=['right', N],
	N>0, N<8,
	get_line(N, Board, Line), possible_move(Line),
    remove_last_zero(Line, _line), insert_end_line(Player, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),!.

valid_move(Board, Player,  Move, NewBoard) :- 
	Move=['up', N],
	N>0, N<8,
	transpose(Board, Trans_Board),
	valid_move(Trans_Board, Player, ['left',N], Trans_NewBoard),
	transpose(Trans_NewBoard,NewBoard),!.
	
valid_move(Board, Player,  Move, NewBoard) :- 
	Move=['down', N],
	N>0, N<8,
	transpose(Board, Trans_Board),
	valid_move(Trans_Board, Player, ['right',N], Trans_NewBoard),
	transpose(Trans_NewBoard,NewBoard),!.
	
valid_move(Board, Player, Move, 0);

valid_moves_make_list_aux(Board, Player,Move, N, List):-
	valid_move(Board, Player, Move, NewBoard),
	Move=[Edge, X],	
	nth1(N, List, NewBoard),
	X1 is X + 1, N1 is N + 1,
	(X = 7; valid_moves_make_list_aux(Board, Player, [Edge, X + 1], N + 1, List)).

valid_moves_make_list(Board, Player, List):-
	valid_moves_make_list_aux(Board, Player,['left',1], 1, List),
	valid_moves_make_list_aux(Board, Player,['right',1], 8, List),
	valid_moves_make_list_aux(Board, Player,['up',1], 15, List),
	valid_moves_make_list_aux(Board, Player,['down',1], 22, List).
	
	
	
cmp_lists(ListOfMoves, ListOfMoves_0):-
	(ListOfMoves=[], ListOfMoves_0=[]);
	(ListOfMoves_0=[0|L_02], cmp_lists(L_02, ListOfMoves_0)).
	
cmp_lists(ListOfMoves, ListOfMoves_0):-
	ListOfMoves_0=[X_0, L_02],
	X_0 \= 0, 
	ListOfMoves=[X, L2],
	X=X_0,
	cmp_lists(L2,L_02).
	
	

valid_moves(Board, Player, ListOfMoves):-
	valid_moves_make_list(Board, Player, ListOfMoves_0),
	cmp_lists(ListOfMoves, ListOfMoves_0).
	