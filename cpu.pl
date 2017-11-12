/*
Move is represented by [edge , row]
*/

:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('check_win.pl').



valid_move(Board, Player,  ['left', N], NewBoard) :- 
	
	N>0, N<8,
	get_line(N, Board, Line), possible_move(Line),
    remove_first_zero(Line, _line), insert_head_line(Player, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),!.
	
valid_move(Board, Player,  ['right', N], NewBoard) :- 
	
	N>0, N<8,
	get_line(N, Board, Line), possible_move(Line),
    remove_last_zero(Line, _line), insert_end_line(Player, _line, NLine),
    replace_nth(Board, N, NLine, NewBoard),!.

valid_move(Board, Player,  ['up', N], NewBoard) :- 
	
	N>0, N<8,
	transpose(Board, Trans_Board),
	valid_move(Trans_Board, Player, ['left',N], Trans_NewBoard),
	transpose(Trans_NewBoard,NewBoard),!.
	
valid_move(Board, Player, ['down', N], NewBoard) :- 
	
	N>0, N<8,
	transpose(Board, Trans_Board),
	valid_move(Trans_Board, Player, ['right',N], Trans_NewBoard),
	transpose(Trans_NewBoard,NewBoard),!.
	
valid_move(Board, Player, Move, 0).



valid_moves_make_list_aux(Board, Player, ['left', 8], ListOfMoves_0):-
	!,
	valid_moves_make_list_aux(Board, Player, ['right',1], ListOfMoves_0).

valid_moves_make_list_aux(Board, Player, ['right', 8], ListOfMoves_0):-
        !,
        valid_moves_make_list_aux(Board, Player, ['up',1], ListOfMoves_0).

valid_moves_make_list_aux(Board, Player, ['up', 8], ListOfMoves_0):-
        !,
        valid_moves_make_list_aux(Board, Player, ['down',1], ListOfMoves_0).

valid_moves_make_list_aux(Board, Player, ['down', 8], ListOfMoves_0):-
        !,
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

max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line):-
     Ind1 is Ind + 1, rate_adj(Player, Line, X),(
    (X > Value_tmp, 
    max_pieces_adj_aux(Board, Player, Position, Value, Ind, X, Ind1)); 
    (\+ ( X > Value_tmp), 
    max_pieces_adj_aux(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind1))).

max_pieces_adj_aux(Board, Player, Position, Value, Position, Value, 25):-  ! .

max_pieces_adj_aux(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind):-
    Ind<8, !, nth1(Ind, Board, Line), 
    max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line).

max_pieces_adj_aux(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind):-
    Ind < 15, !, N is (Ind - 7),length(Board, Tam), transpose(Board, Trans_Board),  nth1(N, Trans_Board, Line), 
    max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line).

max_pieces_adj_aux(Board, Player,  Position, Value, Position_tmp, Value_tmp, Ind):-
	Ind<18, !,C is Ind-14, get_diagonal(1,C,Board,[],Line),
	max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line).

max_pieces_adj_aux(Board, Player,  Position, Value, Position_tmp, Value_tmp, Ind):-
        Ind<20, !,L is Ind-16, get_diagonal(L,1,Board,[],Line),
        max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line).

max_pieces_adj_aux(Board, Player,  Position, Value, Position_tmp, Value_tmp, Ind):-
        Ind<23, !,C is Ind - 19,reverse(Board, RBoard), get_diagonal(1,C,RBoard,[],Line),
        max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line).

max_pieces_adj_aux(Board, Player,  Position, Value, Position_tmp, Value_tmp, Ind):-
        Ind<25, !,L is Ind-21,reverse(Board, RBoard), get_diagonal(L,1,RBoard,[],Line),
        max_pieces_adj_aux_main(Board, Player, Position, Value, Position_tmp, Value_tmp, Ind, Line).

max_pieces_adj(Board, Player, Position,  Value):-
        max_pieces_adj_aux(Board, Player, Position, Value, -1, -1000,1).





rate_adj_formula_count(Elem, [], N, Count, Sum, ElemJustAppeared):-
    N is Sum + Count^5.

rate_adj_formula_count(Elem, List, N, Count, Sum, ElemJustAppeared):-
    List=[X | L2],
    ElemJustAppeared = 0,
    X \= Elem,
    rate_adj_formula_count(Elem, L2, N, 0, Sum, 0).  

rate_adj_formula_count(Elem, List, N, Count, Sum, ElemJustAppeared):-
    List=[X | L2],
    ElemJustAppeared = 0,
    X = Elem,
    rate_adj_formula_count(Elem, L2, N, 1, Sum, 1).   

