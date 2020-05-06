# Requisições a Serviços SOA da Solução

Este documento contém algumas requisições SOA via cURL como atalho para realização de testes.

# Locations

```
curl 'http://localhost:3000/locations' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

# Macroregioes

```
curl 'http://localhost:3000/locations/Brasil/macros' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

## Macroregiao Norte

```
curl 'http://localhost:3000/locations/Brasil/macros/1' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

## Estados da Macroregiao Norte

```
curl 'http://localhost:3000/locations/Brasil/macros/1/estados' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

## Mesoregioes do Pará


```
curl 'http://localhost:3000/locations/Brasil/macros/1/estados/15' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

```
curl 'http://localhost:3000/locations/Brasil/macros/1/estados/15/mesos/1506' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

## Microrregioes

```
curl 'http://localhost:3000/locations/Brasil/macros/1/estados/15/mesos/1506/micros' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```

```
curl 'http://localhost:3000/locations/Brasil/macros/1/estados/15/mesos/1506/micros/15018' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```
## Municipios

```
curl 'http://localhost:3000/locations/Brasil/macros/1/estados/15/mesos/1506/micros/15018/municipios/1505437' -H 'Host: localhost:3000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0' -H 'Accept: application/json' -H 'Accept-Language: pt-BR,en;q=0.5' --compressed -H 'Cookie: _territorial_rails_session=NGt1U015aGRDbjBjaThnYXhVdzdDQjhnMDV6RjQ5S0huU1hhMVFkOVI4a1BuS0MreFJ1bWQrT3FGVHFXekRCQ2srTmY3TFVCTklsSDJuYU5PMTFIRVhoS2FOUlpUUWlvcFpMNVIxSjVVMFRXYVJyRks3SXZCcm1hL3dQem9Qa1dDamRMUUtQM05ORWRuc25WeFNXN1JBPT0tLVpndzJwVDNPUmFKY1JLN1pCNHVJaHc9PQ%3D%3D--f562db463e27a07446e3564bbb1d61a4149fc5da' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'If-None-Match: W/"ecd5999063398bf5d81915ddf7d2b043"'
```
