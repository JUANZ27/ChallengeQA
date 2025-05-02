@FEATURE_PARTNER_REMITTANCE_ORDER_POST
Feature:
  Como usuario del servicio de remittance
  Quiero ejecutar el API PV partner-remittance-order endpoint remittance-orders
  Para registrar remesa

  Background:
    Given url baseApiPv
    * def GetTokenCasRemi = callonce read('classpath:token/GetTokenCasRemi.feature')
    * def headers = read('classpath:req/headers/Nrem/PvNremRegistro.json')
    * string schema = read('classpath:schema/Nrem/PvNrem.json')
    * def body = read('classpath:req/bodies/Nrem/Pv.json')
    * def SchemaUtils = Java.type('util.SchemaUtils')
    * set headers.Authorization = GetTokenCasRemi.tokenCas
    * configure headers = headers
    * configure ssl = { trustAll: true}
    * configure ssl = { keyStore: 'classpath:util/partner.pfx', keyStorePassword: 'CkECSOhMNkeG22', keyStoreType: 'pkcs12' }
    * configure ssl = { keyStore: 'classpath:util/partnerCert.pfx', keyStorePassword: 'lxlDkYj6xrM0yx', keyStoreType: 'pkcs12' }

  @POST_REMITTANCE_ORDERS_S001
  Scenario Outline:NREM - Registrar operacion OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.referenceId = "<id_referencia>"
    And request body
    When method post
    Then status 204
    And match karate.response.status == 204
    * string response = ""
    * print  response
    Examples:
      | caso_prueba                                            | id_referencia    |
      | Enviar una solicitud POST con un solo caracter         | A                |
      | Enviar una solicitud POST con longitud minima          | a1               |
      | Enviar una solicitud POST con longitud maxima          | 1234567890123456 |
      | Enviar una solicitud POST con longitud esperada        | 12_USA           |
      | Enviar una solicitud POST con caracteres alfanumericos | AUANbc1          |
      | Enviar una solicitud POST con caracteres en mayusculas | USA              |
      | Enviar una solicitud POST con caracteres en minuscula  | usa              |

  @POST_REMITTANCE_ORDERS_S002
  Scenario Outline:NREM - Registrar operacion OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.referenceId = "<id_referencia>"
    And request body
    When method post
    Then status 204
    And match karate.response.status == 204
    * string response = ""
    * print  response
    Examples:
      | caso_prueba                                            | id_referencia    |
      | Enviar una solicitud POST con un solo caracter         | A                |
      | Enviar una solicitud POST con longitud minima          | a1               |
      | Enviar una solicitud POST con longitud maxima          | 1234567890123456 |
      | Enviar una solicitud POST con longitud esperada        | 12_USA           |
      | Enviar una solicitud POST con caracteres alfanumericos | AUANbc1          |
      | Enviar una solicitud POST con caracteres en mayusculas | USA              |
      | Enviar una solicitud POST con caracteres en minuscula  | usa              |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con nombre_remitente nulo NO-OK
    * set body.sender.fullName = "<nombre_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 204
    And match karate.response.status == 204
    * string response = ""
    * print  response
    Examples:
      | caso_prueba                                           | nombre_remitente                    |
      | Enviar una solicitud POST con nombre un solo caracter | A                                   |
      | Enviar una solicitud POST con longitud minima         | Al                                  |
      | Enviar una solicitud POST con longitud maxima         | Janice Keihanaikukauakahihuliheekah |
      | Enviar una solicitud POST con caracteres alfabeticos  | Abc Def                             |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con referenceId ya registrada NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    * set body.referenceId = "<id_referencia>"
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, registro ya existente"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E001"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La referencia Id ya se encuentra registrada."
    Examples:
      | caso_prueba                                              | id_referencia  |
      | Enviar una solicitud POST registrado con formato         | 131141f4124122 |
      | Enviar una solicitud POST registrado con longitud minima | 1              |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con referenceId de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.referenceId = "<id_referencia>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La referencia Id no cumple con la longitud requerida max 16 y min 1."
    Examples:
      | caso_prueba                                                 | id_referencia         |
      | Enviar una solicitud POST con longitud vacia                |                       |
      | Enviar una solicitud POST con longitud maxima 17 caracteres | 12345678901234567     |
      | Enviar una solicitud POST con longitud maxima 20 caracteres | 123456789012345674566 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con referenceId de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.referenceId = "<id_referencia>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La referencia Id no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | id_referencia |
      | Enviar una solicitud POST caracteres especiales  | A11°@á\t      |
      | Enviar una solicitud POST con espacio y slash    | A_US /        |
      | Enviar una solicitud POST con tilde              | A_ÚS          |
      | Enviar una solicitud POST con espacios           | a 1 2         |
      | Enviar una solicitud POST con espacios al inicio | ' A123'       |
      | Enviar una solicitud POST con espacios al fin    | 'A123 '       |
      | Enviar una solicitud POST con un espacio         | ' '           |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con referenceId null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.referenceId = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La referencia Id no puede ser nulo o vacio."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con registerDate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.registerDate = "<fecha_registro>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La fecha de registro no cumple con la longitud requerida max 19 y min 1."
    Examples:
      | caso_prueba                                                 | fecha_registro       |
      | Enviar una solicitud POST con longitud vacia                |                      |
      | Enviar una solicitud POST con longitud maxima 20 caracteres | 2021-02-19 12:03:101 |
      | Enviar una solicitud POST con espacios                      | 2021-02-19 a 1 2     |
      | Enviar una solicitud POST con espacios al inicio            | ' 2021-02-19 A123'   |
      | Enviar una solicitud POST con espacios al fin               | '2021-02-19 A123 '   |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con referenceId de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.registerDate = "<fecha_registro>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La fecha de registro no cumple con el formato correcto."
    Examples:
      | caso_prueba                                     | fecha_registro      |
      | Enviar una solicitud POST caracteres especiales | 2021-02-19 A11°@á\t |
      | Enviar una solicitud POST con espacio y slash   | 2021-02-19 A_US /   |
      | Enviar una solicitud POST con tilde             | 2021-02-19 A_ÚS     |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con referenceId null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.registerDate = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La fecha de registro no puede ser nulo o vacio."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con amount de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amount = <monto>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto no puede ser igual a cero (0.00) o menor."
    Examples:
      | caso_prueba                                    | monto |
      | Enviar una solicitud POST sin decimal          | 0     |
      | Enviar una solicitud POST con decimal de 0     | 0.00  |
      | Enviar una solicitud POST con decimal negativo | -0    |
      | Enviar una solicitud POST con decimal negativo | -0.01 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con amount de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amount = <monto>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto no puede ser mayor a 10000 dolares"
    Examples:
      | caso_prueba                                      | monto      |
      | Enviar una solicitud POST con longitud incorecta | 9999999    |
      | Enviar una solicitud POST con longitud incorecta | 9999999.00 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con amount de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amount = <monto>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto no cumple con el formato correcto."
    Examples:
      | caso_prueba                                     | monto     |
      | Enviar una solicitud POST caracteres especiales | 1A11°@á\t |
      | Enviar una solicitud POST con espacio y slash   | 1A_US /   |
      | Enviar una solicitud POST con tilde             | 1A_ÚS     |
      | Enviar una solicitud POST con espacios          | 1a 1 2    |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con amount null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amount = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto de la remesa no puede ser nulo o vacio."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con amountPen de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amountPen = <monto_soles>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto en soles de la remesa no puede ser cero o menor."
    Examples:
      | caso_prueba                                    | monto_soles |
      | Enviar una solicitud POST sin decimal          | 0           |
      | Enviar una solicitud POST con decimal de 0     | 0.00        |
      | Enviar una solicitud POST con decimal negativo | -0          |
      | Enviar una solicitud POST con decimal negativo | -0.01       |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con amountPen de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amountPen = <monto_soles>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto en soles de la remesa no puede ser mayor a 10000 dolares"
    Examples:
      | caso_prueba                                      | monto_soles |
      | Enviar una solicitud POST con longitud incorecta | 9999999     |
      | Enviar una solicitud POST con longitud incorecta | 9999999.00  |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con amountPen de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amountPen = <monto_soles>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto en soles de la remesa no cumple con el formato correcto."
    Examples:
      | caso_prueba                                     | monto_soles |
      | Enviar una solicitud POST caracteres especiales | 1A11°@á\t   |
      | Enviar una solicitud POST con espacio y slash   | 1A_US /     |
      | Enviar una solicitud POST con tilde             | 1A_ÚS       |
      | Enviar una solicitud POST con espacios          | 1a 1 2      |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con exchangeRate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = 3.918
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La tasa de cambio no coincide con la tasa de cambio actual"

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con exchangeRate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = <tipo_cambio>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La tasa de cambio no puede ser igual a cero (0.00) o menor."
    Examples:
      | caso_prueba                                    | tipo_cambio |
      | Enviar una solicitud POST sin decimal          | 0           |
      | Enviar una solicitud POST con decimal de 0     | 0.00        |
      | Enviar una solicitud POST con decimal negativo | -0          |
      | Enviar una solicitud POST con decimal negativo | -0.01       |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con exchangeRate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = <tipo_cambio>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La tasa de cambio no puede ser mayor a 10000 dolares"
    Examples:
      | caso_prueba                                      | tipo_cambio |
      | Enviar una solicitud POST con longitud incorecta | 9999999     |
      | Enviar una solicitud POST con longitud incorecta | 9999999.00  |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con exchangeRate de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = <tipo_cambio>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La tasa de cambio no cumple con el formato correcto."
    Examples:
      | caso_prueba                                     | tipo_cambio |
      | Enviar una solicitud POST caracteres especiales | 1A11°@á\t   |
      | Enviar una solicitud POST con espacio y slash   | 1A_US /     |
      | Enviar una solicitud POST con tilde             | 1A_ÚS       |
      | Enviar una solicitud POST con espacios          | 1a 1 2      |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con description de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.description = "<descripcion>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo description no cumple con la longitud requerida max 35."
    Examples:
      | caso_prueba                                                 | descripcion                       |
      | Enviar una solicitud POST con longitud vacia                |                                   |
      | Enviar una solicitud POST con longitud maxima 17 caracteres | PAGADOR BANCO DE CREDITO DEL PERU |
      | Enviar una solicitud POST con longitud maxima 20 caracteres | 123456789012345674566             |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con description de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.description = "<descripcion>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo description no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | descripcion |
      | Enviar una solicitud POST caracteres especiales  | A11°@á\t    |
      | Enviar una solicitud POST con espacio y slash    | A_US /      |
      | Enviar una solicitud POST con tilde              | A_ÚS        |
      | Enviar una solicitud POST con espacios           | a 1 2       |
      | Enviar una solicitud POST con espacios al inicio | ' A123'     |
      | Enviar una solicitud POST con espacios al fin    | 'A123 '     |
      | Enviar una solicitud POST con un espacio         | ' '         |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con merchantId que no existe NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.merchant.merchantId = "<id_comercio>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El merchant Id no existe."
    Examples:
      | caso_prueba                                      | id_comercio |
      | Enviar una solicitud POST registrado con formato | AFEXCLRM*R0 |
      | Enviar una solicitud POST registrado con formato | AFEXCLRM*RA |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con merchantId de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.merchant.merchantId = "<id_comercio>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El merchant Id no cumple con la longitud requerida max 11 y min 1."
    Examples:
      | caso_prueba                                                 | id_comercio      |
      | Enviar una solicitud POST con longitud vacia                |                  |
      | Enviar una solicitud POST con longitud maxima 12 caracteres | AFEXCLRM*R12     |
      | Enviar una solicitud POST con longitud maxima 15 caracteres | AFEXCLRM*R012345 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con merchantId de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.merchant.merchantId = "<id_comercio>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El merchant Id no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | id_comercio |
      | Enviar una solicitud POST caracteres especiales  | A11°@á\t    |
      | Enviar una solicitud POST con espacio y slash    | A_US /      |
      | Enviar una solicitud POST con tilde              | A_ÚS        |
      | Enviar una solicitud POST con espacios           | a 1 2       |
      | Enviar una solicitud POST con espacios al inicio | ' A123'     |
      | Enviar una solicitud POST con espacios al fin    | 'A123 '     |
      | Enviar una solicitud POST con un espacio         | ' '         |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con merchantId null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.merchant.merchantId = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El merchant Id no puede ser nulo o vacio."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_moneda que no existe NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.currency.code = "<codigo_moneda>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El tipo de moneda no existe o no se encuentra registrado."
    Examples:
      | caso_prueba                                      | codigo_moneda |
      | Enviar una solicitud POST registrado con formato | USE         |
      | Enviar una solicitud POST registrado con formato | USI         |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_moneda de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.currency.code = "<codigo_moneda>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El código de la moneda debe estar compuesto por 3 caracteres."
    Examples:
      | caso_prueba                                                 | codigo_moneda |
      | Enviar una solicitud POST con longitud vacia                |               |
      | Enviar una solicitud POST con longitud maxima 12 caracteres | U             |
      | Enviar una solicitud POST con longitud maxima 15 caracteres | US            |
      | Enviar una solicitud POST con un espacio                    | ' '           |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_moneda de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.currency.code = "<codigo_moneda>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo de la moneda no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | codigo_moneda |
      | Enviar una solicitud POST caracteres especiales  | U°t           |
      | Enviar una solicitud POST con espacio y slash    | US/           |
      | Enviar una solicitud POST con tilde              | ÚSA           |
      | Enviar una solicitud POST con espacios           | U A           |
      | Enviar una solicitud POST con espacios al inicio | ' SD'         |
      | Enviar una solicitud POST con espacios al fin    | 'US '         |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con codigo_moneda null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.currency.code = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains ""Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo de la moneda no puede ser nulo o vacio."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con id_remitente de longitud incorrecta NO-OK
    * set body.sender.senderId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El remitente Id no cumple con la longitud requerida max 35 y min 1."
    Examples:
      | caso_prueba                                                 | id_remitente                           |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | 78784845100112345678954212365897456    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | 78784845100112345678954212365897456312 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:[NREM][Partner] - Registrar operacion con id_remitente de formato incorrecto NO-OK
    * set body.sender.senderId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor con formato invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El remitente Id no cumple con el siguiente formato: numDoc+tipoDoc+codCorrelativo."
    Examples:
      | caso_prueba                                      | id_remitente   |
      | Enviar una solicitud POST caracteres especiales  | 787848451°     |
      | Enviar una solicitud POST con espacio y slash    | 787848451/     |
      | Enviar una solicitud POST con tilde              | 787848451á     |
      | Enviar una solicitud POST con espacios           | 7878484 1 1    |
      | Enviar una solicitud POST con espacios al inicio | ' 87848451001' |
      | Enviar una solicitud POST con espacios al fin    | '78784845100 ' |
      | Enviar una solicitud POST con espacio            | ' '            |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con id_remitente nulo NO-OK
    * set body.sender.senderId = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El remitente Id no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con nombre_remitente de longitud incorrecta NO-OK
    * set body.sender.fullName = "<nombre_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no cumple con la longitud requerida max 35 y min 1."
    Examples:
      | caso_prueba                                                 | nombre_remitente                        |
      | Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | Janice Keihanaikukauakahihuliheekaha    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Janice Keihanaikukauakahihuliheekahabcd |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:[NREM][Partner] - Registrar operacion con nombre_remitente de formato incorrecto NO-OK
    * set body.sender.fullName = "<nombre_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no cumple cel formato correcto"
    Examples:
      | caso_prueba                                      | nombre_remitente |
      | Enviar una solicitud POST caracteres especiales  | 787848451°       |
      | Enviar una solicitud POST con espacio y slash    | 787848451/       |
      | Enviar una solicitud POST con tilde              | 787848451á       |
      | Enviar una solicitud POST con espacios           | 7878484 1 1      |
      | Enviar una solicitud POST con espacios al inicio | ' 87848451001'   |
      | Enviar una solicitud POST con espacios al fin    | '78784845100 '   |
      | Enviar una solicitud POST con espacio            | ' '              |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con nombre_remitente nulo NO-OK
    * set body.sender.fullName = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con direccion_remitente de longitud incorrecta NO-OK
    * set body.sender.address.summary = "<direccion_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo summary del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | direccion_remitente                    |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | AV LOS PROCERES 345 CUADRA 1 MANZAN    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | AV LOS PROCERES 345 CUADRA 1 MANZANA 1 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:[NREM][Partner] - Registrar operacion con direccion_remitente de formato incorrecto NO-OK
    * set body.sender.address.summary = "<direccion_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo summary del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | direccion_remitente   |
      | Enviar una solicitud POST caracteres especiales  | AV LOS PROCERES 3°    |
      | Enviar una solicitud POST con espacio y slash    | AV LOS PROCERES 3/    |
      | Enviar una solicitud POST con tilde              | AV LOS PROCERES 3     |
      | Enviar una solicitud POST con espacios           | AV LOS PROCERES 3 1 1 |
      | Enviar una solicitud POST con espacios al inicio | ' AV LOS PROCERES 3'  |
      | Enviar una solicitud POST con espacios al fin    | 'AV LOS PROCERES 3 '  |
      | Enviar una solicitud POST con espacio            | ' '                   |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con n_cel_remitente de longitud incorrecta NO-OK
    * set body.sender.address.phoneNumber = "<n_cel_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El numero de celular del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | n_cel_remitente                        |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | +9234567897894561234567894561236547    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | +9234567897894561234567894561236547896 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con n_cel_remitente de formato incorrecto NO-OK
    * set body.sender.address.phoneNumber = "<n_cel_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El numero de celular del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | n_cel_remitente |
      | Enviar una solicitud POST caracteres especiales  | +013132000°     |
      | Enviar una solicitud POST con espacio y slash    | +013132000/     |
      | Enviar una solicitud POST con tilde              | +01313200Ó 3    |
      | Enviar una solicitud POST con espacios           | +013132000 1 1  |
      | Enviar una solicitud POST con espacios al inicio | ' +013132000'   |
      | Enviar una solicitud POST con espacios al fin    | '+013132000 '   |
      | Enviar una solicitud POST con espacio            | ' '             |


  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con provincia_remitente de longitud incorrecta NO-OK
    * set body.sender.address.geolocation.province.description = "<provincia_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción de la provincia del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | provincia_remitente                    |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | MICHIGAN DE LA AVENIDA JOSE MARIA C    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | MICHIGAN DE LA AVENIDA JOSE MARIA CORT |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con provincia_remitente de formato incorrecto NO-OK
    * set body.sender.address.geolocation.province.description = "<provincia_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción de la provincia del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | provincia_remitente |
      | Enviar una solicitud POST caracteres especiales  | MICHIGAN°           |
      | Enviar una solicitud POST con espacio y slash    | MICHIGAN /          |
      | Enviar una solicitud POST con tilde              | MICHIGAN            |
      | Enviar una solicitud POST con espacios           | MICHIGAN A A        |
      | Enviar una solicitud POST con espacios al inicio | ' MICHIGAN'         |
      | Enviar una solicitud POST con espacios al fin    | 'MICHIGAN '         |
      | Enviar una solicitud POST con espacio            | ' '                 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_ciudad_remitente no registrado NO-OK
    * set body.sender.address.geolocation.country.code = "<codigo_ciudad_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El código de país del remitente no existe o no se encuentra registrado. "
    Examples:
      | caso_prueba                           | codigo_ciudad_remitente |
      | Enviar una solicitud POST con formato | USI                     |
      | Enviar una solicitud POST con formato | USO                     |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_ciudad_remitente de longitud incorrecta NO-OK
    * set body.sender.address.geolocation.country.code = "<codigo_ciudad_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del remitente debe estar compuesto por 3 caracteres."
    Examples:
      | caso_prueba                                  | codigo_ciudad_remitente |
      | Enviar una solicitud POST con longitud vacia |                         |
      | Enviar una solicitud POST con formato        | U                       |
      | Enviar una solicitud POST con formato        | US                      |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_ciudad_remitente de formato incorrecto NO-OK
    * set body.sender.address.geolocation.province.description = "<codigo_ciudad_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del remitente no cumple el formato correcto."
    Examples:
      | caso_prueba                                      | codigo_ciudad_remitente |
      | Enviar una solicitud POST caracteres especiales  | U°                      |
      | Enviar una solicitud POST con espacio y slash    | U /                     |
      | Enviar una solicitud POST con tilde              | USÁ                     |
      | Enviar una solicitud POST con espacios           | U A                     |
      | Enviar una solicitud POST con espacios al inicio | ' SA'                   |
      | Enviar una solicitud POST con espacios al fin    | 'US '                   |
      | Enviar una solicitud POST con espacio            | ' '                     |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con codigo_ciudad_remitente null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.sender.address.geolocation.province.description = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del remitente no puede ser nulo o vacío."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con ciudad_remitente de longitud incorrecta NO-OK
    * set body.sender.address.geolocation.country.description = "<ciudad_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción del país del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | ciudad_remitente                       |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | PORTLAND DE LA AVENIDA JOSE MARIA C    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | PORTLAND DE LA AVENIDA JOSE MARIA CORT |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con ciudad_remitente de formato incorrecto NO-OK
    * set body.sender.address.geolocation.country.description = "<ciudad_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción del pais del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | ciudad_remitente |
      | Enviar una solicitud POST caracteres especiales  | PORTLAND°        |
      | Enviar una solicitud POST con espacio y slash    | PORTLAND /       |
      | Enviar una solicitud POST con tilde              | PORTLÁND         |
      | Enviar una solicitud POST con espacios           | PORTLAND A A     |
      | Enviar una solicitud POST con espacios al inicio | ' PORTLAND'      |
      | Enviar una solicitud POST con espacios al fin    | 'PORTLAND '      |
      | Enviar una solicitud POST con espacio            | ' '              |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con celular_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[0].value = "<celular_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del CELULAR del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | celular_remitente                      |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | +9234567897894561234567894561236547    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | +9234567897894561234567894561236547896 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con celular_remitente de formato incorrecto NO-OK
    * set body.sender.contactAddresses[0].value = "<celular_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del CELULAR del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | celular_remitente |
      | Enviar una solicitud POST caracteres especiales  | +105927668437°    |
      | Enviar una solicitud POST con espacio y slash    | +105927668437 /   |
      | Enviar una solicitud POST con tilde              | +105927668437     |
      | Enviar una solicitud POST con espacios           | +105927668437 A A |
      | Enviar una solicitud POST con espacios al inicio | ' +105927668437'  |
      | Enviar una solicitud POST con espacios al fin    | '+105927668437 '  |
      | Enviar una solicitud POST con espacio            | ' '               |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con cod_contacto_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[0].addressType.code = "<cod_contacto_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del remitente no cumple con la longitud requerida max 7 min 5."
    Examples:
      | caso_prueba                                                 | cod_contacto_remitente |
      | Enviar una solicitud POST con longitud vacia                |                        |
      | Enviar una solicitud POST con longitud maxima 8 caracteres  | CELULAR                |
      | Enviar una solicitud POST con longitud maxima 10 caracteres | CELULARESS             |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con cod_contacto_remitente de formato incorrecto NO-OK
    * set body.sender.contactAddresses[0].addressType.code = "<cod_contacto_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del remitente debe tener como valor CELULAR o EMAIL."
    Examples:
      | caso_prueba                                      | cod_contacto_remitente |
      | Enviar una solicitud POST caracteres especiales  | CELULA°                |
      | Enviar una solicitud POST con espacio y slash    | CELUL /                |
      | Enviar una solicitud POST con tilde              | CELULÁR                |
      | Enviar una solicitud POST con espacios           | CEL A A                |
      | Enviar una solicitud POST con espacios al inicio | ' CELULA'              |
      | Enviar una solicitud POST con espacios al fin    | 'CELULA '              |
      | Enviar una solicitud POST con espacio            | ' '                    |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con cod_contacto_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[0].addressType.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del remitente no puede ser nulo o vacío."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con correo_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El email del remitente no cumple con el formato valido."
    Examples:
      | caso_prueba                                  | correo_remitente   |
      | Enviar una solicitud POST con longitud vacia |                    |
      | Enviar una solicitud POST sin formato        | A                  |
      | Enviar una solicitud POST sin formato        | CORREO_REMITENTE.C |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con correo_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del EMAIL del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | correo_remitente                       |
      | Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | JOSE@DELAAVENIDAJOSEMARIACORTEZ.COM    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | JOSE@DELAAVENIDAJOSEMARIACORTEZASS.COM |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con correo_remitente de formato incorrecto NO-OK
    * set body.sender.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del EMAIL del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | correo_remitente       |
      | Enviar una solicitud POST caracteres especiales  | ALX.AA@OUTLOOK.cOM°    |
      | Enviar una solicitud POST con espacio y slash    | ALX.AA@OUTLOOK.cOM /   |
      | Enviar una solicitud POST con tilde              | ÁLX.AA@OUTLOOK.cOM     |
      | Enviar una solicitud POST con espacios           | ALX.AA@OUTLOOK.cOM A A |
      | Enviar una solicitud POST con espacios al inicio | ' ALX.AA@OUTLOOK.cOM'  |
      | Enviar una solicitud POST con espacios al fin    | 'ALX.AA@OUTLOOK.cOM '  |
      | Enviar una solicitud POST con espacio            | ' '                    |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con cod_contacto_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].addressType.code = "<cod_contacto_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del remitente no cumple con la longitud requerida max 7 min 5."
    Examples:
      | caso_prueba                                                 | cod_contacto_remitente |
      | Enviar una solicitud POST con longitud vacia                |                        |
      | Enviar una solicitud POST con longitud maxima 8 caracteres  | EMAILESS               |
      | Enviar una solicitud POST con longitud maxima 10 caracteres | EMAILESSSS             |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con cod_contacto_remitente de formato incorrecto NO-OK
    * set body.sender.contactAddresses[1].addressType.code = "<cod_contacto_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del remitente debe tener como valor CELULAR o EMAIL."
    Examples:
      | caso_prueba                                      | cod_contacto_remitente |
      | Enviar una solicitud POST caracteres especiales  | EMAIL°                 |
      | Enviar una solicitud POST con espacio y slash    | EMAIL /                |
      | Enviar una solicitud POST con tilde              | ÉMAIL                  |
      | Enviar una solicitud POST con espacios           | EM A A                 |
      | Enviar una solicitud POST con espacios al inicio | ' EMAIL'               |
      | Enviar una solicitud POST con espacios al fin    | 'EMAIL '               |
      | Enviar una solicitud POST con espacio            | ' '                    |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con cod_contacto_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].addressType.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del remitente no puede ser nulo o vacío."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con id_remitente de longitud incorrecta NO-OK
    * set body.sender.beneficiaryId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | id_remitente                            |
      | Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 37 caracteres | Janice Keihanaikukauakahihuliheekaha    |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Janice Keihanaikukauakahihuliheekahabcd |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:[NREM][Partner] - Registrar operacion con id_remitente de formato incorrecto NO-OK
    * set body.sender.beneficiaryId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | id_remitente |
      | Enviar una solicitud POST caracteres especiales  | Abc°@á\t     |
      | Enviar una solicitud POST con espacios           | a b c        |
      | Enviar una solicitud POST con espacios al inicio | ' Abcd'       |
      | Enviar una solicitud POST con espacios al fin    | 'Juan '        |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con id_remitente nulo NO-OK
    * set body.sender.beneficiaryId = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no puede ser nulo."

