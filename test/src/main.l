# 07dec10abu
# (c) Software Lab. Alexander Burger

### alarm ###
(let N 6
   (alarm 1 (inc 'N))
   (test 6 N)
   (wait 2000)
   (test 7 N)
   (alarm 0) )


### sigio ###
(off "SigVal")
(sigio (setq "SigSock" (port T 4444))
   (setq "SigVal" (udp "SigSock")) )
(test '((setq "SigVal" (udp "SigSock"))) (sigio))
(udp "localhost" 4444 '(a b c))
(wait 200)
(test '(a b c) "SigVal")
(sigio "SigSock")
(test NIL (sigio))


### protect ###
(test NIL (pipe (prog (kill *Pid) (pr 7)) (rd)))
(test 7 (pipe (protect (kill *Pid) (pr 7)) (rd)))


### quit ###
(test "Quit" (catch '("Quit") (quit "Quit")))


### adr ###
(let (X (box 7)  L (123))
   (test 7 (val (adr (adr X))))
   (test 123 (car (adr (adr L)))) )

### env ###
(test NIL (env))
(test '((A . 1) (B . 2))
   (let (A 1 B 2)
      (env) ) )
(test '((B . 2) (A . 1))
   (let (A 1 B 2)
      (env '(A B)) ) )
(test '((Y . 8) (C . 3) (B . 2) (A . 1) (X . 7))
   (let (A 1 B 2)
      (env 'X 7 '(A B (C . 3)) 'Y 8) ) )


### up ###
(test 1
   (let N 1
      ((quote (N) (up N)) 2) ) )
(test 7
   (let N 1
      ((quote (N) (up N 7)) 2)
      N ) )


### args next arg rest ####
(test '(T 1 1 3 (2 3 4))
   (let foo '(@ (list (args) (next) (arg) (arg 2) (rest)))
      (foo 1 2 3 4) ) )

(test (7 7 NIL NIL)
   ((quote @ (list (next) (arg) (next) (arg))) 7) )


### usec ###
(let U (usec)
   (wait 400)
   (test 4 (*/ (- (usec) U) 100000)) )


### pwd ###
(test (path '@) (pack (pwd) '/))


### cd ###
(cd "test")
(test (path "@test") (pwd))
(cd "..")


### info ###
(test '(T . @) (info "test"))
(test (5 . @)
   (out (tmp "info") (prinl "info"))
   (info (tmp "info")) )


### file ###
(test (cons (tmp) "file" 1)
   (out (tmp "file") (println '(file)))
   (load (tmp "file")) )


### dir ###
(call 'mkdir "-p" (tmp "dir"))
(out (tmp "dir/.abc"))
(out (tmp "dir/a"))
(out (tmp "dir/b"))
(out (tmp "dir/c"))

(test '("a" "b" "c") (sort (dir (tmp "dir"))))
(test '("." ".." ".abc" "a" "b" "c") (sort (dir (tmp "dir") T)))


### cmd ###
(cmd "test")
(test "test" (cmd))


### argv ###
(test '("abc" "123")
   (pipe
      (call "bin/picolisp" "-prog (println (argv)) (bye)" "abc" 123)
      (read) ) )
(test '("abc" "123")
   (pipe
      (call "bin/picolisp" "-prog (argv A B) (println (list A B)) (bye)" "abc" 123)
      (read) ) )


### opt ###
(test '("abc" "123")
   (pipe
      (call "bin/picolisp" "-prog (println (list (opt) (opt))) (bye)" "abc" 123)
      (read) ) )
(test "abc"
   (pipe
      (call "bin/picolisp" "-de f () (println (opt))" "-f" "abc" "-bye")
      (read) ) )


### date time ###
(use (Dat1 Tim1 Dat2 Tim2 D1 T1 D2 T2)
   (until
      (=
         (setq Dat1 (date)  Tim1 (time T))
         (prog
            (setq
               Dat2 (date T)
               Tim2 (time T)
               D1 (in '(date "+%Y %m %d") (list (read) (read) (read)))
               T1 (in '(date "+%H %M %S") (list (read) (read) (read)))
               D2 (in '(date "-u" "+%Y %m %d") (list (read) (read) (read)))
               T2 (in '(date "-u" "+%H %M %S") (list (read) (read) (read))) )
            (time) ) ) )
   (test Tim1 (time T1))
   (test Tim1 (apply time T1))
   (test Tim2 (time T2))
   (test Dat1 (date D1))
   (test Dat1 (apply date D1))
   (test Dat2 (date D2)) )

(test (2000 7 15) (date 730622))
(test 730622 (date 2000 7 15))
(test 730622 (date (2000 7 15)))
(test NIL (date NIL))

(test (11 17 23) (time 40643))
(test 40643 (time 11 17 23))
(test 40643 (time (11 17 23)))
(test NIL (time NIL))

# vi:et:ts=3:sw=3