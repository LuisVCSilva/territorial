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

# **ATENCAO**
# deprecated: Ja migrado para a aplicacao Rails
# Favor realizar modificacoes na versao deste arquivo no Rails em
# territorial/rails/app/models/ibge/indicador.rb
#

require 'json'
require 'open-uri'
require '../config/application.rb'

class Indicador

	attr_accessor :id, :descricao, :unidade

	def initialize(id, descricao="", unidade="N/A")
		@id = id
		@descricao = descricao
		@unidade = unidade
	end

	def to_s
		"#{@id}, #{@descricao}, #{@unidade}"
	end


	@PIB_PER_CAPTA = 60047
	#os ids 29171 e 48985 representam o mesmo indicador de população estimada
	@HABITANTES = 29171
	@IDH = 30255

	@Indicadores_disponiveis = {"PIB_PER_CAPTA":@PIB_PER_CAPTA, "HABITANTES":@HABITANTES, "IDH":@IDH}

	@URL_INDICADORES = "https://servicodados.ibge.gov.br/api/v1/pesquisas/indicadores/"

	class << self

		attr_reader :URL_INDICADORES
		attr_reader :HABITANTES, :PIB_PER_CAPTA, :IDH
		attr_reader :Indicadores_disponiveis

		#Função estática que retorna os indicadores passados por ID
		def get_indicadores(*id_indicadores)
			url = @URL_INDICADORES
			id_indicadores.each {|id| url += (id.to_s+"%7C")}
			url = url.slice(0, url.length-3)
			LOGGER.debug("Busca por informações de indicador: GET " + url)
			begin
				content = open(url).read()
			rescue => e
				LOGGER.error(e.message.to_s + " - " + e.backtrace.to_s)
				raise e
			end

			json = JSON.parse(content)

			indicadores = {}
			json.each do |ind|
				indicador = Indicador.new(ind["id"], ind["indicador"])
				#Um identificador pode ou não ter uma unidade
				if (ind.has_key?("unidade"))
					indicador.unidade = ind["unidade"]["id"]
				end
				indicadores.store(indicador.id, indicador)
			end
			return indicadores
		end
	end
end

=begin
Exemplo de uso
Indicador.get_indicadores(Indicador.PIB_PER_CAPTA, Indicador.HABITANTES)
=end
