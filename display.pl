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
1 |0 0 0 0 0 0 0|
2 |0 0 0 0 0 0 0|
3 |0 0 0 0 0 0 0|
4 |0 0 0 0 0 0 0|
5 |0 0 0 0 0 0 0|
6 |0 0 0 0 0 0 0|
7 |0 0 0 0 0 0 0|
  +-------------+
*/