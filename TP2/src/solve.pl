solve(L):-
    Lines #= [
        [L1C1, L1C2, L1C3, L1C4, L1C5, L1C6],
        [L2C1, L2C2, L2C3, L2C4, L2C5, L2C6],
        [L3C1, L3C2, L3C3, L3C4, L3C5, L3C6],
        [L4C1, L4C2, L4C3, L4C4, L4C5, L4C6],
        [L5C1, L5C2, L5C3, L5C4, L5C5, L5C6],
        [L6C1, L6C2, L6C3, L6C4, L6C5, L6C6],
        [L7C1, L7C2, L7C3, L7C4, L7C5, L7C6]
    ],

    Columns #=[
        [C1L1, C2L1, C3L1, C4L1, C5L1, C6L1, C7L1],
        [C1L2, C2L2, C3L2, C4L2, C5L2, C6L2, C7L2],
        [C1L3, C2L3, C3L3, C4L3, C5L3, C6L3, C7L3],
        [C1L4, C2L4, C3L4, C4L4, C5L4, C6L4, C7L4],
        [C1L5, C2L5, C3L5, C4L5, C5L5, C6L5, C7L5],
        [C1L6, C2L6, C3L6, C4L6, C5L6, C6L6, C7L6]
    ],

    Grid #=[
        [0, 0, -1, 1, -1, 1],
        [-1, -1, -1, -1, -1, 1],
        [3, -1, 1, -1, -1, -1],
        [-1, -1, -1, 3, -1, 1],
        [3, -1, -1, -1, -1, -1],
        [3, -1, 3, -1, 1, 2]
    ],

    domain(Lines, 0, 1),
    domain(Columns, 0, 1),
    labeling([], Lines).

    %todo
adjacent_line(Line, Before, After).
adjacent_column(Column, Before, After).
