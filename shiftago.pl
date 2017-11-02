:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('check_win.pl').



%--------------------- Loop do jogo --------------------%
%menu principal
%ler input do utilizador
%comecar jogo (pessoa vs pessoa, pessoa vs pc, pc vs pc)
%TODO loop do jogo
%TODO voltar ao menu principal



shiftago:-
    display_main_menu,get_integer('Please choose an option: ', 0, 3, GameOption), menu_option(GameOption).

menu_option(0).
menu_option(1):- player_vs_player.
menu_optiom(2):- player_vs_cpu.
menu_option(3):- cpu_vs_cpu.


init([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]], 22, 22).
player_vs_player:-
    init(Board),
    display_board(Board, PlayerOnePieces, PlayerTwoPieces),
    insert_piece(Board,Edge,N,1,NewBoardOut,PlayerOnePieces, PlayerTwoPieces).

player_vs_cpu.%TODO
cpu_vs_cpu.%TODO
