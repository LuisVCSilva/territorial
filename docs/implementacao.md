# Projeto da Implementa��o

## Resumo

Solu��o prover� pesquisas em resultados eleitorais baseadas em localiza��o sem�ntica est�tica (divis�es administrativas) e din�mica (territ�rios baseados em crit�rios sociais), o oferecer� um frontend composto de uma aplica��o baseada em mapas que permitir� simula��es e um backend que oferecer� as pesquisas utilizando uma api RESTful. Aplica��o frontend oferer� ainda interface espec�fica para eleitores.

## Solu��o

A solu��o deve ser composta de duas partes:

+ **Frontend**: uma interface web baseada em localiza��o, fazendo uso, a priori do <http://leafletjs.com/> (usando base de mapas [openstreetmap](https://www.openstreetmap.org/)).
+ **Backend**: uma API RESTful para consultas baseadas em localiza��o equivalentes (o m�ximo poss�vel) �s que podem ser realizadas com a interface do usu�rio. Essa interface � importante por permitir que a solu��o seja utilizada para pesquisas de fato, sem as limita��es inerentes � interface gr�fica.

Por consultas baseadas em localiza��o entenda-se que as consultas do usu�rio levar�o em conta localiza��o como primeiro crit�rio para o resultado, diferentemente da API CEPESP que d� pouca relev�ncia a essa informa��o. Em particular, dois tipos de localiza��o ser�o considerados:

* **Localiza��o sem�ntica est�tica**: referente �s divis�es administrativas especificadas pelo IBGE (macro, meso, microrregi�es, estados, munic�pios), complementadas por poss�veis subdivis�es estabelecidas pelo TSE (zonas e se��es).
* **Localiza��o sem�ntica din�mica**: divis�es do territ�rio brasileiro criadas dinamicamente a partir de consultas a dados sociais e pol�ticos do IBGE como, por exemplo, *regi�es com �ndice IDH > 0.65*, devidamente georeferenciados e associados �s localiza��es est�ticas.

A API dever� permitir consultas geogr�ficas baseadas nessas localiza��es.

Rascunho produzido para discutir os aspectos da implementa��o. 

<img src="imagens/rascunho-quadro.jpg" />

## Informa��es Produzidas pela Solu��o

As seguintes informa��es ser�o produzidas pela solu��o e oferecidas em ambas as interfaces:

* Candidatos eleitos
* Percentual dos eleitos por partido e coliga��o

... a completar.

## Interface 

<img src="imagens/draft-1-interface.jpg" />
