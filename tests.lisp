;;; tests.lisp
;;; Testes simples para agenda.lisp.
;;;
;;; Para executar:
;;;   sbcl --script tests.lisp

(load "agenda.lisp")

(defvar *falhas* 0)

(defun verificar-igual (descricao esperado obtido)
  (if (equal esperado obtido)
      (format t "[OK] ~A~%" descricao)
      (progn
        (incf *falhas*)
        (format t "[FALHA] ~A~%  Esperado: ~S~%  Obtido:   ~S~%"
                descricao esperado obtido))))

(defun executar-testes ()
  (let ((agenda nil))
    (verificar-igual "agenda inicia vazia" nil agenda)

    (setq agenda (incluir agenda '(Bel 32338778)))
    (verificar-igual "inclui primeiro contato"
                     '((Bel 32338778))
                     agenda)

    (setq agenda (incluir agenda '(Rose 32666556)))
    (setq agenda (incluir agenda '(Rose 991919191)))
    (setq agenda (incluir agenda '(Beto 32529119)))
    (verificar-igual "inclui contatos e telefone adicional"
                     '((Bel 32338778) (Rose 32666556 991919191) (Beto 32529119))
                     agenda)

    (verificar-igual "busca contato inexistente"
                     'INEXISTENTE
                     (Telefones agenda 'Jose))

    (verificar-igual "busca telefones da Rose"
                     '(32666556 991919191)
                     (Telefones agenda 'Rose))

    (setq agenda (excluir agenda '(Rose 991919191)))
    (verificar-igual "remove um telefone da Rose"
                     '(32666556)
                     (Telefones agenda 'Rose))

    (setq agenda (excluir agenda '(Rose 91919191)))
    (verificar-igual "ignora telefone inexistente"
                     '(32666556)
                     (Telefones agenda 'Rose))

    (setq agenda (excluir agenda '(Rose 32666556)))
    (verificar-igual "remove contato quando fica sem telefones"
                     'INEXISTENTE
                     (Telefones agenda 'Rose))

    (setq agenda (incluir agenda '(Bel 32338778)))
    (verificar-igual "nao duplica telefone ja existente"
                     '(32338778)
                     (Telefones agenda 'Bel)))

  (if (zerop *falhas*)
      (format t "~%Todos os testes passaram.~%")
      (progn
        (format t "~%Quantidade de falhas: ~D~%" *falhas*)
        (sb-ext:exit :code 1))))

(executar-testes)

