=begin
*******************************************************************************
Este código deve ser considerado como deprecated. A sua funcionalidade
foi migrada para a área da aplicação Rails (territorial/rails) e quaisquer
modificações devem ser feita naquela localização.

Excepcionalmente, modificações podem ser realizadas para motivos de teste local,
mas sem que sejam incorporados no git. Considere também que o código abaixo
pode ter sofrido alterações na sua migração para Rails.

Localização atual deste código:
/territorial/rails/app/models/places
*******************************************************************************
=end
# **ATENCAO**
# deprecated: Ja migrado para a aplicacao Rails
# Favor realizar modificacoes na versao deste arquivo no Rails em
# territorial/rails/app/models/places/brasil_symb_location.rb
#

require 'json'
require './location_model.rb'

file = File.read("../data/brasil.json")
brasil_local = JSON.parse(file)


ja_existentes = []

# issue: ZZ code considerado?

es = nil
brasil_local["dados"].each do |id_macroregiao, macroregiao|
	novo_macro = Macroregiao.new(id_macroregiao, macroregiao["nome"])
   puts "Macroregiao: " + novo_macro.nome
   estados = macroregiao["dados"]
   estados.each do |id_estado, dados_estado|
      puts "   Estado: " + dados_estado["nome"]
		novo_estado = Estado.new(id_estado, dados_estado["nome"], novo_macro)
      if novo_estado.sigla == "ES" then
			puts "criando estado ..."
			es = novo_estado
		end
		mesoregioes = dados_estado["dados"]
		mesoregioes.each do |id_mesoregiao, dados_mesoregiao|
			novo_meso = Mesorregiao.new(id_mesoregiao, dados_mesoregiao["nome"], novo_estado)
			microrregioes = dados_mesoregiao["dados"]
			microrregioes.each do |id_microrregiao, dados_microrregiao|
				novo_micro = Microrregiao.new(id_microrregiao, dados_microrregiao["nome"], novo_meso)
				municipios = dados_microrregiao["dados"]
				municipios.each do |id_municipio, municipios_dados|
					novo_municipio = Municipio.new(municipios_dados["cod_mun_ibge"],
					                               municipios_dados["cod_mun_tse"],
					                               municipios_dados["nome"],
					                               novo_micro)
				end
			end
		end
	end
end

=begin
# recuperando todas as macrorregioes e seus estados
puts " ** Recuperacao de Estados por Macroregiao **"
macros = Macroregiao.macroregioes
macros.each do |macro|
	puts "Macroregiao id = " + macro.id + " (" + macro.nome + ")"
	estadosm = macro.estados
	print "    => "
	estadosm.each do |estado|
		print estado.sigla + "(" + estado.id + ") "
	end
	print "\n"
end


# TODO: remover codigo de teste
puts "-- Mesorregioes do ES (" + es.macroregiao.id + "/" + es.id  + ") --"
es.mesorregioes.each do |mesorregiao|
   puts "   -> meso - " + mesorregiao.nome + " (" + mesorregiao.id + ")"
   mesorregiao.microrregioes.each do |micro|
	   puts "        * micro - " + micro.to_s + " (" + micro.id + ")"
		micro.municipios.each do |muni|
			puts "           - " + muni.nome + " (" + muni.cod_ibge + ")"
		end
	end
end
=end

HOST_IBGE_API_LOC = "servicodados.ibge.gov.br"
PATH_IBGE_API_LOC = "/api/v2/malhas/"
RES_NUM_DEFAULT = 3
TABELA_RESOLUCAO = {
      :brasil => 0,
      :macroregiao => 1,
      :estado => 2,
      :mesorregiao => 3,
      :microrregiao => 4,
      :municipio => 5
   }

# Constroi os parametros de requisicao para recuperar geojson de localizacoes.
# Exemplo:
#    - build_parametros_ibge_api_loc(es)
#    - build_parametros_ibge_api_loc(es,:absoluta, :municipio)
# Parameters:
# - tipo_res: :relativa ou :absoluta
def build_parametros_ibge_api_loc(localizacao, tipo_res=:absoluta, resolucao=:mesorregiao)
   res_num = RES_NUM_DEFAULT
   if resolucao.is_a? Symbol then
      res_num = TABELA_RESOLUCAO[resolucao]
      if res_num == nil then
         res_num = RES_NUM_DEFAULT
      end
   else
      res_num = RES_NUM_DEFAULT
   end

   if tipo_res == :relativa then
      if !resolucao.is_a? Numeric
         resolucao = 1
      end
      case localizacao.class
      when Municipio
         res_num = TABELA_RESOLUCAO[:municipio] + resolucao
      when Microrregiao
         res_num = TABELA_RESOLUCAO[:microrregiao] + resolucao
      when Mesorregiao
         res_num = TABELA_RESOLUCAO[:mesorregiao] + resolucao
      when Estado
         res_num = TABELA_RESOLUCAO[:estado] + resolucao
      when Macroregiao
         res_num = TABELA_RESOLUCAO[:macroregiao] + resolucao
      else
         res_num = TABELA_RESOLUCAO[:mesorregiao]
      end
   end

   return localizacao.id.to_s + "?resolucao=" + res_num.to_s

end



# Recupera o geojson da api do IBGE para uma localizacao, incluindo sublocalizacoes
# dependendo da resolucao pretendida.
# Exemplo: puts get_geojson(es,:absoluta, :municipio)
def get_geojson(localizacao, tipo_res=:absoluta, resolucao=:mesorregiao)

   uri = URI('http://' + HOST_IBGE_API_LOC + PATH_IBGE_API_LOC + build_parametros_ibge_api_loc(localizacao, tipo_res, resolucao))
	req = Net::HTTP::Get.new(uri)
	req['Accept'] = "application/vnd.geo+json"

	res = Net::HTTP.start(uri.hostname, uri.port) {|http|
	  http.request(req)
	}

	if res.class == Net::HTTPOK then
	   return res.body
	else
		# deve retornar uma excecao!
		return ""
	end
end
