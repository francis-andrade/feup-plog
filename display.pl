Display_matrix([]).
Display_matrix([L|T]) :- Display_line(L), Display_matrix(T).