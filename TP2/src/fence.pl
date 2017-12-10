fence:-
    get_arguments(Lg,Wd),
    generate_puzzle(Lg, Wd, L),
    display_puzzle(L),
    solve(L),
    display_puzzle(L).

