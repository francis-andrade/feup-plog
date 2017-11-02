:-use_module(library(lists)).


/*
replace_nth(List, N, Elem, NList):-
    replace_nth(List, N, Elem, NList, []).

replace_nth([X|Rest], N, Elem, [Y|NRest], Head):-
    N > 1, N1 is N-1, append(Head, [X], NHead replace_nth(Rest, N1, Elem, NRest, ).  */