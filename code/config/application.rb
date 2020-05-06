=begin
*******************************************************************************
Este código deve ser considerado como deprecated. A sua funcionalidade
foi migrada para a área da aplicação Rails (territorial/rails) e quaisquer
modificações devem ser feita naquela localização.

Excepcionalmente, modificações podem ser realizadas para motivos de teste local,
mas sem que sejam incorporados no git. Considere também que o código abaixo
pode ter sofrido alterações na sua migração para Rails.

Localização atual deste código:
sem uso
*******************************************************************************
=end

# **ATENCAO**
# deprecated: Nao e mais usado na aplicacao Rails
# no seu lugar, usando o logger do Rails.
#

require 'logger'

FOLDER_LOG = "../log/"
DEVELOPMENT_LOG = "development.log"

LOGGER = Logger.new(FOLDER_LOG + DEVELOPMENT_LOG)

=begin
LOGGER.formatter = proc do |serverity, time, progname, msg|
  serverity.to_s + time.to_s +  progname.to_s + msg.to_s
end
=end
