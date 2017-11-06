:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('check_win.pl').


%--------------------- Loop geral do jogo --------------------%
%menu principal
%ler input do utilizador
%comecar jogo (pessoa vs pessoa, pessoa vs pc, pc vs pc)
%TODO loop do jogo
%TODO voltar ao menu principal



shiftago:-
    display_main_menu,get_integer('Please choose an option: ', 0, 3, GameOption), menu_option(GameOption).

menu_option(0).
menu_option(1):- init(Board, PlayerOnePieces, PlayerTwoPieces), player_vs_player(Board, PlayerOnePieces, PlayerTwoPieces, 1).
menu_option(2):- player_vs_cpu.
menu_option(3):- cpu_vs_cpu.


init([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]], 22, 22).

switch_player(1,2).
switch_player(2,1).


%---------------------- Player vs Player ---------------------%

player_vs_player(Board, CurrentPieces, OpponentPieces, CurrentPlayer):-
    display_board(Board),
    write('Player '), write(CurrentPlayer), write(', it\'s your turn. You have '), write(CurrentPieces), write(' pieces left.'), nl,
    insert_piece(Board, CurrentPlayer, NewBoard, CurrentPieces, OpponentPieces, NewCurrentPieces),
    end_move(CurrentPlayer, NewBoard, OpponentPieces, NewCurrentPieces, NewPlayer).

end_move(CurrentPlayer, NewBoard, OpponentPieces, NewCurrentPieces, NewPlayer):-
    check_for_win(CurrentPlayer, NewBoard),
    end_game(CurrentPlayer).

end_move(CurrentPlayer, NewBoard, OpponentPieces, NewCurrentPieces, NewPlayer):-
    switch_player(CurrentPlayer, NewPlayer),
    player_vs_player(NewBoard, OpponentPieces, NewCurrentPieces, NewPlayer).

end_game(Player):-
    write("Game over, winner is "), write(Player), write("!"), nl.


%----------------------- Player vs CPU -----------------------%
player_vs_cpu.%TODO

%------------------------- CPU vs CPU ------------------------%
cpu_vs_cpu.%TODO