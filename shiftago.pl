:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('make_move.pl').
:-include('check_win.pl').



%--------------------- Loop do jogo --------------------%
%menu principal
%ler input do utilizador
%comecar jogo (pessoa vs pessoa, pessoa vs pc, pc vs pc)
%loop do jogo
%voltar ao menu principal



shiftago:-
    display_main_menu,get_integer('Please choose an option: ', 0, 3, GameOption), menu_option(GameOption).

menu_option(0).
menu_option(1):- player_vs_player.
menu_optiom(2):- player_vs_cpu.
menu_option(3):- cpu_vs_cpu.

player_vs_player:-write('chose pvp'), nl.
player_vs_cpu:-write('chose pvc'), nl.
cpu_vs_cpu:-write('chose cvc'), nl.

init([[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]]).

