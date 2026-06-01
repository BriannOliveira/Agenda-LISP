# Agenda em Lisp

Projeto do trabalho de Programacao Funcional: implementacao de uma agenda em Common Lisp.

## Arquivos

- `agenda.lisp`: funcoes principais da agenda.
- `tests.lisp`: testes automatizados simples.

## Funcoes implementadas

- `(incluir agenda '(Nome Telefone))`: inclui um novo contato ou adiciona telefone a um contato existente.
- `(excluir agenda '(Nome Telefone))`: remove um telefone; se for o ultimo telefone do contato, remove tambem o nome.
- `(Telefones agenda 'Nome)`: retorna os telefones do contato ou `INEXISTENTE`.

## Como executar os testes

```bash
sbcl --script tests.lisp
```

## Exemplo de uso no interpretador

```lisp
(load "agenda.lisp")

(setq AGENDA nil)
(setq AGENDA (incluir AGENDA '(Bel 32338778)))
(setq AGENDA (incluir AGENDA '(Rose 32666556)))
(setq AGENDA (incluir AGENDA '(Rose 991919191)))
(setq AGENDA (incluir AGENDA '(Beto 32529119)))

(Telefones AGENDA 'Jose)
;; INEXISTENTE

(Telefones AGENDA 'Rose)
;; (32666556 991919191)

(setq AGENDA (excluir AGENDA '(Rose 991919191)))
(Telefones AGENDA 'Rose)
;; (32666556)
```

