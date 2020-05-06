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
require 'net/http'
require 'uri'
require 'ostruct'
require_relative 'consultas_tse.rb'
require_relative 'brasil_symb_location.rb'
#require '../lib/location_model.rb'


class InterfaceDados
	#Entrada:Os parametros de busca para pesquisa na CEPESP:
	#Saida: O status code da http request e, se possível, os resultados da busca.
	def self.recuperaFonte(contexto,params)
	uri = URI.parse("http://cepesp.io/api/consulta/"+contexto+"?"+params)
	puts uri
	response = Net::HTTP.get_response(uri)
    end

	# Entrada: string onde a primeira linha é o cabeçalho csv e as demais as tuplas
	# Saida: lista de objetos dinamicos, cheque os metodos antes de usar...
	def self.processa (contexto,s)
	s = s[1 .. -2]

	chaves = recuperaFonte(contexto.to_s,s).body.split("\n")[0].gsub("\"","").downcase.split(",")
	conjunto = recuperaFonte(contexto.to_s,s).body.split("\n")[1 .. -1]
	lista = conjunto.map{|it| Hash[chaves.zip((it.gsub("\"","").split(",").map {|i| i.include?(',') ? (i.split /, /) : i}).map {|i| i.include?(',') ? (i.split /, /) : i})]}

	#para cada tabela hash da lista, crie um objeto
	s = lista.map {|i| OpenStruct.new i}
	end

	def self.get_eleicao (cargo=nil,ano=nil)
	s = "&agregacaoRegional=2" +
		(ano==nil ? "" : "&ano="+ano.to_s)+
		(cargo==nil ? "" : "&cargo="+cargo.to_s)+
		("&agregacaoPolitica=1")+
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

end

=begin
um pequeno demo da interface está abaixo
=end

#partido_A = Partido.new(nome:"Partido Ponto a Ponto", sigla:"PPP", numero:777)
#candidato_A = Candidato.new(ano:2014,local:'GO',nome:'Luis', id: 1, partido: partido_A, isCandidaturaValida: true)

#testando a Pesquisa de Candidatos
eleicao = InterfaceDados.get_eleicao(cargo=6,ano="2014")
totalVotos = InterfaceDados.total_votos_eleicao(eleicao)
totalVotosPt = InterfaceDados.total_votos_partido(eleicao,"PT")

sp = Estado.estados[20]
qtdeVagasPt = get_vagas_eleicao("2014",:deputado_federal,sp)

puts "[Deputado Federal] Total de votos em 2014 = " + totalVotos.to_s
puts "[Deputado Federal] Total de votos para o PT em 2014 = " + totalVotosPt.to_s
puts "[Deputado Federal] Qtde de vagas para o PT em 2014 = " + qtdeVagasPt.to_s
#puts x.json
