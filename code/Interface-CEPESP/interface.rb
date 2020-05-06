=begin
*******************************************************************************
Este código deve ser considerado como deprecated. A sua funcionalidade
foi migrada para a área da aplicação Rails (territorial/rails) e quaisquer
modificações devem ser feita naquela localização.

Excepcionalmente, modificações podem ser realizadas para motivos de teste local,
mas sem que sejam incorporados no git. Considere também que o código abaixo
pode ter sofrido alterações na sua migração para Rails.

Localização atual deste código:
/territorial/rails/app/models/cepesp
*******************************************************************************
=end

#TODO -> Dada uma eleicao, retone uma lista de candidatos por votos por região
#	-> Dado o numero e estado do candidato, retorne-o
# 	-> CODIGO_LEGENDA
# 	-> isEleito
#
require 'net/http'
require 'uri'
require 'ostruct'
require 'set'

require '../lib/cache/service_request_cache'

require_relative('Partido')
require_relative('Votacao')
require_relative('Candidato')
require_relative('Legenda')
require_relative('Eleicao')

require_relative('consultas_tse.rb')
require_relative('brasil_symb_location.rb')

class InterfaceDados
	#Entrada:Os parametros de busca para pesquisa na CEPESP:
	#Saida: O status code da http request e, se possível, os resultados da busca.
	def self.recuperaFonte(contexto,params)
	  uri = URI.parse("http://cepesp.io/api/consulta/"+contexto+"?"+params)
	  puts ("Backend Request => http://cepesp.io/api/consulta/"+contexto+"?"+params)

		# requisicao antiga nao cacheada
		# s = response = Net::HTTP.get_response(uri)

    s = response = get_remote_resource(uri.to_s)

	  puts("Request Done!" + response.inspect)
	  return s
  end

	# Entrada: string onde a primeira linha é o cabeçalho csv e as demais as tuplas
	# Saida: lista de objetos dinamicos, cheque os metodos antes de usar...
	def self.processa (contexto,s)
	s = s[1 .. -2]
=begin
		Ok, as próximas 3 linhas de código são capciosas...
		São criados dois arrays: "chaves" e "conjunto", depois da execução das 3 linhas teremos uma lista 			composta por tabelas hashes, de tal forma que toda hash possui como chaves os atributos da 			consulta (i.e: cabeçalho do csv, contido no array "chaves"), após isso associamos cada valor do 		conjunto(contido no array conjunto) a sua respectiva chave e guardamos cada tabela hash em uma 			lista.
