/*
Move is represented by [edge , row]
*/

:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('check_win.pl').


valid_move(Board, Player, ['left', N], NewBoard) :-
	%Move=['left', N],
	N>0, N<8,
	get_line(N, Board, Line), possible_move(Line),
    remove_first_zero(Line, _line), insert_head_line(Player, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),!.

valid_move(Board, Player, ['right', N], NewBoard) :-
	%Move=['right', N],
	N>0, N<8,
	get_line(N, Board, Line), possible_move(Line),
    remove_last_zero(Line, _line), insert_end_line(Player, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),!.

valid_move(Board, Player,  ['up', N], NewBoard) :-
	%Move=['up', N],
	N>0, N<8,
	transpose(Board, Trans_Board),
	valid_move(Trans_Board, Player, ['left',N], Trans_NewBoard),
	transpose(Trans_NewBoard,NewBoard),!.

valid_move(Board, Player,  ['down', N], NewBoard) :-
	%Move=['down', N],
	N>0, N<8,
	transpose(Board, Trans_Board),
	valid_move(Trans_Board, Player, ['right',N], Trans_NewBoard),
	transpose(Trans_NewBoard,NewBoard),!.

valid_move(Board, Player, Move, 0).



valid_moves_make_list_aux(Board, Player, Move, ListOfMoves_0):-
	Move=['left', 8],!,
	valid_moves_make_list_aux(Board, Player, ['right',1], ListOfMoves_0).

valid_moves_make_list_aux(Board, Player, Move, ListOfMoves_0):-
        Move=['right', 8],!,
        valid_moves_make_list_aux(Board, Player, ['up',1], ListOfMoves_0).

valid_moves_make_list_aux(Board, Player, Move, ListOfMoves_0):-
        Move=['up', 8],!,
        valid_moves_make_list_aux(Board, Player, ['down',1], ListOfMoves_0).

valid_moves_make_list_aux(Board, Player, Move, ListOfMoves_0):-
        Move=['down', 8],!,
        ListOfMoves_0=[].

valid_moves_make_list_aux(Board, Player,Move, ListOfMoves_0):-
        Move=[Edge, X],
        ListOfMoves_0=[NewBoard | L2],
        valid_move(Board, Player, Move, NewBoard),
        X1 is (X + 1),
        valid_moves_make_list_aux(Board, Player, [Edge, X1], L2).


valid_moves_make_list(Board, Player, ListOfMoves_0):-
	valid_moves_make_list_aux(Board, Player,['left',1], ListOfMoves_0).



cmp_lists(ListOfMoves, ListOfMoves_0):-
	(ListOfMoves=[], ListOfMoves_0=[]);
	(ListOfMoves_0=[0|L_02], cmp_lists(ListOfMoves, L_02)).

cmp_lists(ListOfMoves, ListOfMoves_0):-
	ListOfMoves_0=[X_0 | L_02],
	X_0 \= 0,
	ListOfMoves=[X | L2],
	X=X_0,
	cmp_lists(L2,L_02).



valid_moves(Board, Player, ListOfMoves):-
	valid_moves_make_list(Board, Player, ListOfMoves_0),
	cmp_lists(ListOfMoves, ListOfMoves_0).

display_boards(ListOfBoards):-
        ListOfBoards=[0 | L2],
	write(' 0 '),nl,
	display_boards(L2).

display_boards(ListOfBoards):-
	ListOfBoards=[Board | L2],
	display_board(Board),
	display_boards(L2).

display_boards([]).

test1:-
        valid_moves([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]],1,K),
	display_boards(K).

test22:-
	valid_moves_make_list([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,1,1,1]],1,K),
        display_boards(K).

test2:-
        valid_moves([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,1,1,1]],1,K),
        display_boards(K).

test3:-
        valid_moves([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,1,1,0]],1,K),
        display_boards(K).


