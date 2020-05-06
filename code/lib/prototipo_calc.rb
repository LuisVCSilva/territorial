=begin
*******************************************************************************
Este código deve ser considerado como deprecated. A sua funcionalidade
foi migrada para a área da aplicação Rails (territorial/rails) e quaisquer
modificações devem ser feita naquela localização.

Excepcionalmente, modificações podem ser realizadas para motivos de teste local,
mas sem que sejam incorporados no git. Considere também que o código abaixo
pode ter sofrido alterações na sua migração para Rails.

Localização atual deste código:
não incorporado
*******************************************************************************
=end

require_relative("InterfaceDados")

def convert_to_i(str)
  begin
    Integer(str)
  rescue ArgumentError
    nil
  end
end

totalVotosEleicao = 11455
qtdeVagas = 11

totalVotosPartido = 6246

quocienteEleitoral = totalVotosEleicao/qtdeVagas
quocientePartido = (totalVotosPartido/quocienteEleitoral).floor

puts "Quociente eleitoral: " + quocienteEleitoral.to_s
puts "Quociente Partidario: " + quocientePartido.to_s
sobra = totalVotosPartido/(quocientePartido+1)
puts sobra.to_s

'''
x = InterfaceDados.pesquisa_votacao(localizacao="GO",cargo="6",ano="2014")

totalVotosEleicao = 0
x.each { |a| totalVotosEleicao += convert_to_i(a.qtde_votos)}
puts totalVotosEleicao.to_s
puts x
'''
