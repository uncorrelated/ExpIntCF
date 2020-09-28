" ported to Smalltalk by @sumim "
" http://ws.stfx.eu/C53MJMOP8D5U "
" workplace/playgroudに以下をコピペして動作を確認 "

| E1cf2 E1cf MakeMatrix ms length m |

Metacello new
     smalltalkhubUser: 'Pharo' project: 'MetaRepoForPharo70';
     configuration: 'Complex';
     load.

E1cf2 := [:z :n |
     | cf |
     cf := z.
     n to: 1 by: -1 do: [:i |
          cf := z + ((1 + i) / cf).
          cf := 1 + (i / cf).
     ].
     z negated exp / (z + (1 / cf))
].

E1cf := [:z :reltol |
     | d | " | n0 |"
     [:exit |
          1 to: 1000 do: [:n |
               | s | " | s d | "
               s := E1cf2 value: z value: n.
               d := E1cf2 value: z value: 2 * n.
               (s - d) abs <= (d abs * reltol) ifTrue: [
                    "n0 := n." exit value
               ]
          ].
          ^self notify: 'iteration limit exceeded!'
     ] valueWithExit.
     d " n0"
].

MakeMatrix := [:s :e :len |
     Array2D new: len tabulate: [:j :i |
          | x y |
          x := s + ((e - s) / (len - 1) * (i - 1)).
          y := s + ((e - s) / (len - 1) * (j - 1)).
          E1cf value: x + y i value: 1e-12
     ]
].

length := 100.

"make a matrix, and save it."
Transcript open; clear.
ms := [m := MakeMatrix value: 0.1 value: 5 value: length] timeToRun asMilliSeconds..
Transcript cr; show: 'elapsed time: ', (ms / 1.0e3) printString, ' seconds'.

"save the matrix."
StandardFileStream forceNewFileNamed:  'e1_cf.st.txt' do: [:stream |
     1 to: length do: [:j |
          stream cr.
          1 to: length do: [:i |
               (m at: i at: j) real printOn: stream showingDecimalPlaces: 6.
               stream nextPut: $+.
               (m at: i at: j) imaginary printOn: stream showingDecimalPlaces: 6.
               stream nextPutAll: 'im'; tab
               "stream nextPutAll: ((m at: i at: j) printPaddedWith: $  to: 6); tab"
          ]
     ].
     "Transcript cr; show: stream contents"
]
