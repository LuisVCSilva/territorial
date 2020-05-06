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
# territorial/rails/app/models/places/location_model.rb
#

class Macroregiao
   def initialize(id, nome, estados=[])
      @id = id
      @nome = nome
      @estados = estados
      @@macroregioes << self
   end

   @@macroregioes = []

   def self.macroregioes
      @@macroregioes
   end

   def <<(estado)
      @estados << estado
   end

   def municipios
      cidades = []
      @estados.each { |e| cidades += e.municipios}
      return cidades
   end

   attr_accessor :id, :nome

   def estados
      @estados
   end

   def dentro_brasil?
      @nome != "Exterior"
   end

   def exterior?; @nome == "Exterior"; end

   def to_s
      @nome
	end
end

class Estado
   def initialize(id, nome, macroregiao, mesorregioes=[])
		@id = id
      @nome = nome
		@macroregiao = macroregiao
      @macroregiao << self
      @mesorregioes = mesorregioes
      @@estados << self
   end

   @@estados = []

   def <<(mesorregiao)
      @mesorregioes << mesorregiao
	end

   def municipios
      cidades = []
      @mesorregioes.each { |m| cidades += m.municipios}
      return cidades
   end

	attr_accessor :id, :nome

   def mesorregioes
      @mesorregioes
   end

	def macroregiao
   	@macroregiao
	end

   def self.estados
      @@estados
   end


   # issue: corrigir, pois nao esta recebendo sigla
	def sigla; @nome; end

   def to_s
      @nome
	end
end

class Mesorregiao
   #
   # - id_rel : id relativo da mesorregiao (dentro do estado)
	def initialize(id_rel, nome, estado, microrregioes=[])
      # id unico e composicao de id do estado (que eh unico com id relativo com 2 digitos)
		@id = "%s%02d" % [estado.id, id_rel.to_i]
      @id_rel = id_rel
      @nome = nome
		@estado = estado
		@estado << self
		@microrregioes = microrregioes
		@@mesorregioes << self
   end

	@@mesorregioes = []

	def <<(microrregiao)
		@microrregioes << microrregiao
	end

   def municipios
      cidades = []
      @microrregioes.each { |m| cidades += m.municipios }
      return cidades
   end

	attr_accessor :id, :id_rel
	def nome; @nome; end
	def microrregioes; @microrregioes; end
   def estado; @estado; end

   def self.mesorregioes
      @@mesorregioes
   end

   def to_s
      @nome
	end
end

class Microrregiao
	def initialize(id_rel, nome, mesorregiao, municipios=[])
      # id unico e composicao de id do estado (que eh unico com id relativo com 3 digitos)
		@id = "%s%03d" % [mesorregiao.estado.id, id_rel.to_i]
      @id_rel = id_rel
      @nome = nome
		@mesorregiao = mesorregiao
		@mesorregiao << self
		@municipios = municipios
		@@microrregioes << self
   end

	def <<(municipio)
		@municipios << municipio
	end

   @@microrregioes = []

	attr_accessor :id, :id_rel
	def nome; @nome; end
	def municipios; @municipios; end
	def mesorregiao; @mesorregiao; end

   def self.microrregioes
      @@microrregioes
   end

   def to_s
      @nome
	end
end

class Municipio

   def initialize(cod_ibge, cod_tse, nome, microrregiao)
      @nome = nome
		@estado = microrregiao.mesorregiao.estado
		@microrregiao = microrregiao
		@cod_tse = cod_tse
		@cod_ibge = cod_ibge
		@microrregiao << self
		@@municipios << self
	end

	@@municipios = []

	def id; @cod_ibge; end
	def nome; @nome; end
	def estado; @estado; end

	def nome_unico
		to_nome_unico(@nome.upcase, @estado.sigla)
   end

   def Municipio.to_nome_unico(nome, sigla_estado)
      return nome.upcase + "/" + sigla_estado
   end

	def microrregiao; @microrregiao; end
	def cod_tse; @cod_tse; end
	def cod_ibge; @cod_ibge; end
	def self.municipios; @@municipios; end

   def to_s
      @nome + " / " + @estado.sigla
	end

end
