(module
  (def foo (import "foo"))
  (def bar (import "bar/bar"))

  (export foofoo (fun () (foo) )) ;; returns 27
  (export barbar (fun (x) (bar.bar (bar.QUX x)) )) ;; x * x
  (export barbaz (fun (x y) (bar.baz x y) )) ;; x * y
)