rate_adj_formula_count(Elem, List, N, Count, Sum, ElemJustAppeared):-
    List=[X | L2],
    ElemJustAppeared = 1,
    X \= Elem,
    Sum1 is Sum+Count^5,
    rate_adj_formula_count(Elem, L2, N, 0, Sum1, 0).

rate_adj_formula_count(Elem, List, N, Count, Sum, ElemJustAppeared):-
    List=[X | L2],
    ElemJustAppeared = 1,
    X = Elem,
    C1 is Count + 1,
    rate_adj_formula_count(Elem, L2, N, C1, Sum, 1).  


rate_adj_formula(Elem, List, N):-
        rate_adj_formula_count(Elem, List, N, 0, 0, 0).

value_formula_aux_main(Board, Player, Value, Count, Ind, Line):-
     Ind1 is Ind + 1, rate_adj_formula(Player, Line, X),
     NCount is Count+X,
    value_formula_aux(Board, Player, Value, NCount, Ind1).

value_formula_aux(Board, Player, Value,  Value, 25):- ! .

value_formula_aux(Board, Player, Value, Value_tmp, Ind):-
    Ind<8, !, nth1(Ind, Board, Line), 
    value_formula_aux_main(Board, Player, Value, Value_tmp, Ind, Line).

value_formula_aux(Board, Player, Value, Value_tmp, Ind):-
    Ind < 15, !, N is (Ind - 7), transpose(Board, Trans_Board),  nth1(N, Trans_Board, Line), 
    value_formula_aux_main(Board, Player, Value,  Value_tmp, Ind, Line).

value_formula_aux(Board, Player,  Value, Value_tmp, Ind):-
        Ind<18, !,C is Ind-14, get_diagonal(1,C,Board,[],Line),
        value_formula_aux_main(Board, Player,  Value,  Value_tmp, Ind, Line).

value_formula_aux(Board, Player,   Value, Value_tmp, Ind):-
        Ind<20, !,L is Ind-16, get_diagonal(L,1,Board,[],Line),
        value_formula_aux_main(Board, Player, Value,  Value_tmp, Ind, Line).

value_formula_aux(Board, Player,  Value, Value_tmp, Ind):-
        Ind<23, !,C is Ind - 19,reverse(Board, RBoard), get_diagonal(1,C,RBoard,[],Line),
        value_formula_aux_main(Board, Player,  Value,  Value_tmp, Ind, Line).

value_formula_aux(Board, Player, Value, Value_tmp, Ind):-
        Ind<25, !,L is Ind-21,reverse(Board, RBoard), get_diagonal(L,1,RBoard,[],Line),
        value_formula_aux_main(Board, Player,  Value,  Value_tmp, Ind, Line).

value_formula(Board, Player,  Value):-
        value_formula_aux(Board, Player, Value, 0, 1).

value(0, Player, -10^7):- ! .

value(Board, Player, Value):-
	max_pieces_adj(Board, Player, PositionPlayer, ValuePlayer),
	ValuePlayer >= 5, !,  Value is 10 ^ 6.

value(Board, Player, Value):-
	NPlayer is mod(Player,2) + 1, valid_moves(Board, NPlayer, ListOfMoves), length(ListOfMoves, Size), create_list(Nplayer, Size, ListPlayer), 
	map_redefined(max_pieces_adj, ListOfMoves, ListPlayer, Positions, Values),  max_list( Values, PositionNPlayer, ValueNPlayer), 
	ValueNPlayer>=5, !, Value is (0 - 10^6).

value(Board, Player, Value):-
        value_formula(Board, Player,  ValuePlayer), 
        NPlayer is mod(Player,2) + 1, valid_moves(Board, NPlayer, ListOfMoves), length(ListOfMoves, Size), create_list(Nplayer, Size, ListPlayer),
        map_redefined(value_formula, ListOfMoves, ListPlayer, Values), max_list( Values, PositionNPlayer, ValueNPlayer), 
        Value is ValuePlayer-ValueNPlayer.

cpu_move(Board, Player, Move):-
	valid_moves_make_list(Board, Player, ListOfMoves), length(ListOfMoves, Size), create_list(Player, Size, ListPlayer),
	map_redefined( value, ListOfMoves, ListPlayer, Values),write(Values), max_list(Values, PositionMove, ValueMove), write(PositionMove), write(' '),write(ValueMove),
	((ValueMove is (0 -10^7), Move='undefined') ;
	(ValueMove > (0 -10^7), convert_order_Move(PositionMove, Move))).
	
