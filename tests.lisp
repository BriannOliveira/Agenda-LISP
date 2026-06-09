;;; tests.lisp
;;; Testes simples para agenda.lisp.
;;;
;;; Para executar:
;;; sbcl --script tests.lisp

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
                     (Telefones agenda 'Bel))

    ;; --- NOVOS TESTES AVANÇADOS ---

    (let ((agenda-vazia nil))
      (verificar-igual "busca em agenda totalmente vazia"
                       'INEXISTENTE
                       (Telefones agenda-vazia 'Qualquer))
      
      (verificar-igual "exclui contato de agenda vazia"
                       nil
                       (excluir agenda-vazia '(Rose 123456))))

    (setq agenda (incluir agenda '(Carlos 1111)))
    (setq agenda (incluir agenda '(Carlos 2222)))
    (setq agenda (incluir agenda '(Carlos 3333)))
    (setq agenda (excluir agenda '(Carlos 2222)))
    (verificar-igual "remove um telefone do meio da lista"
                     '(1111 3333)
                     (Telefones agenda 'Carlos))

    (setq agenda (incluir agenda '(Carlos 3333)))
    (setq agenda (incluir agenda '(Carlos 3333)))
    (verificar-igual "tenta adicionar o mesmo telefone multiplas vezes"
                     '(1111 3333)
                     (Telefones agenda 'Carlos))

    (setq agenda (incluir agenda '(ALICE 9999)))
    (verificar-igual "busca contato testando case sensitivity do Lisp"
                     '(9999)
                     (Telefones agenda 'Alice))) ; O escopo da variável 'agenda' fecha aqui

  ;; Verificação final de falhas, agora fora do escopo do 'let' mas dentro da função
  (if (zerop *falhas*)
      (format t "~%Todos os testes passaram.~%")
      (progn
        (format t "~%Quantidade de falhas: ~D~%" *falhas*)
        (sb-ext:exit :code 1))))

(executar-testes)