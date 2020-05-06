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

# Classe "Votacao" armazena o conjunto de votos associado a um certo contexto
# (por exemplo, localização e ano), permitindo recuperar a votação por partido
# e os votos nulos e brancos quando se tratar de um conjunto de votos (e não
# um voto unitário de um candidato).

class Votacao

attr_accessor :ano_eleicao ,:sigla_ue ,:num_turno ,:descricao_eleicao ,:cargo, :descricao_cargo, :numero_candidato, :qtde_votos

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
