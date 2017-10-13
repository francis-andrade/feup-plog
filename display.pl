Display_matrix(8, []).
Display_matrix(N, [L|T]) :- 
    N1 is N+1, N <= 7, 
    Display_line(L, N), 
    Display_matrix(N1, T).

%imprime a linha
Display_line(L, N):-
    put_char(N), put_char(' '), 
    put_char('|'), Display_line(L).

%ultimo elemento da linha
Display_line([X]) :- put_char(X), put_char('|'), put_code(10). 
Display_line([X|R]) :- put_char(X), put_char(' '), Display_line(R).

Display_top() :- write ('   1 2 3 4 5 6 7'), put_code(10).
Display_edge() :- write('  +-------------+'), put_code(10).

Display_board(X):- Display_top(), Display_edge(), Display_matrix(1, X), Display_edge().

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