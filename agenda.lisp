;;; agenda.lisp
;;; Implementacao de uma agenda telefonica simples em Common Lisp.
;;;
;;; Esta versao usa recursos basicos de Lisp:
;;; car, cdr, cons, equal, atom, cond e recursao.
;;;
;;; Cada contato e representado como:
;;;   (Nome Telefone1 Telefone2 ...)
;;;
;;; Exemplos de uso:
;;;   (setq AGENDA nil)
;;;   (setq AGENDA (incluir AGENDA '(Bel 32338778)))
;;;   (setq AGENDA (incluir AGENDA '(Rose 32666556)))
;;;   (Telefones AGENDA 'Rose)

(defparameter AGENDA nil
  "Variavel global usada nos testes interativos do trabalho.")

(defun mesmo-nome-p (registro nome)
  "Verifica se REGISTRO pertence ao contato chamado NOME."
  (equal (car registro) nome))

(defun nome-do-contato (contato)
  "Retorna o nome recebido em uma entrada do tipo (Nome Telefone)."
  (car contato))

(defun telefone-do-contato (contato)
  "Retorna o telefone recebido em uma entrada do tipo (Nome Telefone)."
  (car (cdr contato)))

(defun telefone-existe-p (telefones telefone)
  "Verifica recursivamente se TELEFONE existe na lista TELEFONES."
  (cond
    ((atom telefones)
     nil)
    ((equal (car telefones) telefone)
     t)
    (t
     (telefone-existe-p (cdr telefones) telefone))))

(defun adicionar-no-fim (lista elemento)
  "Cria uma nova LISTA com ELEMENTO no final."
  (cond
    ((atom lista)
     (cons elemento nil))
    (t
     (cons (car lista)
           (adicionar-no-fim (cdr lista) elemento)))))

(defun adicionar-telefone-no-registro (registro telefone)
  "Adiciona TELEFONE ao REGISTRO, evitando telefones repetidos."
  (cond
    ((telefone-existe-p (cdr registro) telefone)
     registro)
    (t
     (adicionar-no-fim registro telefone))))

(defun incluir-contato (agenda nome telefone)
  "Percorre a AGENDA recursivamente para incluir NOME e TELEFONE."
  (cond
    ((atom agenda)
     (cons (cons nome (cons telefone nil)) nil))
    ((mesmo-nome-p (car agenda) nome)
     (cons (adicionar-telefone-no-registro (car agenda) telefone)
           (cdr agenda)))
    (t
     (cons (car agenda)
           (incluir-contato (cdr agenda) nome telefone)))))

;;; (1) Inclusao do nome e do telefone de um novo contato na agenda.
;;;     Se o nome ja existir, apenas inclui o telefone.
(defun incluir (agenda contato)
  "Inclui CONTATO na AGENDA.

CONTATO deve estar no formato (Nome Telefone). Se o nome ainda nao existir,
um novo registro sera criado. Se o nome ja existir, o telefone sera adicionado
ao registro existente."
  (incluir-contato agenda
                   (nome-do-contato contato)
                   (telefone-do-contato contato)))

(defun remover-telefone-da-lista (telefones telefone)
  "Remove TELEFONE de uma lista de TELEFONES."
  (cond
    ((atom telefones)
     nil)
    ((equal (car telefones) telefone)
     (cdr telefones))
    (t
     (cons (car telefones)
           (remover-telefone-da-lista (cdr telefones) telefone)))))

(defun remover-telefone-do-registro (registro telefone)
  "Remove TELEFONE do REGISTRO e retorna o registro atualizado."
  (cons (car registro)
        (remover-telefone-da-lista (cdr registro) telefone)))

(defun registro-sem-telefones-p (registro)
  "Indica se o REGISTRO nao possui mais telefones."
  (atom (cdr registro)))

(defun excluir-contato (agenda nome telefone)
  "Percorre a AGENDA recursivamente para remover TELEFONE de NOME."
  (cond
    ((atom agenda)
     nil)
    ((mesmo-nome-p (car agenda) nome)
     ((lambda (registro-atualizado)
        (cond
          ((registro-sem-telefones-p registro-atualizado)
           (cdr agenda))
          (t
           (cons registro-atualizado (cdr agenda)))))
      (remover-telefone-do-registro (car agenda) telefone)))
    (t
     (cons (car agenda)
           (excluir-contato (cdr agenda) nome telefone)))))

;;; (2) Remocao de um telefone dado o nome do contato e o numero.
;;;     Se for o unico telefone daquele proprietario, exclui tambem o nome.
(defun excluir (agenda contato)
  "Remove o telefone de CONTATO da AGENDA.

CONTATO deve estar no formato (Nome Telefone). Caso o telefone removido seja
o unico telefone daquele nome, o proprietario tambem sera removido da agenda.
Se o nome ou telefone nao existir, a agenda sera retornada sem alteracoes."
  (excluir-contato agenda
                   (nome-do-contato contato)
                   (telefone-do-contato contato)))

;;; (3) Busca dos telefones de um contato dado o nome.
;;;     Retorna INEXISTENTE quando o contato nao esta na agenda.
(defun telefones (agenda nome)
  "Busca os telefones de NOME na AGENDA.

Retorna a lista de telefones quando o contato existe, ou o simbolo INEXISTENTE
quando nao existe."
  (cond
    ((atom agenda)
     'INEXISTENTE)
    ((mesmo-nome-p (car agenda) nome)
     (cdr (car agenda)))
    (t
     (telefones (cdr agenda) nome))))
