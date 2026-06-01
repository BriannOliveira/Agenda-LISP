;;; agenda.lisp
;;; Implementacao de uma agenda telefonica simples em Common Lisp.
;;;
;;; Cada contato e representado como:
;;;   (Nome Telefone1 Telefone2 ...)
;;;
;;; Exemplos de uso:
;;;   (setq AGENDA nil)
;;;   (setq AGENDA (incluir AGENDA '(Bel 32338778)))
;;;   (setq AGENDA (incluir AGENDA '(Rose 32666556)))
;;;   (Telefones AGENDA 'Rose)

(defun mesmo-nome-p (registro nome)
  "Verifica se REGISTRO pertence ao contato chamado NOME."
  (equal (first registro) nome))

(defun nome-do-contato (contato)
  "Retorna o nome recebido em uma entrada do tipo (Nome Telefone)."
  (first contato))

(defun telefone-do-contato (contato)
  "Retorna o telefone recebido em uma entrada do tipo (Nome Telefone)."
  (second contato))

(defun adicionar-telefone-no-registro (registro telefone)
  "Adiciona TELEFONE ao REGISTRO, evitando telefones repetidos."
  (if (member telefone (rest registro) :test #'equal)
      registro
      (append registro (list telefone))))

(defun incluir (agenda contato)
  "Inclui CONTATO na AGENDA.

CONTATO deve estar no formato (Nome Telefone). Se o nome ainda nao existir,
um novo registro sera criado. Se o nome ja existir, o telefone sera adicionado
ao registro existente."
  (let ((nome (nome-do-contato contato))
        (telefone (telefone-do-contato contato)))
    (if (null agenda)
        (list (list nome telefone))
        (mapcar
         (lambda (registro)
           (if (mesmo-nome-p registro nome)
               (adicionar-telefone-no-registro registro telefone)
               registro))
         (if (some (lambda (registro) (mesmo-nome-p registro nome)) agenda)
             agenda
             (append agenda (list (list nome telefone))))))))

(defun remover-telefone-do-registro (registro telefone)
  "Remove TELEFONE do REGISTRO e retorna o registro atualizado."
  (cons (first registro)
        (remove telefone (rest registro) :test #'equal)))

(defun registro-sem-telefones-p (registro)
  "Indica se o REGISTRO nao possui mais telefones."
  (null (rest registro)))

(defun excluir (agenda contato)
  "Remove o telefone de CONTATO da AGENDA.

CONTATO deve estar no formato (Nome Telefone). Caso o telefone removido seja
o unico telefone daquele nome, o proprietario tambem sera removido da agenda.
Se o nome ou telefone nao existir, a agenda sera retornada sem alteracoes."
  (let ((nome (nome-do-contato contato))
        (telefone (telefone-do-contato contato)))
    (remove-if
     #'registro-sem-telefones-p
     (mapcar
      (lambda (registro)
        (if (mesmo-nome-p registro nome)
            (remover-telefone-do-registro registro telefone)
            registro))
      agenda))))

(defun telefones (agenda nome)
  "Busca os telefones de NOME na AGENDA.

Retorna a lista de telefones quando o contato existe, ou o simbolo INEXISTENTE
quando nao existe."
  (let ((registro (find nome agenda
                        :key #'first
                        :test #'equal)))
    (if registro
        (rest registro)
        'INEXISTENTE)))

