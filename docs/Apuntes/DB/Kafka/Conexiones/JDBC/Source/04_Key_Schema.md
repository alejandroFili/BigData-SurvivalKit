```SQL linenums="1" hl_lines="20-20"
CREATE SOURCE CONNECTOR `sak_customer_sch` WITH(
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
    --- sch.customer (prefix + table.whitelist) ¿?
    --- sienta las bases de llevar del operacional en tiempo continuo
    "topic.prefix" = 'sch.',
    --- CUIDAD uso de schema para el key
    --- Key format: KAFKA_INT
    "key.converter" = 'org.apache.kafka.connect.converters.IntegerConverter',
    "key.converter.schema.registry.url" = 'http://redpanda:8081',
    "key.converter.schemas.enable" = 'true',
    "value.converter" = 'io.confluent.connect.avro.AvroConverter',
    "value.converter.schema.registry.url" = 'http://redpanda:8081',
    "value.converter.schemas.enable" = 'true',
    --- CUIDADO transformaciones del KEY
    "transforms" = 'createKey,extractInt',
    "transforms.createKey.type" = 'org.apache.kafka.connect.transforms.ValueToKey',
    "transforms.createKey.fields" = 'customer_id',
    "transforms.extractInt.type" = 'org.apache.kafka.connect.transforms.ExtractField$Key',
    "transforms.extractInt.field" = 'customer_id',
    "tasks.max" = '1');
```

!!! danger "El connector se llama sak_customer el topic es sch.customer es decir topic.prefix + table.whitelist"

!!! quote "Verificar el topic"

```SQL
print `sch.customer` from beginning limit 5;
```

!!! quote "Ejemplo salida print"

```bash linenums="1" hl_lines="2-5"
ksql> print `sch.customer` from beginning limit 5;
# Uso de schema de kafka -> tipo de kafka (correcto INT)
Key format: KAFKA_INT
# tipo del value
Value format: AVRO
# ---------------------------------- tenemos key, y ahora es un int
rowtime: 2026/06/12 23:33:26.511 Z, key: 1, value: {"customer_id": 1, "store_id": 1, "first_name": "MARY", "last_name": "SMITH", "email": "MARY.SMITH@sakilacustomer.org", "address_id": 5, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 23:33:26.513 Z, key: 2, value: {"customer_id": 2, "store_id": 1, "first_name": "PATRICIA", "last_name": "JOHNSON", "email": "PATRICIA.JOHNSON@sakilacustomer.org", "address_id": 6, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 23:33:26.513 Z, key: 3, value: {"customer_id": 3, "store_id": 1, "first_name": "LINDA", "last_name": "WILLIAMS", "email": "LINDA.WILLIAMS@sakilacustomer.org", "address_id": 7, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 23:33:26.513 Z, key: 4, value: {"customer_id": 4, "store_id": 2, "first_name": "BARBARA", "last_name": "JONES", "email": "BARBARA.JONES@sakilacustomer.org", "address_id": 8, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
rowtime: 2026/06/12 23:33:26.513 Z, key: 5, value: {"customer_id": 5, "store_id": 1, "first_name": "ELIZABETH", "last_name": "BROWN", "email": "ELIZABETH.BROWN@sakilacustomer.org", "address_id": 9, "active": 1, "create_date": 1139954676000, "last_update": 1139979440000}, partition: 0
Topic printing ceased
```