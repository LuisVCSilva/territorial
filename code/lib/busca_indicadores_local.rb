=begin
*******************************************************************************
Este código deve ser considerado como deprecated. A sua funcionalidade
foi migrada para a área da aplicação Rails (territorial/rails) e quaisquer
modificações devem ser feita naquela localização.

Excepcionalmente, modificações podem ser realizadas para motivos de teste local,
mas sem que sejam incorporados no git. Considere também que o código abaixo
pode ter sofrido alterações na sua migração para Rails.

Localização atual deste código:
/territorial/rails/app/models/ibge
*******************************************************************************
=end

require 'json'
require 'open-uri'
require './indicador.rb'
require '../config/application.rb'



class DadosIndicador

	attr_accessor :indicador, :cidade, :dados

	#Dados é um hash contendo o ano daquele dado como chave
	def initialize(indicador, cidade, dados={})
		@indicador = indicador
		@dados = dados
		@cidade = cidade
	end

	def add_ano(ano, dado)
		@dados.store(ano, dado)
	end

	def to_s
		s = "#{@cidade} - #{@indicador.to_s}"
		dados.each_key {|key| s+= "\nAno #{key} o dado foi #{dados[key]} #{@indicador.unidade}"}
		s
	end

	class << self

		def buscar(localidade, e_indicadores)
			dados = {}

			if (localidade.class == Array)
				cidades = localidade.clone
			elsif localidade.class == Municipio
				cidade = [localidade]
			else
				cidades = localidade.municipios
			end

			separador = "%7C"

			indicadores = e_indicadores.clone
			url = Indicador.URL_INDICADORES
			if indicadores.class == Integer
				indicadores = {indicadores => Indicador.new(indicadores)}
			elsif indicadores.class == Indicador
				indicadores = {indicadores.id => indicadores}
			elsif indicadores.class == Array
				ind = {}
				indicadores.each do |i|
					if i.class == Integer
						ind.store(i,Indicador.new(i))
					elsif i.class == Indicador
						ind.store(i.id, i)
					else
						LOGGER.error("indicadores em formato desconhecido "+indicadores.class.to_s)
					end
				end
			else
				LOGGER.error("indicadores em formato desconhecido "+indicadores.class.to_s)
			end

			indicadores.each_key {|i| url += indicadores[i].id.to_s+separador}

			url = url.slice(0, url.length-3)
			url += "/resultados/"

			#O limite da API do IBGE é de 26 cidades
			if (cidades.length > 26)
				segunda_consulta = cidades.slice(26, cidades.length)
				cidades = cidades.slice(0, 26)
				dados.merge! buscar(segunda_consulta, indicadores)
			end
			cidades.each do |cidade|
				id = nil
				if cidade.class == Integer or cidade.class == String
					id = cidade
				else
					id = cidade.cod_ibge
				end
				url += (id.to_s+"%7C")
				dados.store(Integer(id.to_s.slice(0,6)), {})
			end

			url = url.slice(0, url.length-3)

			LOGGER.debug("Busca por indicador e localidades: GET " + url)
			begin
				content = open(url).read()
			rescue => e
				LOGGER.error(e.message.to_s + " - " + e.backtrace.to_s)
				raise e
			end

			json = JSON.parse(content)
			json.each do |ind|
				ind["res"].each do |cid|
					dado = DadosIndicador.new(indicadores[ind["id"]], Integer(cid["localidade"]))
					dado.dados = cid["res"]
					dados[dado.cidade].store(dado.indicador.id, dado)
				end
			end
			return dados
		end
	end
end


=begin
teste = ["2806404", "2800100", "2800704", "2801108", "2801603", "2802700", "2804409", "2804706", "2805703", "2807303", "2800308", "2800605", "2804805", "2806701", "2800407", "2800670", "2801702", "2803005", "2805109", "2806206", "2807501", "2807600", "2801306", "2802007", "2806503", "2807204", "2801504", "2802502", "2803609", "2804003", "2805901", "2806107", "2806602", "2802106", "2802809", "2803203", "2806305", "2803302", "2803401", "2804904"]
res = DadosIndicador.buscar(teste, Indicador.IDH)
=end

=begin
Exemplo de uso
inds = Indicador.get_indicadores(Indicador.PIB_PER_CAPTA, Indicador.HABITANTES, Indicador.IDH)
dados = DadosIndicador.buscar(420540, inds)
dados.each_key {|key| puts dados[key].to_s}
ou
inds = Indicador.get_indicadores(Indicador.PIB_PER_CAPTA, Indicador.HABITANTES, Indicador.IDH)
dados = DadosIndicador.buscar([420540,310620] , inds)
dados.each_value {|cidade| cidade.each_key {|key| puts cidade[key].to_s}}
=end



=begin
#Para pegar as informações sobre um, ou vários indicadores
#https://servicodados.ibge.gov.br/api/v1/pesquisas/indicadores/$id_indicador
# 60047 PIB per capta
PIB_PER_CAPTA = 60047

content = open("https://servicodados.ibge.gov.br/api/v1/pesquisas/indicadores/60047").read()
indicadores = JSON.parse(content)

#Para os resultados daquele indicador chamamos
#https://servicodados.ibge.gov.br/api/v1/pesquisas/indicadores/$id_identificador/resultados/$id_cidade
BELO_HORIZONTE = 310620

content = open("https://servicodados.ibge.gov.br/api/v1/pesquisas/indicadores/60047/resultados/310620").read()
resultado = JSON.parse(content)
pib = resultado[0]["res"][0]["res"]

puts ("Sobre Belo Horizonte")
pib.each_key do |ano|
	print("No ano #{ano} o PIB per Capta foi de #{pib[ano]}\n")
end
=end
