:-use_module(library(lists)).
:-include('user_interface.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('end_move.pl').
:-include('cpu.pl').


%--------------------- Loop geral do jogo --------------------%
%main game function
shiftago:-
    display_main_menu,
    get_integer('Please choose an option: ', 0, 3, GameOption),
    menu_option(GameOption).

%exits game
menu_option(0).

%starts player vs player
menu_option(1):- assert(game_mode(1)),
    init(Board, PlayerOnePieces, PlayerTwoPieces),
    player_vs_player(Board, PlayerOnePieces, PlayerTwoPieces, 1).

%starts player vs ai
menu_option(2):- assert(game_mode(2)), player_vs_cpu.

%starts ai vs ai
menu_option(3):- assert(game_mode(2)), cpu_vs_cpu.

%creates a blank board
init([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]], 22, 22).

%switches the two players
switch_player(1,2).
switch_player(2,1).

%checks if the player wants to leave the game
return_to_main_menu(no).
return_to_main_menu(yes):-
    shiftago.


%---------------------- Player vs Player ---------------------%

%shows the board, asks for the pieces, makes the move and then ends the current
player_vs_player(Board, CurrentPieces, OpponentPieces, CurrentPlayer):-
    display_board(Board),
    write_pieces(CurrentPlayer, CurrentPieces),
    insert_piece(Board, CurrentPlayer, NewBoard, CurrentPieces, NewCurrentPieces),
    end_move(CurrentPlayer, NewBoard, OpponentPieces, NewCurrentPieces).

%writes the number of pieces
write_pieces(Player, 1):-
    write('Player '), write(Player),
    write(', it\'s your turn. You only have one piece left, make it count!'), nl.

write_pieces(Player, Pieces):-
    write('Player '), write(Player),
    write(', it\'s your turn. You have '),
    write(Pieces), write(' pieces left.'), nl.

%----------------------- Player vs CPU -----------------------%
player_vs_cpu(Board, CurrentPieces, OpponentPieces, CurrentPlayer, CPUPlayer):-
    CurrentPlayer=CPUPlayer, !,
    display_board(Board),
    cpu_move(Board, CurrentPlayer, Move, NewBoard, CurrentPieces, NewCurrentPieces),
    end_move(CurrentPlayer, NewBoard, OpponentPieces, NewCurrentPieces).


%------------------------- CPU vs CPU ------------------------%
cpu_vs_cpu.%TODO