=end

	raw = recuperaFonte(contexto.to_s,s)[:body].split("\n")
	#chaves = raw.body.split("\n")[0].gsub("\"","").downcase.split(",")
	#conjunto = raw.body.split("\n")
	chaves = raw[0].gsub("\"","").downcase.split(",")
	conjunto = raw[1 .. -1]
	lista = conjunto.map{|it| Hash[chaves.zip((it.gsub("\"","").split(",").map {|i| i.include?(',') ? (i.split /, /) : i}).map {|i| i.include?(',') ? (i.split /, /) : i})]}

	#para cada tabela hash da lista, crie um objeto
	s = lista.map {|i| OpenStruct.new i}
	end

	def self.novo_processa(contexto,s,key)
		s = s[1 .. -2]
		key = key.downcase
		raw = recuperaFonte(contexto.to_s,s)[:body].split("\n")
		#chaves = raw.body.split("\n")[0].gsub("\"","").downcase.split(",")
		#conjunto = raw.body.split("\n")
		chaves = raw[0].gsub("\"","").downcase.split(",")

		elems = {}

		for i in 1..raw.length-1
			elem_raw = {}
			line = raw[i].gsub("\"","").split(",")
			chaves.each_index {|j| elem_raw.store(chaves[j], line[j])}
			elem = OpenStruct.new elem_raw
			if (elems[elem.send(key)] == nil)
				elems.store(elem.send(key), [elem])
			else
				elems.store(elem.send(key), elems[elem.send(key)] << elem)
			end
		end
		elems
	end

	def self.adicionar_coluna(colunas)
		s = ""
		colunas.each {|col|
			s+="&selected_columns%5B%5D="+col.to_s
		}
		return s
	end

	# Pesquisa candidatos por `localização`, `ano`, `cargo`, `partido` e `número`,
	# retornando o(s) candidato(s) que se adequem aos critérios pesquisados.
	# Os candidatos retornados indicam se a candidatura dos mesmos é válida.
	def self.pesquisa_candidatos(ano=nil, cargo=nil, partido=nil, numero=nil)
	s =
		(ano==nil ? "" : "&ano="+ano.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		(partido==nil ? "" : "&partido="+partido.to_s)+
		(numero==nil ? "" : "&numero="+numero.to_s)+
		("&selected_columns%5B%5D=NOME_CANDIDATO
		&selected_columns%5B%5D=NUMERO_CANDIDATO
		&selected_columns%5B%5D=CPF_CANDIDATO
		&selected_columns%5B%5D=NOME_URNA_CANDIDATO
		&selected_columns%5B%5D=DES_SITUACAO_CANDIDATURA
		&selected_columns%5B%5D=NUM_TITULO_ELEITORAL_CANDIDATO
		&selected_columns%5B%5D=CODIGO_LEGENDA")+
		"&"#formatando os parametros da request na url da cepesp
	s = self.processa(:candidatos,s)
	end


	def self.pesquisa_votacao(localizacao=nil, cargo=nil, ano=nil, numero=nil)
	#formatando os parametros da request na url da cepesp
	s = ("&agregacao_regional=9")+
		(localizacao==nil ? "" : "&uf_filter="+localizacao.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		(ano==nil ? "" : "&ano="+ano.to_s)+
		(numero==nil ? "" : "&numero="+numero.to_s)+
		"&"
	s = self.processa(:votos,s)

	end

	def self.pesquisa_legenda(localizacao=nil, ano=nil, cargo=nil)
	s = (localizacao==nil ? "" : "&uf_filter="+localizacao.to_s)+
		(ano==nil ? "" : "&ano="+ano.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		"&"#formatando os parametros da request na url da cepesp
	s = self.processa(:legendas,s)
	end

	def self.pesquisa_eleicao_votos_regiao(ano, cargo)
		s = "&agregacao_regional=6" +
		"&agregacao_politica=2"+
		(ano==nil ? "" : "&anos="+ano.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		"&"#formatando os parametros da request na url da cepesp
		s = self.processa(:tse,s)
	end

	def self.pesquisa_eleicao_votos_regiao(ano, cargo, tipo_regiao)
		s = "&agregacao_politica=2"+
		(tipo_regiao==nil ? "" : "&agregacao_regional="+tipo_regiao.to_s)+
		(ano==nil ? "" : "&anos="+ano.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		adicionar_coluna(["CODIGO_CARGO","NUM_TURNO", "SIGLA_PARTIDO", "DESCRICAO_CARGO", "ANO_ELEICAO", "NUMERO_PARTIDO", "NUMERO_CANDIDATO", "QTDE_VOTOS", "NUM_TITULO_ELEITORAL_CANDIDATO"])
		if (tipo_regiao==:municipio)
			s += "&agregacao_regional=6"
			s += adicionar_coluna ["COD_MUN_IBGE", "COD_MUN_TSE", "NOME_MUNICIPIO"]
		elsif tipo_regiao==:macroregiao
			s += "&agregacao_regional=1"
			s += adicionar_coluna ["CODIGO_MACRO", "NOME_MACRO"]
		elsif tipo_regiao==:mesoregiao
			s += "&agregacao_regional=4"
			s += adicionar_coluna ["CODIGO_MESO", "NOME_MESO"]
		elsif tipo_regiao==:microregiao
			s += "&agregacao_regional=5"
			s += adicionar_coluna ["CODIGO_MICRO", "NOME_MICRO"]
		elsif tipo_regiao==:estado
			s += "&agregacao_regional=2"
			s += adicionar_coluna ["UF", "NOME_UF"]
		end
		s+="&"#formatando os parametros da request na url da cepesp

		return self.novo_processa(:tse,s, "NUM_TITULO_ELEITORAL_CANDIDATO")
	end

	def self.get_eleicao (cargo=nil,ano=nil)
		s = "&agregacao_regional=2" +
		(ano==nil ? "" : "&anos[]="+ano.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		("&agregacao_politica=3")+
		"&"#formatando os parametros da request na url da cepesp
	s = self.processa(:tse,s)
	end

	def self.total_votos_partido (tabelaEleicao,partido=nil)
	totalVotos = 0
	tabelaEleicao.each{ |a| totalVotos += a.sigla_partido==partido ? a.qtde_votos.to_i : 0}
	return totalVotos
	end

	def self.total_votos_eleicao (tabelaEleicao)
	totalVotos = 0
	tabelaEleicao.each{ |a| totalVotos += a.qtde_votos.to_i}
	return totalVotos
	end

	def self.get_partidos (tabelaEleicao)
	s1 = Set.new
	tabelaEleicao.each{ |a| s1.add(a)}
	return s1
	end

end

=begin
um pequeno demo da interface está abaixo
=end

#TESTANDO ALGUMAS CLASSES...

#TESTANDO METODOS DE PESQUISA
#testando a Pesquisa de Candidatos
#x = InterfaceDados.pesquisa_candidatos(ano="2014",cargo="1")
#puts x
#x = InterfaceDados.pesquisa_votacao(localizacao="GO")
#puts "Votacao = " + x[0].to_s + "\n\n"

#x = InterfaceDados.pesquisa_legenda(localizacao="GO")
#puts "Legenda = " + x[0].to_s + "\n\n"

#eleicao = InterfaceDados.get_eleicao(cargo=6,ano="2014")
#puts eleicao
#totalVotosEleicao = InterfaceDados.total_votos_eleicao(eleicao)
#puts("Total votos = " + totalVotosEleicao.to_s)
#listaPartidos = InterfaceDados.get_partidos(eleicao).to_set
#qtdeVagas = 70
#partidos = listaPartidos.map{|a| Partido.new(nome: a.nome_candidato, sigla: a.sigla_partido, numero: "", quociente_eleitoral: totalVotosEleicao, quociente_partidario: -1, qtde_vagas: get_vagas_eleicao("2014",:deputado_federal,), qtde_votos: InterfaceDados.total_votos_partido(eleicao,a.sigla_partido)/qtdeVagas, sobras: -1)}
#puts "[PARTIDOS] = " + partidos.join("\n")
#puts "[PARTIDOS] = " + listaPartidos.join("\n")

#totalVotosDEM = InterfaceDados.total_votos_partido(eleicao,"DEM")

#sp = Estado.estados[20]
#totalVagasDEM = get_vagas_eleicao("2014",:deputado_federal,sp)


#puts "[ELEICAO] = " + eleicao.to_s

#puts "[Deputado Federal] Total de votos em 2014 = " + totalVotos.to_s
#puts "[Deputado Federal] Total de votos para o DEM em 2014 = " + totalVotosDEM.to_s
#puts "[Deputado Federal,[SP]] Qtde de vagas para o DEM em 2014 = " + totalVagasDEM.to_s


#quocienteEleitoral = totalVotos/totalVagasDEM
#quocientePartido = (totalVotosDEM/quocienteEleitoral).floor

#puts "Quociente eleitoral: " + quocienteEleitoral.to_s
#puts "Quociente Partidario: " + quocientePartido.to_s
#sobra = totalVotosDEM/(quocientePartido+1)
#puts sobra.to_s


#somatorioSobrasPartido = 10#variavel guarda o somatorio das sobras de vagas de todos os partidos
#somatorioSobrasPartido.times do
#listaPartidos.each{ |a| partidos.insert(Partido.new(nome: a.nome_candidato, sigla: a.sigla_partido, numero: a.numero_partido, quociente_partidario: totalVotosDEM/quocienteEleitoral))}
#end
#TODO -> implementar algoritmo para calculo de sobras
'''
para i de 1 ate qtdeSobras=SomatorioSobrasPartidos
 para todo partido na eleicao
  calcule o indicador de sobras
  acresca de uma vaga o partido com o maior indice
 fimpara
fimpara
'''
#res = InterfaceDados.pesquisa_eleicao_votos_regiao("2014", "1")
#binding.pry
