.PHONY: test repl

test:
	sbcl --script tests.lisp

repl:
	sbcl --load agenda.lisp

