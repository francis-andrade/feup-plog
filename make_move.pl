%--------------------- Jogadas --------------------%

possible_move(Line):-
    member(0, Line).

insert_head_line(Player,Line,NLine):-
    remove_first_zero(Line,_temp), append([Player],_temp,NLine).

insert_end_line(Player,Line,NLine):-
    remove_last_zero(Line,_temp), append(_temp,[Player],NLine).

%TODO remove_first_zero(Line, NLine) e remove_last_zero(Line, NLine) (o cut deve ajudar)