# 03_Key_NotSchema

[Docs - JDBC Source Config](https://docs.confluent.io/kafka-connectors/jdbc/current/source-connector/source_config_options.html#csfle-and-cspe-configurations)

```SQL linenums="1" hl_lines="21-21"
CREATE SOURCE CONNECTOR `sak_customer` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    --- CUIDADO puerto
    --- CUIDADO base de datos (aqui sakila)
    "connection.url" = 'jdbc:mysql://mariadb:3306/sakila?serverTimezone=Europe/Madrid',
    --- CUIDADO user, password
    "connection.user" = 'root',
    "connection.password" = 'rootpassword',
    --- CUIDADO tabla a la que conectas 
    "table.whitelist" = 'customer',
    --- como identifica cada mensaje
    --- increment o timestamp, bulk
    "mode" = 'incrementing',
    "incrementing.column.name" = 'customer_id',
    --- no hacer nada con nulos
    "validate.non.null" = 'false',
    --- va a etiquetar los mensajes como topicos
    --- sak.customer (prefix + table.whitelist) ¿?
    --- sienta las bases de llevar del operacional en tiempo continuo
    "topic.prefix" = 'sak.',
    --- CUIDADO transforma el key (sin esquema)
    --- Key format: JSON or KAFKA_STRING
    "transforms" = 'createKey,extractInt',
    "transforms.createKey.type" = 'org.apache.kafka.connect.transforms.ValueToKey',
    --- CUIDADO De que campo de la tabla estraigo el key
    --- The Goal: Copy the ID from the Value to the Key.
    "transforms.createKey.fields" = 'customer_id',
    "transforms.extractInt.type" = 'org.apache.kafka.connect.transforms.ExtractField$Key',
    --- The Goal: Flatten the newly created Key into a simple primitive (an integer).
    "transforms.extractInt.field" = 'customer_id',
    "tasks.max" = '1');
```

!!! danger "El connector se llama sak_customer el topic es sak.customer es decir topic.prefix + table.whitelist"

!!! quote "Verificar el topic"

```SQL
print `sak.customer` from beginning limit 5;
```

!!! quote "Ejemplo salida print"

```bash linenums="1" hl_lines="2-6"
ksql> print `sak.customer` from beginning limit 5;
# Key tiene formato pero NO se ha usado schema
# sale json or string aunque se puso INT
Key format: JSON or KAFKA_STRING
# Formato del value
Value format: AVRO
# -------------------------------- Key tiene format, y value (copiado en este caso del customer id)
rowtime: 2026/06/12 22:46:14.317 Z, key: 1, value: {"customer_id": 1, "store_id": 1, "first_name": "MARY", "last_name": "SMITH", "email": "MARY.SMITH@sakilacustomer.org", "address_id": 5, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 22:46:14.318 Z, key: 2, value: {"customer_id": 2, "store_id": 1, "first_name": "PATRICIA", "last_name": "JOHNSON", "email": "PATRICIA.JOHNSON@sakilacustomer.org", "address_id": 6, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 22:46:14.318 Z, key: 3, value: {"customer_id": 3, "store_id": 1, "first_name": "LINDA", "last_name": "WILLIAMS", "email": "LINDA.WILLIAMS@sakilacustomer.org", "address_id": 7, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 22:46:14.318 Z, key: 4, value: {"customer_id": 4, "store_id": 2, "first_name": "BARBARA", "last_name": "JONES", "email": "BARBARA.JONES@sakilacustomer.org", "address_id": 8, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 22:46:14.318 Z, key: 5, value: {"customer_id": 5, "store_id": 1, "first_name": "ELIZABETH", "last_name": "BROWN", "email": "ELIZABETH.BROWN@sakilacustomer.org", "address_id": 9, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
Topic printing ceased
```