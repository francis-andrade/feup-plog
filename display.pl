%--------------------- Imprimir menu --------------------%
display_title:-
    write('      _     _  __ _'), nl,
    write('     | |   (_)/ _| |'), nl,
    write('  ___| |__  _| |_| |_ __ _  __ _  ___'), nl,
    write(' / __| \'_ \\| |  _| __/ _` |/ _` |/ _ \\'), nl,
    write(' \\__ \\ | | | | | | || (_| | (_| | (_) |'), nl,
    write(' |___/_| |_|_|_|  \\__\\__,_|\\__, |\\___/ '), nl,
    write('                            __/ |'), nl,
    write('                           |___/'), nl.

display_options:-
    write('+------------------------------------+'), nl,
    write('  1. Player vs Player'), nl,
    write('  2. Player vs COM'), nl,
    write('  3. COM vs COM'), nl,
    write('  0. Exit'), nl.

display_main_menu:-
    display_title, nl, display_options, nl.


get_input(Input):-
    get_char(Ch), get_all_chars(Ch, CharacterList), name(Input, [Ch|CharacterList]).

get_all_chars(10,[]).
get_all_chars(13,[]).
get_all_chars(Ch, [Ch|MoreChars]):-
    get_char(NChar),
    get_all_chars(NChar, MoreChars).

get_integer(Prompt, Int):-
    repeat,
    write(Prompt),
    once(get_input(Int)),
    number(Int).

%------------------ Imprimir tabuleiro ------------------%
display_matrix(8, []).
display_matrix(N, [L|T]) :- 
    N1 is N+1, N =< 7, 
    display_line(L, N), 
    display_matrix(N1, T).

%imprime a linha
display_line(L, N):-
    write(N), put_char(' '), 
    put_char('|'), display_line(L).

translate_char(0,'.').
translate_char(1,'X').
translate_char(2,'O').

%ultimo elemento da linha
display_line([X]) :- translate_char(X,N), write(N), write('|'), put_code(10). 
display_line([X|R]) :- translate_char(X,N), write(N), write(' '), display_line(R).

display_top :- write('   1 2 3 4 5 6 7'), put_code(10).
display_edge :- write('  +-------------+'), put_code(10).

display_board(X):- display_top, display_edge, display_matrix(1, X), display_edge.








/*
   1 2 3 4 5 6 7
  +-------------+
1 |. . O . X . .|
2 |. . . O X X O|
3 |. . . . O . .|
4 |. . . . X O X|
5 |. . . . . . O|
6 |X X . . . . .|
7 |. . . . O . .|
  +-------------+
*/