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

# Armazena os dados de uma legenda, indicando o contexto eleitoral em que ela se
# aplica.

class Legenda

attr_accessor :ano_eleicao, :num_turno, :descricao_eleicao, :sigla_uf, :sigla_ue, :descricao_ue, :cargo, :tipo_legenda,:sigla_coligacao, :nome_coligacao,:composicao_coligacao

  def initialize params = {}
    params.each { |key, value| send "#{key}=", value }
	@initialized = true
  end

  def initialized?
    @initialized || false
  end

  def to_s ()
	self.inspect
  end


end
