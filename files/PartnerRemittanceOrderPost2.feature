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
    #* configure ssl = { keyStore: 'classpath:util/partnerCert.pfx', keyStorePassword: 'lxlDkYj6xrM0yx', keyStoreType: 'pkcs12' }

#  @POST_REMITTANCE_ORDERS_S001
#  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con id_referencia valido en cash PEN OK
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    * set body.referenceId = "<id_referencia>"
#    * set body.amount = 1
#    * set body.amountPen = 1
#    * set body.exchangeRate = 3.918
#    And request body
#    When method post
#    Then status 204
#    And match karate.response.status == 204
#    * string response = ""
#    * print  response
#    Examples:
#      | caso_prueba                                            | id_referencia    |
#      | Enviar una solicitud POST con un solo caracter         | A                |
#      | Enviar una solicitud POST con longitud minima          | a1               |
#      | Enviar una solicitud POST con longitud maxima          | 9999999999999999 |
#      | Enviar una solicitud POST con longitud esperada        | 12_USA           |
#      | Enviar una solicitud POST con caracteres alfanumericos | AUANbc1          |
#      | Enviar una solicitud POST con caracteres en mayusculas | ASA              |
#      | Enviar una solicitud POST con caracteres en minuscula  | asa              |
#
#  @POST_REMITTANCE_ORDERS_S002 @PREMI-13112
#  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con id_referencia valido en cash USD OK
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    * set body.referenceId = "<id_referencia>"
#    And request body
#    When method post
#    Then status 204
#    And match karate.response.status == 204
#    * string response = ""
#    * print  response
#    Examples:
#      | caso_prueba                                    | id_referencia |
#      | Enviar una solicitud POST con un solo caracter | B             |
#      | Enviar una solicitud POST con longitud minima  | a2            |
#
#  @POST_REMITTANCE_ORDERS_S
#  Scenario Outline:NREM - Registrar operacion con cuenta ahorro y corriente OK
#    * set body.depositInformation.account.accountId = "<cuenta>"
#    * set body.beneficiary.fullName = "<nombre_beneficiario>"
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    And request body
#    When method post
#    Then status 204
#    And match karate.response.status == 204
#    * string response = ""
#    * print  response
#    Examples:
#      | caso_prueba                                            | cuenta         | nombre_beneficiario       |
#      | Enviar una solicitud POST con cuenta corriente soles   | 3903486968089  | CHUTY HERNANDEZ CORRIENTE |
#      | Enviar una solicitud POST con cuenta corriente dolares | 3903486969109  | JAVA PASACHE CORRIENTE    |
#      | Enviar una solicitud POST con cuenta maestra soles     | 39070846055042 | REYZON LUNA AHORROS       |
#      | Enviar una solicitud POST con cuenta maestra dolares   | 39070846056143 | ACRU MARTINEZ AHORROS     |
#
#  @POST_REMITTANCE_ORDERS_S004 @PREMI-13118
#  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con nombre_remitente permitidos NO-OK
#    * set body.sender.fullName = "<nombre_remitente>"
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    And request body
#    When method post
#    Then status 204
#    And match karate.response.status == 204
#    * string response = ""
#    * print  response
#    Examples:
#      | caso_prueba                                           | nombre_remitente                    |
#      | Enviar una solicitud POST con nombre un solo caracter | A                                   |
#      | Enviar una solicitud POST con longitud minima         | Al                                  |
#      | Enviar una solicitud POST con longitud maxima         | Aanice Keihanaikukauakahihuliheekah |
#      | Enviar una solicitud POST con caracteres alfabeticos  | Abc Def                             |

  @POST_REMITTANCE_ORDERS_S005 @PREMI-13123
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con referenceId ya registrada NO-OK
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
      | caso_prueba                                              | id_referencia |
      | Enviar una solicitud POST registrado con formato         | 446655451149  |
      | Enviar una solicitud POST registrado con longitud minima | 1             |

  @POST_REMITTANCE_ORDERS_S006 @PREMI-13120
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con referenceId de longitud incorrecta NO-OK
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

  @POST_REMITTANCE_ORDERS_S007 @PREMI-13130
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con referenceId de formato incorrecto NO-OK
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

  @POST_REMITTANCE_ORDERS_S008 @PREMI-13145
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con referenceId null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.referenceId = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La referencia Id no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S009 @PREMI-13141
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con registerDate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.registerDate = "<fecha_registro>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La fecha de registro no cumple con la longitud requerida max 19 y min 1."
    Examples:
      | caso_prueba                                                 | fecha_registro        |

      | Enviar una solicitud POST con longitud maxima 20 caracteres | 2021-02-19 12:03:101  |
      | Enviar una solicitud POST con espacios                      | 2021-02-19 a 1 2 1233 |

  @POST_REMITTANCE_ORDERS_S010 @PREMI-13135
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con referenceId de formato incorrecto NO-OK
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
      | caso_prueba                                      | fecha_registro      |
      | Enviar una solicitud POST caracteres especiales  | 2021-02-19 A11°@á\t |
      | Enviar una solicitud POST con espacio y slash    | 2021-02-19 A_US /   |
      | Enviar una solicitud POST con tilde              | 2021-02-19 A_ÚS     |
      | Enviar una solicitud POST con espacios al inicio | ' 2021-02-19 A123'  |
      | Enviar una solicitud POST con espacios al fin    | '2021-02-19 A123 '  |

  @POST_REMITTANCE_ORDERS_S011 @PREMI-13145
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con referenceId null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.registerDate = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La fecha de registro no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S012 @PREMI-13125
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con amount de longitud incorrecta NO-OK
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

  @POST_REMITTANCE_ORDERS_S013 @PREMI-13139
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con amount de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amount = <monto>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto no puede ser mayor a 10000 dolares."
    Examples:
      | caso_prueba                                      | monto      |
      | Enviar una solicitud POST con longitud incorecta | 9999999    |
      | Enviar una solicitud POST con longitud incorecta | 9999999.00 |

