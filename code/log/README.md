# Log da aplicação

Enquanto a aplicação não migra para o Rails, os logs ficarão aqui. Fique livre para criar os logs que
achar importante, desde que eles não sejam introduzidos em controle de versão (edite `.csvignore`).

O log deve ser criado especialmente para **TODAS** as consultas feitas para bases externas (CEPESP, IBGE, ...) e tratar ocorrência de exceções.
A configuração do log está em `config/application.rb`.

Todos os código precisarão de `require '../config/application.rb'` e há um exemplo - tanto de log como de tratamento de exceção em `lib/busca_indicadores_local.rb`, indicado abaixo.

```ruby
LOGGER.debug("GET " + url)
begin
   content = open(url).read()
rescue => e
   LOGGER.error(e.message.to_s + " - " + e.backtrace.to_s)
   raise e
end
```
