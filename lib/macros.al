(module

  ;; operations on a list
  (def unroll {mac R (l v each) {block
    (def value (head l))
    (def rest (tail l))
    (def iter [list &block [list &def v value] each])

    [if
      (is_empty rest)
      iter
      &(block
        iter
        (R rest v each))
    ]
  }})

  (def defun (fun (name args body) {
    ^(def name (fun name args body))
  })

  ;; each on l until one fails
  ;; AND is similar to EVERY, evaluates until something fails.
  (def unroll_and {mac R (l v each) {block
    (def value (head l))
    (def rest (tail l))
    (def iter [list &block [list &def v value] each])
    [if
      (is_empty rest)
      iter
      &(block
        (def q iter)
        (if q (R rest v each))
      )
    ]
  }})

  ;; run each on each item in l until one passes
  ;; OR is similar to FIND. evaluates until something matches.
  (def unroll_or {mac R (l v each) {block
    (def value (head l))
    (def rest (tail l))
    (def iter [list &block [list &def v value] each])
;;    (def iter (mac () &[block [list &def v value] each]))
    [if
      (is_empty rest)
      iter
      &(block
        (def q iter)
        (if q q (R rest v each))
      )
    ]
  }})


  (export main (fun (n) [block
    (def sum 0)
;;    {unroll [1 2 3 4 5] i (def sum (add sum (mul i n))) }
;;    {unroll_and [1 3 4 0 6 7] i (def sum (add sum i))}
    {unroll_or [1 3 4 0 6 7] i (block (def sum (add sum i)) (eq i 0))}
    sum
  ]))
)