#  @POST_REMITTANCE_ORDERS_S014 @PREMI-13150
#  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con amount de formato incorrecto NO-OK
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    * set body.amount = <monto>
#    And request body
#    When method post
#    Then status 400
#    And match response.code == "TL0003"
#    And match response.description contains "Los datos proporcionados no son validos"
#    And match response.errorType contains "FUNCTIONAL"
#    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
#    And match response.exceptionDetails[*].description contains "El monto no cumple con el formato correcto."
#    Examples:
#      | caso_prueba                                     | monto     |
#      | Enviar una solicitud POST caracteres especiales | 1A11°@á\t |
#      | Enviar una solicitud POST con espacio y slash   | 1A_US /   |
#      | Enviar una solicitud POST con tilde             | 1A_ÚS     |
      #| Enviar una solicitud POST con espacios          | 1a 1 2  |

  @POST_REMITTANCE_ORDERS_S015 @PREMI-13111
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con amount null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amount = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto de la remesa no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S016 @PREMI-13115
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con amountPen de monto menor NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amountPen = <monto_soles>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    #
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto en soles de la remesa no puede ser a cero o menor."
    Examples:
      | caso_prueba                                    | monto_soles |
      | Enviar una solicitud POST sin decimal          | 0           |
      | Enviar una solicitud POST con decimal de 0     | 0.00        |
      | Enviar una solicitud POST con decimal negativo | -0          |
      | Enviar una solicitud POST con decimal negativo | -0.01       |

  @POST_REMITTANCE_ORDERS_S017 @PREMI-13127
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con amountPen de monto mayor NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.amountPen = <monto_soles>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El monto en soles de la remesa no puede ser mayor a 36000 soles"
    Examples:
      | caso_prueba                                      | monto_soles    |
      | Enviar una solicitud POST con longitud incorecta | 99999999999999 |
      #bug CHECAR REFERENCIA ALEATORIA| Enviar una solicitud POST con longitud incorecta | 99999999999999.00  |

#  @POST_REMITTANCE_ORDERS_S018 @PREMI-13122
#  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con amountPen de formato incorrecto NO-OK
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    * set body.amountPen = <monto_soles>
#    And request body
#    When method post
#    Then status 400
#    And match response.code == "TL0003"
#    And match response.description contains "Los datos proporcionados no son validos"
#    And match response.errorType contains "FUNCTIONAL"
#    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
#    And match response.exceptionDetails[*].description contains "El monto en soles de la remesa no cumple con el formato correcto."
#    Examples:
#      | caso_prueba                                     | monto_soles |
#      | Enviar una solicitud POST caracteres especiales | 1A11°@á\t   |
#      | Enviar una solicitud POST con espacio y slash   | 1A_US /     |
#      | Enviar una solicitud POST con tilde             | 1A_ÚS       |
      # REVISAR CARACTER ESPECIAL| Enviar una solicitud POST con espacios          | 1a 1 2      |

  @POST_REMITTANCE_ORDERS_S019 @PREMI-13137
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con exchangeRate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = 3.918
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La tasa de cambio enviada no coincide con la tasa de cambio actual."

  @POST_REMITTANCE_ORDERS_S020 @PREMI-13143
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con exchangeRate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = <tipo_cambio>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    #And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La tasa de cambio no puede ser igual a cero o menor."
    Examples:
      | caso_prueba                                    | tipo_cambio |
      | Enviar una solicitud POST sin decimal          | 0           |
      | Enviar una solicitud POST con decimal de 0     | 0.00        |
      | Enviar una solicitud POST con decimal negativo | -0          |
      | Enviar una solicitud POST con decimal negativo | -0.01       |

  @POST_REMITTANCE_ORDERS_S021 @PREMI-13137
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con exchangeRate de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.exchangeRate = <tipo_cambio>
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    #La tasa de cambio enviada no coincide con la tasa de cambio actual. And match response.exceptionDetails[*].description contains "La tasa de cambio no puede ser mayor a 10000 dolares"
    Examples:
      | caso_prueba                                      | tipo_cambio |
      | Enviar una solicitud POST con longitud incorecta | 9999999     |
      | Enviar una solicitud POST con longitud incorecta | 9999999.00  |

