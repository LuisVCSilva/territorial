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

# Armazena um partido (nome, sigla, número)

class Partido

attr_accessor :nome, :sigla, :numero, :quociente_eleitoral, :quociente_partidario ,:qtde_votos, :sobras

  def initialize params = {}
    params.each { |key, value| send "#{key}=", value }
	quocientePartido = (qtde_votos/quociente_eleitoral).floor
	sobras = qtde_votos/(quociente_partidario)
	@initialized = true
  end

  def initialized?
    @initialized || false
  end

  def to_s ()
	self.inspect
  end
end
