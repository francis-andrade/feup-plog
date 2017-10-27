:-use_module(library(lists)).
:-include('display.pl').

%TODO arranjar isto
sublist(L1,L):- append(L1,_,L).
sublist(L1,L):- append(_,L1,L).
sublist(L1,L):- append([_x|L1],_y,L).

init([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]]).

get_line(N, Board, Line):-
    nth1(N, Board, Line).

possible_move(Line):-
    member(0, Line).

%%%%%%%%%%%%%%%%%%%%%%%  JOGADAS  %%%%%%%%%%%%%%%%%%%%%%%%



%%%%% ---------------------------------------------- %%%%%



%%%%%%%%%%%%%%  VERIFICACAO DE FIM DE JOGO  %%%%%%%%%%%%%%%

check_for_win(Player, Board):- check_lines(Player,Board).
check_for_win(Player, Board):- check_colums(Player, Board).
check_for_win(Player, Board):- check_diagonals(Player, Board).

check_lines(Player, [X|Rest]):- sublist([Player,Player,Player,Player,Player], X).
check_lines(Player, [_|Rest]):- check_lines(Player, Rest).

check_colums(Player, Board):- transpose(Board, TBoard), check_lines(Player, TBoard).

check_diagonals(Player,Board) :- get_diagonal(1,1,Board,[],Line), check_lines(Player,[Line]).
check_diagonals(Player,Board) :- get_diagonal(1,2,Board,[],Line), check_lines(Player,[Line]).
check_diagonals(Player,Board) :- get_diagonal(1,3,Board,[],Line), check_lines(Player,[Line]).
check_diagonals(Player,Board) :- get_diagonal(2,1,Board,[],Line), check_lines(Player,[Line]).
check_diagonals(Player,Board) :- get_diagonal(3,1,Board,[],Line), check_lines(Player,[Line]).

get_diagonal(8,_,Board, Line, Line).
get_diagonal(_,8,Board, Line, Line).
get_diagonal(L,C,Board, Line, FLine):-
    L < 8, C < 8, L1 is L+1, C1 is C+1,
    get_line(L, Board, _tmp), nth1(C, _tmp, _value),
    append(Line, [_value], NLine),
    get_diagonal(L1,C1,Board,NLine, FLine).

%%%%% ----------------------------------------------- %%%%%