#  @POST_REMITTANCE_ORDERS_S022 @PREMI-13143
#  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con exchangeRate de formato incorrecto NO-OK
#    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
#    * set body.exchangeRate = <tipo_cambio>
#    And request body
#    When method post
#    Then status 400
#    And match response.code == "TL0003"
#    And match response.description contains "Los datos proporcionados no son validos"
#    And match response.errorType contains "FUNCTIONAL"
#    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
#    And match response.exceptionDetails[*].description contains "La tasa de cambio no cumple con el formato correcto."
#    Examples:
#      | caso_prueba                                     | tipo_cambio |
#      | Enviar una solicitud POST caracteres especiales | 1A11°@á\t   |
#      | Enviar una solicitud POST con espacio y slash   | 1A_US /     |
#      | Enviar una solicitud POST con tilde             | 1A_ÚS       |
#      | Enviar una solicitud POST con espacios          | 1a 1 2      |

  @POST_REMITTANCE_ORDERS_S023
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con description de longitud incorrecta NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.description = "<descripcion>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo descripción no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | descripcion                            |
      #| Enviar una solicitud POST con longitud vacia                |                                   |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | PAGADOR BANCO DE CREDITO DEL PERUAAAA  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | PAGADOR BANCO DE CREDITO DEL PERUAAAAS |

  @POST_REMITTANCE_ORDERS_S024  @PREMI-13134
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con description de formato incorrecto NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.description = "<descripcion>"
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo descripción no cumple el formato correcto."
    Examples:
      | caso_prueba                                      | descripcion |
      | Enviar una solicitud POST caracteres especiales  | A11°@á\t    |
      | Enviar una solicitud POST con espacio y slash    | A_US /      |
      | Enviar una solicitud POST con tilde              | A_ÚS        |
      #| Enviar una solicitud POST con espacios           | a 1 2       |
      | Enviar una solicitud POST con espacios al inicio | ' A123'     |
      | Enviar una solicitud POST con espacios al fin    | 'A123 '     |
      | Enviar una solicitud POST con un espacio         | ' '         |

  @POST_REMITTANCE_ORDERS_S025    @PREMI-13148
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con merchantId que no existe NO-OK
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

  @POST_REMITTANCE_ORDERS_S026 @PREMI-13144
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con merchantId de longitud incorrecta NO-OK
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

  @POST_REMITTANCE_ORDERS_S027 @PREMI-13114
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con merchantId de formato incorrecto NO-OK
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

  @POST_REMITTANCE_ORDERS_S028 @PREMI-13138
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con merchantId null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.merchant.merchantId = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El merchant Id no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S029 @PREMI-13147
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con codigo_moneda que no existe NO-OK
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
      | Enviar una solicitud POST registrado con formato | USE           |
      | Enviar una solicitud POST registrado con formato | USI           |

  @POST_REMITTANCE_ORDERS_S030 @PREMI-13117
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con codigo_moneda de longitud incorrecta NO-OK
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
      | Enviar una solicitud POST con espacios al inicio            | ' SD'         |
      | Enviar una solicitud POST con espacios al fin               | 'US '         |

  @POST_REMITTANCE_ORDERS_S031 @PREMI-13136
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con codigo_moneda de formato incorrecto NO-OK
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
      | caso_prueba                                     | codigo_moneda |
      | Enviar una solicitud POST con un espacio        | ' '           |
      | Enviar una solicitud POST caracteres especiales | U°t           |
      | Enviar una solicitud POST con espacio y slash   | US/           |
      | Enviar una solicitud POST con tilde             | ÚSA           |
      | Enviar una solicitud POST con espacios          | U A           |

  @POST_REMITTANCE_ORDERS_S032 @PREMI-13116
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con codigo_moneda null NO-OK
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    * set body.currency.code = null
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo de la moneda no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S033 @PREMI-13170 #BUG ESPACIO
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con id_remitente de longitud incorrecta NO-OK
    * set body.sender.senderId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo unico del cliente emisor no cumple con la longitud requerida max 35 y min 0. "
    Examples:
      | caso_prueba                                                 | id_remitente                           |
      #El remitente Id no cumple con la longitud requerida max 35 y min 1.| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | 78784845100112345678954212365897456312 |

  @POST_REMITTANCE_ORDERS_S034 @PREMI-13168
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con id_remitente de formato incorrecto NO-OK
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
      | caso_prueba                            | id_remitente |
      #Error, valor con formato invalido| Enviar una solicitud POST con longitud maxima 37 caracteres | 78784845100112345678954212365897456    |
      #Los datos proporcionados no son validos| Enviar una solicitud POST caracteres especiales  | 787848451°     |
      #Los datos proporcionados no son validos| Enviar una solicitud POST con espacio y slash    | 787848451/     |
      #Los datos proporcionados no son validos| Enviar una solicitud POST con tilde              | 787848451á     |
      | Enviar una solicitud POST con espacios | 7878484 1 1  |
      #Los datos proporcionados no son validos| Enviar una solicitud POST con espacios al inicio | ' 87848451001' |
      #Los datos proporcionados no son validos| Enviar una solicitud POST con espacios al fin    | '78784845100 ' |
      #Los datos proporcionados no son validos| Enviar una solicitud POST con espacio            | ' '            |

  @POST_REMITTANCE_ORDERS_S035 @PREMI-13166
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con id_remitente nulo NO-OK
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

  @POST_REMITTANCE_ORDERS_S036 @PREMI-13119
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con nombre_remitente de longitud incorrecta NO-OK
    * set body.sender.fullName = "<nombre_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | nombre_remitente                        |
      #El nombre del remitente no cumple con la longitud requerida max 35 y min 1.| Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | Janice Keihanaikukauakahihuliheekahaaa  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Janice Keihanaikukauakahihuliheekahabcd |

  @POST_REMITTANCE_ORDERS_S037 @PREMI-13140
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con nombre_remitente de formato incorrecto NO-OK
    * set body.sender.fullName = "<nombre_remitente>"
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
      | caso_prueba                                      | nombre_remitente |
      | Enviar una solicitud POST caracteres especiales  | 787848451°       |
      | Enviar una solicitud POST con espacio y slash    | 787848451/       |
      | Enviar una solicitud POST con tilde              | 787848451á       |
      | Enviar una solicitud POST con espacios           | 7878484 1 1      |
      | Enviar una solicitud POST con espacios al inicio | ' 87848451001'   |
      | Enviar una solicitud POST con espacios al fin    | '78784845100 '   |
      | Enviar una solicitud POST con espacio            | ' '              |

  @POST_REMITTANCE_ORDERS_S038 @PREMI-13133
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con nombre_remitente nulo NO-OK
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

  @POST_REMITTANCE_ORDERS_S039 @PREMI-13132
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con direccion_remitente de longitud incorrecta NO-OK
    * set body.sender.address.summary = "<direccion_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo summary del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | direccion_remitente                    |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | AV LOS PROCERES 345 CUADRA 1 MANZANAA  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | AV LOS PROCERES 345 CUADRA 1 MANZANA 1 |

  @POST_REMITTANCE_ORDERS_S040 @PREMI-13146
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con direccion_remitente de formato incorrecto NO-OK
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
      | caso_prueba                                      | direccion_remitente  |
      | Enviar una solicitud POST caracteres especiales  | AV LOS PROCERES 3°   |
      | Enviar una solicitud POST con espacio y slash    | AV LOS PROCERES 3/   |
      | Enviar una solicitud POST con tilde              | AV LOS PRÓCERES 3    |
      #| Enviar una solicitud POST con espacios           | AV LOS PROCERES 3 1 1 |
      | Enviar una solicitud POST con espacios al inicio | ' AV LOS PROCERES 3' |
      | Enviar una solicitud POST con espacios al fin    | 'AV LOS PROCERES 3 ' |
      | Enviar una solicitud POST con espacio            | ' '                  |

  @POST_REMITTANCE_ORDERS_S041 @PREMI-13126
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con n_cel_remitente de longitud incorrecta NO-OK
    * set body.sender.address.phoneNumber = "<n_cel_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El numero de celular del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | n_cel_remitente                        |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | +923456789789456123456789456123654712  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | +9234567897894561234567894561236547896 |

  @POST_REMITTANCE_ORDERS_S042 @PREMI-13151
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con n_cel_remitente de formato incorrecto NO-OK
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


  @POST_REMITTANCE_ORDERS_S043 @PREMI-13152
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con provincia_remitente de longitud incorrecta NO-OK
    * set body.sender.address.geolocation.province.description = "<provincia_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción de la provincia del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | provincia_remitente                    |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | MICHIGAN DE LA AVENIDA JOSE MARIA COR  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | MICHIGAN DE LA AVENIDA JOSE MARIA CORT |

  @POST_REMITTANCE_ORDERS_S044 @PREMI-13153
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con provincia_remitente de formato incorrecto NO-OK
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
      | Enviar una solicitud POST con tilde              | MÍCHIGAN            |
      #| Enviar una solicitud POST con espacios           | MICHIGAN A A        |
      | Enviar una solicitud POST con espacios al inicio | ' MICHIGAN'         |
      | Enviar una solicitud POST con espacios al fin    | 'MICHIGAN '         |
      | Enviar una solicitud POST con espacio            | ' '                 |

  @POST_REMITTANCE_ORDERS_S045 @PREMI-13154
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con codigo_ciudad_remitente no registrado NO-OK
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
    And match response.exceptionDetails[*].description contains "El codigo de pais del remitente no existe o no se encuentra registrado."
    Examples:
      | caso_prueba                           | codigo_ciudad_remitente |
      | Enviar una solicitud POST con formato | USI                     |
      | Enviar una solicitud POST con formato | USO                     |

  @POST_REMITTANCE_ORDERS_S046 @PREMI-13155
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con codigo_ciudad_remitente de longitud incorrecta NO-OK
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
      | Enviar una solicitud POST con formato        | 'U'                       |
      | Enviar una solicitud POST con formato        | 'US'                      |

  @POST_REMITTANCE_ORDERS_S047 @PREMI-13157
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con codigo_ciudad_remitente nulo NO-OK
    * set body.sender.address.geolocation.country.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del remitente no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S048 @PREMI-13156
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con codigo_ciudad_remitente de formato incorrecto NO-OK
    * set body.sender.address.geolocation.country.code = "<codigo_ciudad_remitente>"
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
      | caso_prueba                                   | codigo_ciudad_remitente |
      #3CAR| Enviar una solicitud POST caracteres especiales  | U°                      |
      | Enviar una solicitud POST con espacio y slash | U /                     |
      | Enviar una solicitud POST con tilde           | USÁ                     |
      | Enviar una solicitud POST con espacios        | U A                     |
      #3CAR| Enviar una solicitud POST con espacios al inicio | ' SA'                   |
      #3CAR| Enviar una solicitud POST con espacios al fin    | 'US '                   |
      | Enviar una solicitud POST con espacio         | ' '                     |

  @POST_REMITTANCE_ORDERS_S049 @PREMI-13158
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con ciudad_remitente de longitud incorrecta NO-OK
    * set body.sender.address.geolocation.country.description = "<ciudad_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción del país del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | ciudad_remitente                       |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | PORTLAND DE LA AVENIDA JOSE MARIA COR  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | PORTLAND DE LA AVENIDA JOSE MARIA CORT |

  @POST_REMITTANCE_ORDERS_S050 @PREMI-13159
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con ciudad_remitente de formato incorrecto NO-OK
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
      #| Enviar una solicitud POST con espacios           | PORTLAND A A     |
      | Enviar una solicitud POST con espacios al inicio | ' PORTLAND'      |
      | Enviar una solicitud POST con espacios al fin    | 'PORTLAND '      |
      | Enviar una solicitud POST con espacio            | ' '              |

  @POST_REMITTANCE_ORDERS_S051 @PREMI-13160
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con celular_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[0].value = "<celular_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del CELULAR del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | celular_remitente                      |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | +923456789789456123456789456123654712  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | +9234567897894561234567894561236547896 |

  @POST_REMITTANCE_ORDERS_S052 @PREMI-13171
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con celular_remitente de formato incorrecto NO-OK
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
      | Enviar una solicitud POST con tilde              | +105927668437Á    |
      | Enviar una solicitud POST con espacios           | +105927668437 A A |
      | Enviar una solicitud POST con espacios al inicio | ' +105927668437'  |
      | Enviar una solicitud POST con espacios al fin    | '+105927668437 '  |
      | Enviar una solicitud POST con espacio            | ' '               |

  @POST_REMITTANCE_ORDERS_S053 @PREMI-13172
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con cod_contacto_remitente de longitud incorrecta NO-OK
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
      #El valor del campo address type code CELULAR del remitente no cumple con la longitud requerida max 7 y min 5.| Enviar una solicitud POST con longitud vacia                |                        |
      | Enviar una solicitud POST con longitud maxima 8 caracteres  | CELULARE               |
      | Enviar una solicitud POST con longitud maxima 10 caracteres | CELULARESS             |

  @POST_REMITTANCE_ORDERS_S054 @PREMI-13162
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con cod_contacto_remitente de formato incorrecto NO-OK
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
      | caso_prueba                                     | cod_contacto_remitente |
      | Enviar una solicitud POST caracteres especiales | CELULA°                |
      | Enviar una solicitud POST con espacio y slash   | CELUL /                |
      | Enviar una solicitud POST con tilde             | CELULÁR                |
      | Enviar una solicitud POST con espacios          | CEL A A                |
      #MAX7 YMIN| Enviar una solicitud POST con espacios al inicio | ' CELULA'              |
      #MAX7 YMIN| Enviar una solicitud POST con espacios al fin    | 'CELULA '              |
      | Enviar una solicitud POST con espacio           | ' '                    |

  @POST_REMITTANCE_ORDERS_S055 @PREMI-13172
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con cod_contacto_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[0].addressType.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del remitente no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S056 @PREMI-13161
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con correo_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El email del remitente no cumple con el formato valido."
    Examples:
      | caso_prueba                           | correo_remitente   |
      #| Enviar una solicitud POST con longitud vacia |                    |
      | Enviar una solicitud POST sin formato | A                  |
      | Enviar una solicitud POST sin formato | CORREO_REMITENTE.C |

  @POST_REMITTANCE_ORDERS_S057 @PREMI-13167
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con correo_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    #And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del EMAIL del remitente no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | correo_remitente                       |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | JOSE@DELAAVENIDAJOSEMARIACORTEZaa.COM  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | JOSE@DELAAVENIDAJOSEMARIACORTEZASS.COM |

  @POST_REMITTANCE_ORDERS_S058 @PREMI-13164
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con correo_remitente de formato incorrecto NO-OK
    * set body.sender.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El email del remitente no cumple con el formato valido."
    Examples:
      | caso_prueba                                      | correo_remitente       |
      #El email del remitente no cumple con el formato correcto.| Enviar una solicitud POST caracteres especiales  | ALX.AA@OUTLOOK.cOM°    |
      #El email del remitente no cumple con el formato correcto.| Enviar una solicitud POST con espacio y slash    | ALX.AA@OUTLOOK.cOM /   |
      #El email del remitente no cumple con el formato correcto.| Enviar una solicitud POST con tilde              | ÁLX.AA@OUTLOOK.cOM     |
      | Enviar una solicitud POST con espacios           | ALX.AA@OUTLOOK.cOM A A |
      #El email del remitente no cumple con el formato correcto.| Enviar una solicitud POST con espacios al inicio | ' ALX.AA@OUTLOOK.cOM'  |
      #El email del remitente no cumple con el formato correcto.| Enviar una solicitud POST con espacios al fin    | 'ALX.AA@OUTLOOK.cOM '  |
      #El email del remitente no cumple con el formato correcto.| Enviar una solicitud POST con espacio            | ' '                    |

  @POST_REMITTANCE_ORDERS_S059 @PREMI-13173
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con cod_correo_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].addressType.code = "<cod_correo_remitente>"
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
      | caso_prueba                                                 | cod_correo_remitente |
      #El valor del campo address type code EMAIL del remitente no cumple con la longitud requerida max 7 y min 5.| Enviar una solicitud POST con longitud vacia                |                      |
      | Enviar una solicitud POST con longitud maxima 8 caracteres  | EMAILESS             |
      | Enviar una solicitud POST con longitud maxima 10 caracteres | EMAILESSSS           |

  @POST_REMITTANCE_ORDERS_S060 @PREMI-13169
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con cod_correo_remitente de formato incorrecto NO-OK
    * set body.sender.contactAddresses[1].addressType.code = "<cod_correo_remitente>"
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
      | caso_prueba                                     | cod_correo_remitente |
      | Enviar una solicitud POST caracteres especiales | EMAIL°               |
      | Enviar una solicitud POST con espacio y slash   | EMAIL /              |
      | Enviar una solicitud POST con tilde             | ÉMAIL                |
      | Enviar una solicitud POST con espacios          | EM A A               |
      #MAX 7| Enviar una solicitud POST con espacios al inicio | ' EMAIL'             |
      #MAX7| Enviar una solicitud POST con espacios al fin    | 'EMAIL '             |
      | Enviar una solicitud POST con espacio           | ' '                  |

  @POST_REMITTANCE_ORDERS_S061 @PREMI-13163
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con cod_correo_remitente de longitud incorrecta NO-OK
    * set body.sender.contactAddresses[1].addressType.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del remitente no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S062 @PREMI-13170
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con id_remitente de longitud incorrecta NO-OK
    * set body.beneficiary.beneficiaryId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El beneficiario Id no cumple con la longitud requerida max 35 y min 1."
    Examples:
      | caso_prueba                                                 | id_remitente                            |
      #El nombre del remitente no cumple con la longitud requerida max 35 min 0.| Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | Janice Keihanaikukauakahihuliheekahaaa  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Janice Keihanaikukauakahihuliheekahabcd |

  @POST_REMITTANCE_ORDERS_S063 @PREMI-13168
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con id_remitente de formato incorrecto NO-OK
    * set body.beneficiary.beneficiaryId = "<id_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El beneficiario Id no cumple con el siguiente formato: numDoc+tipoDoc+codCorrelativo."
    Examples:
      | caso_prueba                                      | id_remitente |
      | Enviar una solicitud POST caracteres especiales  | Abc°@á\t     |
      #Error, valor con formato invalido El beneficiario Id no cumple con el siguiente formato: numDoc+tipoDoc+codCorrelativo.| Enviar una solicitud POST con espacios           | a b c        |
      | Enviar una solicitud POST con espacios al inicio | ' Abcd'      |
      | Enviar una solicitud POST con espacios al fin    | 'Juan '      |

  @POST_REMITTANCE_ORDERS_S064 @PREMI-13166
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con id_remitente nulo NO-OK
    * set body.beneficiary.beneficiaryId = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El beneficiario Id no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S065
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con nombre_beneficiario de longitud excedida NO-OK
    * set body.beneficiary.fullName = "<nombre_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del beneficiario no cumple con la longitud requerida max 35 y min 1."
    Examples:
      | caso_prueba                                                 | nombre_beneficiario                     |
      #| Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | Janice Keihanaikukauakahihuliheekahaaa  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Janice Keihanaikukauakahihuliheekahabcd |

  @POST_REMITTANCE_ORDERS_S066
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con nombre_beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.fullName = "<nombre_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | nombre_beneficiario |
      | Enviar una solicitud POST caracteres especiales  | Abc°@á\t            |
      #| Enviar una solicitud POST con espacios           | a b c               |
      | Enviar una solicitud POST con espacios al inicio | ' Abcd'             |
      | Enviar una solicitud POST con espacios al fin    | 'Juan '             |

  @POST_REMITTANCE_ORDERS_S067
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con nombre_beneficiario nulo NO-OK
    * set body.beneficiary.fullName = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El nombre del beneficiario no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con direccion del beneficiario de longitud excedida NO-OK
    * set body.beneficiary.address.summary = "<direccion_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo summary del beneficiario no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | direccion_beneficiario                    |
      #| Enviar una solicitud POST con longitud vacia                |                                           |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | Jiron lQKeihanaikukaua kahihuliheekahaaa  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Jiron lQKeihanaikukaua kahihuliheekahabcd |

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con direccion del beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.address.summary = "<direccion_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El campo summary del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | direccion_beneficiario |
      | Enviar una solicitud POST caracteres especiales  | Abc°@á\t               |
      #| Enviar una solicitud POST con espacios           | a b c                  |
      | Enviar una solicitud POST con espacios al inicio | ' Abcd'                |
      | Enviar una solicitud POST con espacios al fin    | 'Juan '                |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de celular del beneficiario de longitud excedida NO-OK
    * set body.beneficiary.address.phoneNumber = "<celular_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El numero de celular del beneficiario no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | celular_beneficiario                    |
      #| Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | +5112321423456756867876867845645645623  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | +51123214234567568678768678456456456541 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de celular del beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.address.phoneNumber = "<celular_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El numero de celular de beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | celular_beneficiario |
      | Enviar una solicitud POST caracteres especiales  | 94321°@á\t12         |
      #El numero de celular del beneficiario no cumple con el formato correcto.| Enviar una solicitud POST con espacios           | 9 2 3 456789         |
      | Enviar una solicitud POST con espacios al inicio | ' 984541122'         |
      | Enviar una solicitud POST con espacios al fin    | '984541122 '         |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con descripcion de la provincia del beneficiario de longitud excedida NO-OK
    * set body.beneficiary.address.geolocation.province.description = "<provincia_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción de la provincia del beneficiario no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | provincia_beneficiario                  |
      #| Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | Callaoaaaasasdsadasdddddddadssssdssdaa  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Callaoasssasdsadamanchasdasdasddasdddss |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con descripcion de la provincia del beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.address.geolocation.province.description = "<provincia_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripción de la provincia del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                     | provincia_beneficiario |
      | Enviar una solicitud POST caracteres especiales | Lima°@á\t              |
      #| Enviar una solicitud POST con espacios           | L i m a                |
      #| Enviar una solicitud POST con espacios al inicio | ' Lima'                |
      #| Enviar una solicitud POST con espacios al fin    | 'Lima '                |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con codigo_pais_beneficiario nulo NO-OK
    * set body.beneficiary.address.geolocation.country.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del beneficiario no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_pais_beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.address.geolocation.country.code = "<codigo_pais_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del beneficiario no cumple el formato correcto."
    Examples:
      | caso_prueba                                     | codigo_pais_beneficiario |
      | Enviar una solicitud POST caracteres especiales | P#R                      |
      | Enviar una solicitud POST con espacios          | P R                      |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_pais_beneficiario de longitud excedida NO-OK
    * set body.beneficiary.address.geolocation.country.code = "<codigo_pais_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor con formato invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo del pais del beneficiario debe tener 3 caracteres."
    Examples:
      | caso_prueba                                          | codigo_pais_beneficiario |
      | Enviar una solicitud POST con longitud vacia         |                          |
      | Enviar una solicitud POST con longitud de 1 caracter | P                        |
      | Enviar una solicitud POST con longitud de 2 caracter | PE                       |
      | Enviar una solicitud POST con espacios al inicio     | ' ER'                    |
      | Enviar una solicitud POST con espacios al fin        | 'PE '                    |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con codigo_pais_beneficiario no registrado NO-OK
    * set body.beneficiary.address.geolocation.country.code = "<codigo_pais_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El codigo de pais del beneficiario no existe o no se encuentra registrado."
    Examples:
      | caso_prueba                                               | codigo_pais_beneficiario |
      | Enviar una solicitud POST con codigo de pais no existente | SER                      |
      | Enviar una solicitud POST con codigo de pais no existente | RUD                      |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con nombre_pais_beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.address.geolocation.country.description = "<nombre_pais_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripcion del país del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                     | nombre_pais_beneficiario |
      | Enviar una solicitud POST caracteres especiales | P#RU                     |
      #| Enviar una solicitud POST con espacios           | P E R U                  |
      #| Enviar una solicitud POST con espacios al inicio | ' ERU'                   |
      #| Enviar una solicitud POST con espacios al fin    | 'PER '                   |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con nombre_pais_beneficiario de longitud excedida NO-OK
    * set body.beneficiary.address.geolocation.country.description = "<nombre_pais_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La descripcion del país del beneficiario no cumple con la longitud requerida max 35 y min 0."
    Examples:
      | caso_prueba                                                 | nombre_pais_beneficiario                |
     # | Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | Peruaoaaaasasdsadasdddddddadssssdssdaa  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | Peruaoaaaasasdsadasdddddddadssssdssdasd |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con celular_beneficiario de longitud incorrecta NO-OK
    * set body.beneficiary.contactAddresses[0].value = "<celular_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del CELULAR del beneficiario no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | celular_beneficiario                    |
      #| Enviar una solicitud POST con longitud vacia                |                                         |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | +9234567897894561234567894561236547812  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | +92345678978945612345678945612365478888 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con celular_beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.contactAddresses[0].value = "<celular_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del CELULAR del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | celular_beneficiario |
      | Enviar una solicitud POST caracteres especiales  | +105927668437°       |
      | Enviar una solicitud POST con espacio y slash    | +105927668437 /      |
      | Enviar una solicitud POST con tilde              | +105927668437Á       |
      | Enviar una solicitud POST con espacios           | +105927668437 A A    |
      | Enviar una solicitud POST con espacios al inicio | ' +105927668437'     |
      | Enviar una solicitud POST con espacios al fin    | '+105927668437 '     |
      | Enviar una solicitud POST con espacio            | ' '                  |

  @POST_REMITTANCE_ORDERS_S
  Scenario:NREM - Registrar operacion con valor del campo contactAddresses del celular del beneficiario nulo NO-OK
    * set body.beneficiary.contactAddresses[0].addressType.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del beneficiario no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con valor del campo cod_contacto_beneficiario de longitud incorrecta NO-OK
    * set body.beneficiary.contactAddresses[0].addressType.code = "<cod_contacto_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del beneficiario no cumple con la longitud requerida max 7 min 5."
    Examples:
      | caso_prueba                                                 | cod_contacto_beneficiario |
     #El valor del campo address type code CELULAR del beneficiario no cumple con la longitud requerida max 7 y min 5. | Enviar una solicitud POST con longitud vacia                |                           |
      #El valor del campo address type code CELULAR del beneficiario no cumple con la longitud requerida max 7 y min 5.| Enviar una solicitud POST con longitud de 3 caracteres      | CEL                       |
      | Enviar una solicitud POST con longitud maxima 8 caracteres  | CELULARE                  |
      | Enviar una solicitud POST con longitud maxima 10 caracteres | CELULARESS                |


  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con valor del campo cod_contacto_beneficiario de valor incorrecto NO-OK
    * set body.beneficiary.contactAddresses[0].addressType.code = "<cod_contacto_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code CELULAR del beneficiario debe tener como valor CELULAR o EMAIL."
    Examples:
      | caso_prueba                                     | cod_contacto_beneficiario |
      | Enviar una solicitud POST caracteres especiales | CELULA°                   |
      | Enviar una solicitud POST con espacio y slash   | CELUL /                   |
      | Enviar una solicitud POST con tilde             | CELULÁR                   |
      | Enviar una solicitud POST con espacios          | CEL A A                   |
      #max| Enviar una solicitud POST con espacios al inicio | ' CELULA'                 |
      #max| Enviar una solicitud POST con espacios al fin    | 'CELULA '                 |
      | Enviar una solicitud POST con espacio           | ' '                       |

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con correo_beneficiario de longitud incorrecta NO-OK
    * set body.beneficiary.contactAddresses[1].value = "<correo_remitente>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El email del beneficiario no cumple con el formato valido."
    Examples:
      | caso_prueba                           | correo_remitente   |
      #| Enviar una solicitud POST con longitud vacia |                    |
      | Enviar una solicitud POST sin formato | A                  |
      | Enviar una solicitud POST sin formato | CORREO_REMITENTE.C |

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con correo_beneficiario de longitud incorrecta NO-OK
    * set body.beneficiary.contactAddresses[1].value = "<correo_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    #And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo contactAddresses del EMAIL del beneficiario no cumple con la longitud requerida max 35 min 0."
    Examples:
      | caso_prueba                                                 | correo_beneficiario                    |
      #| Enviar una solicitud POST con longitud vacia                |                                        |
      | Enviar una solicitud POST con longitud maxima 39 caracteres | JOSE@DELAAVENIDAJOSEMARIACORTEZaa.COM  |
      | Enviar una solicitud POST con longitud maxima 40 caracteres | JOSE@DELAAVENIDAJOSEMARIACORTEZASS.COM |

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con correo_beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.contactAddresses[1].value = "<correo_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error, valor invalido"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E003"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El email del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                      | correo_beneficiario   |
      | Enviar una solicitud POST caracteres especiales  | ALX.AA@OUTLOOK.cOM°   |
      | Enviar una solicitud POST con espacio y slash    | ALX.AA@OUTLOOK.cOM /  |
      | Enviar una solicitud POST con tilde              | ÁLX.AA@OUTLOOK.cOM    |
      #El email del beneficiario no cumple con el formato valido.| Enviar una solicitud POST con espacios           | ALX.AA@OUTLOOK.cOM A A |
      | Enviar una solicitud POST con espacios al inicio | ' ALX.AA@OUTLOOK.cOM' |
      | Enviar una solicitud POST con espacios al fin    | 'ALX.AA@OUTLOOK.cOM ' |
      | Enviar una solicitud POST con espacio            | ' '                   |

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con cod_correo_beneficiario de longitud incorrecta NO-OK
    * set body.beneficiary.contactAddresses[1].addressType.code = "<cod_correo_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del beneficiario no cumple con la longitud requerida max 7 min 5."
    Examples:
      | caso_prueba                                                 | cod_correo_beneficiario |
      #El valor del campo address type code EMAIL del beneficiario no cumple con la longitud requerida max 7 y min 5.| Enviar una solicitud POST con longitud vacia                |                         |
      | Enviar una solicitud POST con longitud maxima 8 caracteres  | EMAILESS                |
      | Enviar una solicitud POST con longitud maxima 10 caracteres | EMAILESSSS              |

  @POST_REMITTANCE_ORDERS_S0
  Scenario Outline:[NREM][PV][Partner][POST] - Registrar operacion con cod_correo_beneficiario de formato incorrecto NO-OK
    * set body.beneficiary.contactAddresses[1].addressType.code = "<cod_correo_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del beneficiario debe tener como valor CELULAR o EMAIL."
    Examples:
      | caso_prueba                                     | cod_correo_beneficiario |
      | Enviar una solicitud POST caracteres especiales | EMAIL°                  |
      | Enviar una solicitud POST con espacio y slash   | EMAIL /                 |
      | Enviar una solicitud POST con tilde             | ÉMAIL                   |
      | Enviar una solicitud POST con espacios          | EM A A                  |
      #max| Enviar una solicitud POST con espacios al inicio | ' EMAIL'                |
      #max| Enviar una solicitud POST con espacios al fin    | 'EMAIL '                |
      | Enviar una solicitud POST con espacio           | ' '                     |

  @POST_REMITTANCE_ORDERS_S0
  Scenario:[NREM][PV][Partner][POST] - Registrar operacion con cod_correo_beneficiario de longitud incorrecta NO-OK
    * set body.beneficiary.contactAddresses[1].addressType.code = null
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El valor del campo address type code EMAIL del beneficiario no puede ser nulo."

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de cuenta del beneficiario con sucursal no existente NO-OK
    * set body.depositInformation.account.accountId = "<cuenta>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La sucursal del numero de cuenta no existe."
    Examples:
      | caso_prueba                                                              | cuenta         |
      | Enviar una solicitud POST con cuenta corriente con sucursal no existente | 1961475281027  |
      | Enviar una solicitud POST con cuenta corriente con sucursal no existente | 1971475281027  |
      | Enviar una solicitud POST con cuenta ahorros con sucursal no existente   | 39170846055042 |
      | Enviar una solicitud POST con cuenta ahorros con sucursal no existente   | 39270846055042 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de cuenta no existente NO-OK
    * set body.depositInformation.account.accountId = "<cuenta>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "El numero de cuenta no existe."
    Examples:
      | caso_prueba                                                 | cuenta         |
      | Enviar una solicitud POST con cuenta corriente no existente | 1911475281025  |
      | Enviar una solicitud POST con cuenta corriente no existente | 1911475281026  |
      | Enviar una solicitud POST con cuenta ahorros no existente   | 39070846055043 |
      | Enviar una solicitud POST con cuenta ahorros no existente   | 39070846055044 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de cuenta cerrada o bloqueada NO-OK
    * set body.depositInformation.account.accountId = "<cuenta>"
    * set body.beneficiary.fullName = "<nombre_beneficiario>"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Error en registro de datos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[*].code contains "E002"
    And match response.exceptionDetails[*].component contains "private-nrem-remittance-order"
    And match response.exceptionDetails[*].description contains "La cuenta se encuentra cerrada o bloqueada."
    Examples:
      | caso_prueba                                              | cuenta        | nombre_beneficiario              |
      | Enviar una solicitud POST con cuenta corriente cerrada   | 2151305106005 | ACABADOS E I R L                 |
      | Enviar una solicitud POST con cuenta corriente bloqueada | 4751082701051 | UNIVERSIDAD CESAR VALLEJO        |
      | Enviar una solicitud POST con cuenta maestra bloqueada   | 1911168930182 | BARRETO ROCCHETTI ANGEL FERNANDO |
      #| Enviar una solicitud POST con cuenta maestra bloqueada   | 1911171849166 | APELLIDO0431017 APELLIDO0431017 NOMBRE1 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de cuenta del beneficiario de longitud incorrecta NO-OK
    * set body.depositInformation.account.accountId = "105246789631245"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[1].description == "El numero de cuenta del beneficiario no cumple con la longitud requerida (max 14 y min 13) o vacio."
    Examples:
      | caso_prueba                                                  | cuenta           |
      | Enviar una solicitud POST con cuenta corriente de 11 digitos | 19114752810      |
      | Enviar una solicitud POST con cuenta corriente de 12 digitos | 191147528102     |
      | Enviar una solicitud POST con cuenta ahorros de 15 digitos   | 390708460550434  |
      | Enviar una solicitud POST con cuenta ahorros de 16 digitos   | 3907084605504441 |

  @POST_REMITTANCE_ORDERS_S
  Scenario Outline:NREM - Registrar operacion con numero de cuenta del beneficiario de formato incorrecto NO-OK
    * set body.depositInformation.account.accountId = "1052467815-10S"
    Given path 'nrem-remittance-order-v1/private/nrem/v1/remittance-orders'
    And request body
    When method post
    Then status 400
    And match response.code == "TL0003"
    And match response.description contains "Los datos proporcionados no son validos"
    And match response.errorType contains "FUNCTIONAL"
    And match response.exceptionDetails[0].component == "private-nrem-remittance-order"
    And match response.exceptionDetails[1].description == "El numero de cuenta del beneficiario no cumple con el formato correcto."
    Examples:
      | caso_prueba                                                          | cuenta         |
      | Enviar una solicitud POST con cuenta corriente con espacio           | ' '            |
      | Enviar una solicitud POST con cuenta corriente con caracter especial | 191147528102*  |
      | Enviar una solicitud POST con cuenta ahorros con letra               | 3907084605504a |




