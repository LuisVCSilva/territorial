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

# Armazena os dados de um candidato, indicando ano e local à que a candidatura
# se aplica, assim como a validade da candidatura.

class Candidato
  attr_accessor :ano, :local, :nome, :id, :partido, :isCandidaturaValida

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
