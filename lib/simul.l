# 15jul10abu
# (c) Software Lab. Alexander Burger

(de permute (Lst)
   (ifn (cdr Lst)
      (cons Lst)
      (mapcan
         '((X)
            (mapcar
               '((Y) (cons X Y))
               (permute (delete X Lst)) ) )
         Lst ) ) )

(de subsets (N Lst)
   (cond
      ((=0 N) '(NIL))
      ((not Lst))
      (T
         (append
            (mapcar
               '((X) (cons (car Lst) X))
               (subsets (dec N) (cdr Lst)) )
            (subsets N (cdr Lst)) ) ) ) )

(de shuffle (Lst)
   (by '(NIL (rand)) sort Lst) )

(de samples (Cnt Lst)
   (make
      (until (=0 Cnt)
         (when (>= Cnt (rand 1 (length Lst)))
            (link (car Lst))
            (dec 'Cnt) )
         (pop 'Lst) ) ) )


# Genetic Algorithm
(de gen ("Pop" "Cond" "Re" "Mu" "Se")
   (until ("Cond" "Pop")
      (for ("P" "Pop" "P" (cdr "P"))
         (set "P"
            (maxi "Se"  # Selection
               (make
                  (for ("P" "Pop" "P")
                     (rot "P" (rand 1 (length "P")))
                     (link  # Recombination + Mutation
                        ("Mu" ("Re" (pop '"P") (pop '"P"))) ) ) ) ) ) ) )
   (maxi "Se" "Pop") )


# Alpha-Beta tree search
(de game ("Flg" "Cnt" "Moves" "Move" "Cost")
   (let ("Alpha" '(1000000)  "Beta" -1000000)
      (recur ("Flg" "Cnt" "Alpha" "Beta")
         (if (=0 (dec '"Cnt"))
            (let? "Lst" ("Moves" "Flg")
               (loop
                  ("Move" (caar "Lst"))
                  (setq "*Val" (list ("Cost" "Flg") (car "Lst")))
                  ("Move" (cdar "Lst"))
                  (T (>= "Beta" (car "*Val"))
                     (cons "Beta" (car "Lst") (cdr "Alpha")) )
                  (when (> (car "Alpha") (car "*Val"))
                     (setq "Alpha" "*Val") )
                  (NIL (setq "Lst" (cdr "Lst")) "Alpha") ) )
            (let? "Lst"
               (sort
                  (mapcar
                     '(("Mov")
                        (prog2
                           ("Move" (car "Mov"))
                           (cons ("Cost" "Flg") "Mov")
                           ("Move" (cdr "Mov")) ) )
                     ("Moves" "Flg") ) )
               (loop
                  ("Move" (cadar "Lst"))
                  (setq "*Val"
                     (if (recurse (not "Flg") "Cnt" (cons (- "Beta")) (- (car "Alpha")))
                        (cons (- (car @)) (cdar "Lst") (cdr @))
                        (list (caar "Lst") (cdar "Lst")) ) )
                  ("Move" (cddar "Lst"))
                  (T (>= "Beta" (car "*Val"))
                     (cons "Beta" (cdar "Lst") (cdr "Alpha")) )
                  (when (> (car "Alpha") (car "*Val"))
                     (setq "Alpha" "*Val") )
                  (NIL (setq "Lst" (cdr "Lst")) "Alpha") ) ) ) ) ) )


### Grids ###
(de grid (DX DY)
   (prog1
      (make
         (for X DX
            (link
               (make
                  (for Y DY
                     (link
                        (def
                           (if (> DX 26)
                              (box)
                              (intern (pack (char (+ X 96)) Y)) )
                           (cons (cons) (cons)) ) ) ) ) ) ) )
      (let (Lst @  West)
         (while Lst
            (let (East (cadr Lst)  South)
               (for (L (car Lst) (pop 'L))
                  (with @
                     (and (pop 'West) (set (: 0 1) @))  # west
                     (and (pop 'East) (con (: 0 1) @))  # east
                     (and South (set (: 0 -1) @))       # south
                     (and (car L) (con (: 0 -1) @))     # north
                     (setq South This) ) ) )
            (setq West (pop 'Lst)) ) ) ) )

(de west (This)
   (: 0 1 1) )

(de east (This)
   (: 0 1 -1) )

(de south (This)
   (: 0 -1 1) )

(de north (This)
   (: 0 -1 -1) )

(de disp ("Grid" "How" "Fun" "X" "Y" "DX" "DY")
   (setq "Grid"
      (if "X"
         (mapcar
            '((L) (flip (head "DY" (nth L "Y"))))
            (head "DX" (nth "Grid" "X")) )
         (mapcar reverse "Grid") ) )
   (let (N (+ (length (cdar "Grid")) (or "Y" 1))  Sp (length N))
      ("border" north)
      (while (caar "Grid")
         (prin " " (align Sp N) " "
            (and "How" (if (and (nT "How") (west (caar "Grid"))) " " '|)) )
         (for L "Grid"
            (prin
               ("Fun" (car L))
               (and "How" (if (and (nT "How") (east (car L))) " " '|)) ) )
         (prinl)
         ("border" south)
         (map pop "Grid")
         (dec 'N) )
      (unless (> (default "X" 1) 26)
         (space (inc Sp))
         (for @ "Grid"
            (prin " " (and "How" "  ") (char (+ 96 "X")))
            (T (> (inc '"X") 26)) )
         (prinl) ) ) )

(de "border" (Dir)
   (when "How"
      (space Sp)
      (prin "  +")
      (for L "Grid"
         (prin (if (and (nT "How") (Dir (car L))) "   +" "---+")) )
      (prinl) ) )
