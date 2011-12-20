Conjugue
========

Brazilian portuguese verb conjugation.

Current verb database uses [br.ispell-3.0-beta4](http://www.ime.usp.br/~ueda/br.ispell/beta.html).


Usage:
------

	Conjugue.verbo nome, tempo, pessoa, plural

`nome`: infinitive form

`tempo`:

  :p => presente do indicativo
  :pi => imperfeito do indicativo,
  :pp => perfeito do indicativo,
  :pm => mais-que-perfeito do indicativo,
  :f => futuro do pretérito do indicativo
  :fp => futuro do presente do indicativo
  :ps => presente do subjuntivo
  :pis => imperfeito do subjuntivo
  :i => imperativo afirmativo
  :in => 'imperativo negativo

`pessoa`: integer representing the person number

`plural`: default: `false`


Ex:

	require 'conjugue'

	Conjugue.verbo 'programar', :fp, 3, true  # "Eles programarão"


TODO
----

* Tests
* Guess conjugation for verbs not in the database
* Consider extending [linguistics](https://github.com/ged/linguistics) gem to avoid duplication of efforts
