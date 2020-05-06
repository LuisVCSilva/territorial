
# Documenta��o

+ [ ] definir os requisitos dos componentes de recupera��o de dados do CEPESP.io (para luis) e IBGE (para gabriel) (`rcarocha`)
+ [ ] definir os requisitos de recupera��o de dados do TSE (n�o dispon�veis no CEPESP.io)

# Projeto e Implementa��o

+ [ ] definir a funcionalidade e arquitetura da api para consultas baseadas em localiza��o (`rcarocha`)


especificar as informa��es do IBGE que ser�o incorporadas na base da solu��o
implementar a disponibiliza��o das informa��es do IBGE na solu��o
implementar a pesquisa baseada em localiza��o das informa��es do IBGE


# Issues

## API CEPESP

+ Pesquisas REST de "Resultados das Elei��es por Cargo", n�o documenta como
realizar uma pesquisa com agrega��o pol�tica (`agregacao_politica`) e agrega��o
regional � simplesmente ignorada (problema n�o reportado para o CEPESP).

aparentemente, filtragem de dados de candidatos por título de eleitor também não
funciona.

Candidato com titulo de eleitor = 28172221619 inexistente!
Candidato com titulo de eleitor = 12421111210 inexistente!
Candidato com titulo de eleitor = 44209480574 inexistente!
Candidato com titulo de eleitor = 77698080183 inexistente!
Candidato com titulo de eleitor = 131224480540 inexistente!

número de votos por legenda (deputado federal)
de partidos como PT e PSOL parecem terem sumido da base de dados, aparecendo
apenas em alguns poucos estados.

```
curl -i -X GET "http://cepesp.io/api/consulta/votos?anos="2014"&cargo=6&agregacao_regional=2"
```
no estado de goiás isso foi verificado.
segundo verificação em
http://cepesp.io/consulta/tse?cargo=6&agregacao_regional=2&agregacao_politica=3&anos%5B%5D=2014&uf_filter=&mun_filter=
só está computando os votos de partidos que estão dentro de coligações

e mesmo as coligações não estão batendo.

* PMDB / DEM / SD / PC do B / PRTB / PTN / PPL
* PSB / PSC / PRP
* PSDB / PP / PR / PSD / PTB / PDT / PPS / PROS / PRB

consta a seguinte coligação/legenda: PMDB / PV / PT / PSD


uma pesquisa por resultado de eleição, com consolidação de eleição não retorna qdados quando é enviada umaseleção qualquer de colunas ou filtro. por exemplo:

curl -i -g -X GET "http://cepesp.io/api/consulta/tse?cargo=6&agregacao_regional=2&agregacao_politica=4&ano=2014&selected_columns[]=QT_VOTOS_BRANCOS&selected_columns[]=QT_VOTOS_NULOS"
não retorna nada (na verdade erro "No group keys passed!" na resposta HTTP)
e teste
curl -i -g -X GET "http://cepesp.io/api/consulta/tse?cargo=6&agregacao_regional=2&agregacao_politica=4&ano=2014"
funciona

base de coligações retorna algumas com partido igual a "#NE#".
Exemplo:
6,	1,	JUNTOS POR UM ESPÍRITO SANTO MAIS FORTE,	#NE#,	DEPUTADO FEDERAL,	2014,	PRP / PEN,	Espírito Santo,	ES,	50672


consultas cepesp de votos na agregação município não incluem os votos em legenda, computando apenas os votos nos candidatos que pertencem
aos partidos como votos em legenda.
exemplo: http://cepesp.io/consulta/tse?cargo=6&agregacao_regional=6&agregacao_politica=2&anos%5B%5D=2014&uf_filter=GO&mun_filter=
nas demais agregação, tais votos aparecem como votos no candidato com numero=num_partido e com títulio de eleitor = "#NULO#".
a pesquisa por coligaçao (usando esse tipo de agregação) também só computa os votos dos candidatos, deixando as legendas de lado.


pesquisa sobre minucipio extremamente e desnecessriamente lentas.