convert_order_Move(N, Move):-
		 N<8, !, 
		 Move=['left', N].	

convert_order_Move(N, Move):-
                 N<15, !,  N1 is N-7,
                 Move=['right', N1].        

convert_order_Move(N, Move):-
                 N<22, !,  N1 is N-14,
                 Move=['up', N1].  

convert_order_Move(N, Move):-
                 N<29, !,  N1 is N-21,
                 Move=['down', N1].  

%--------------------------------------------TESTS-----------------------------------------------------------------------------------
display_boards(ListOfBoards):-
        ListOfBoards=[0 | L2],
	write(' 0 '),nl,
	display_boards(L2).
	
display_boards(ListOfBoards):-
	ListOfBoards=[Board | L2],
	display_board(Board),
	display_boards(L2).

display_boards([]).

%valid_moves test
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

%max_pieces_adj_aux test
test4:-
	max_pieces_adj([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,1,1,0]],1,P, V),
        write(P), write('  '), write(V).

test5:-
        max_pieces_adj([[0,1,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,1,0,0,0,0,0],[0,1,0,0,0,0,0],[1,1,1,1,1,1,0]],1,P, V),
        write(P), write('  '), write(V).

test6:-
        max_pieces_adj([[0,0,0,0,0,0,0],[1,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0]],1,P, V),
        write(P), write('  '), write(V).
test7:-
        max_pieces_adj([[0,0,0,0,0,1,0],[0,0,0,0,1,0,0],[0,0,0,1,0,0,0],[0,0,1,0,0,0,0],[0,1,0,0,0,0,0],[1,0,0,0,0,0,0],[0,0,0,0,0,0,0]],1,P, V),
        write(P), write('  '), write(V).

%value_formula
test8:-
        value_formula([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,1,1,0]],1, V),
        write(V).

test9:-
        value_formula([[0,1,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,1,0,0,0,0,0],[0,1,0,0,0,0,0],[1,1,1,1,1,1,0]],1, V),
        write(V).

test10:-
        value_formula([[0,0,0,0,0,0,0],[1,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0]],1, V),
        write(V).
test11:-
        value_formula([[0,0,0,0,0,1,0],[0,0,0,0,1,0,0],[0,0,0,1,0,0,0],[0,0,1,0,0,0,0],[0,1,0,0,0,0,0],[1,0,0,0,0,0,0],[0,0,0,0,0,0,0]],1, V),
        write(V).
test12:-
	value_formula([[0,0,0,0,0,0,1],[0,0,0,0,0,1,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,1,0,0,0,0,0],[1,0,0,0,0,0,0]],1, V),
        write(V).

test13:-
	value_formula([[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[2,0,0,0,0,0,0]],1, V),
        write(V).

%value
test14:-
        value([[2,0,0,0,0,0,0],[0,2,0,0,0,0,0],[0,0,2,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,1,0]],2, V),
        write(V).
test15:-
	value([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[2,2,0,2,2,1,0]],1, V),
        write(V).

test16:-
        value([[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[2,0,0,0,0,0,0]],1, V),
        write(V).

test17:-
	display_board([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,2,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,2,0],[1,1,1,1,0,0,2]]),
	value([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,2,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,2,0],[1,1,1,1,0,0,2]],2, V),
        write(V).

%cpu_move 
test18:-
	display_board([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[2,2,0,2,2,1,0]]),
	cpu_move([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[2,2,0,2,2,1,0]],2, Move),
        write(Move).

test192:-
	display_board([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,1,0,0,0,0,0],[1,2,1,1,0,0,0]]),
        value([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,1,0,0,0,0,0],[1,2,1,1,0,0,0]],2, V),
        write(V).

test19:-
        display_board([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,0,0,0]]),
        cpu_move([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,1,1,1,0,0,0]],2, Move),
        write(Move).

test20:-
        display_board([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,2,0],[1,1,1,1,0,0,2]]),
        cpu_move([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,2,0],[1,1,1,1,0,0,2]],2, Move),
        write(Move).

test21:-
        display_board([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,2,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,2,0],[1,1,1,1,0,0,0]]),
        cpu_move([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,2,0,0,0,0],[0,0,0,2,0,0,0],[0,0,0,0,2,0,0],[0,0,0,0,0,2,0],[1,1,1,1,0,0,0]],2, Move),
        write(Move).

summ(A,B,C,D):-
	D is A+B+C.  
	