require 'digest'
require 'net/http'
require 'open-uri'
require 'logger'

ROOT_DIR_CACHE="/tmp"


def get_cached_file(resource_http, data_type=nil)
   uri_completa = URI.parse(resource_http)
   md5 = Digest::MD5.new
   md5 << resource_http.to_s
   if data_type then
     md5 << data_type.to_s
   end
   cache_file_name = uri_completa.host.to_s + "/" + md5.hexdigest.to_s
   return cache_file_name
end

#
# Parameters:
# - request_parameters: parametros a serem utilizados na requisicao (i.e. "Accept")
# - timeout: timeout de leitura em segundos (default 5s)
# - logger: logger a ser utilizado
# - root_dir_cache: diretorio raiz de cache de respostas
def get_remote_resource(resource_http, request_parameters={}, timeout=5, logger=nil)

  root_dir_cache=ROOT_DIR_CACHE

  if !logger then
    logger = Logger.new(STDOUT)
  end

  inicio = Time.now
  response = {:cached => true, :http_response => Net::HTTPOK, :data => nil, :meta_response => nil}

  logger.debug("Recuperando " + resource_http.to_s)

  cache = root_dir_cache + "/" + get_cached_file(resource_http)

  if File.exist?(cache) then
    logger.debug("Recurso " + resource_http.to_s + " em cache: " + cache.to_s)
    response[:body] = File.read(cache)
  else
    if resource_http.start_with?("https://") then
       remote_response = open(resource_http, 'r')
    else
       remote_response = open(resource_http, request_parameters)
    end
    response[:meta_response] = remote_response.meta
    response[:body] = remote_response.read()

    dir_file_cache = cache[0..cache.rindex("/")]
    if !File.exist?(dir_file_cache) then
      Dir.mkdir dir_file_cache
    end

    File.open(cache, "w") { |file|
      file.write(response[:body])
      logger.debug("Novo cache recurso " + resource_http.to_s + " em: " + cache.to_s)
    }
  end

  logger.debug "Recurso " + resource_http.to_s + " recuperado em " + ("%.4f" % (Time.now - inicio)) + " s"
  return response

end
