```SQL linenums="1"
CREATE SOURCE CONNECTOR `raw_customer` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    --- CUIDADO puerto
    --- CUIDADO base de datos (aqui sakila)
    "connection.url" = 'jdbc:mysql://mariadb:3306/sakila?serverTimezone=Europe/Madrid',
    --- CUIDADO user, password
    "connection.user" = 'root',
    "connection.password" = 'rootpassword',
    "db.timezone" = 'Europe/Madrid',
    --- CUIDADO tabla a la que conectas 
    "table.whitelist" = 'customer',
    --- como identifica cada mensaje
    --- increment o timestamp, bulk
    "mode" = 'incrementing',
    "incrementing.column.name" = 'customer_id',
    --- que hace con los nulos
    "validate.non.null" = 'false',
    --- va a etiquetar los mensajes como topicos
    --- raw.customer (prefix + table.whitelist) ¿?
    --- sienta las bases de llevar del operacional en tiempo continuo
    "topic.prefix" = 'raw.',
    "tasks.max" = '1');
    --- NO key format
    --- Key format: ¯\_(ツ)_/¯ - no data processed
```

!!! danger "El connector se llama raw_customer el topic es raw.customer es decir topic.prefix + table.whitelist"

!!! quote "Verificar el topic"

```SQL
print `raw.customer` from beginning limit 5;
```

!!! quote "Ejemplo salida print"

```bash linenums="1" hl_lines="2-5"
ksql> print 'raw.customer' from beginning limit 5;
# key format : Null, no hay nada
Key format: ¯\_(ツ)_/¯ - no data processed
# formato de la parte value
Value format: AVRO
#----------------------------------- sin nada -> key :<null>
rowtime: 2026/06/12 20:12:56.620 Z, key: <null>, value: {"customer_id": 1, "store_id": 1, "first_name": "MARY", "last_name": "SMITH", "email": "MARY.SMITH@sakilacustomer.org", "address_id": 5, "active": 1, "create_date": 1139951076000, "last_update": 1139975840000}, partition: 0
rowtime: 2026/06/12 20:12:56.622 Z, key: <null>, value: {"customer_id": 2, "store_id": 1, "first_name": "PATRICIA", "last_name": "JOHNSON", "email": "PATRICIA.JOHNSON@sakilacustomer.org", "address_id": 6, "active": 1, "create_date": 1139951076000, "last_update": 1139975840000}, partition: 0
rowtime: 2026/06/12 20:12:56.623 Z, key: <null>, value: {"customer_id": 3, "store_id": 1, "first_name": "LINDA", "last_name": "WILLIAMS", "email": "LINDA.WILLIAMS@sakilacustomer.org", "address_id": 7, "active": 1, "create_date": 1139951076000, "last_update": 1139975840000}, partition: 0
rowtime: 2026/06/12 20:12:56.623 Z, key: <null>, value: {"customer_id": 4, "store_id": 2, "first_name": "BARBARA", "last_name": "JONES", "email": "BARBARA.JONES@sakilacustomer.org", "address_id": 8, "active": 1, "create_date": 1139951076000, "last_update": 1139975840000}, partition: 0
rowtime: 2026/06/12 20:12:56.624 Z, key: <null>, value: {"customer_id": 5, "store_id": 1, "first_name": "ELIZABETH", "last_name": "BROWN", "email": "ELIZABETH.BROWN@sakilacustomer.org", "address_id": 9, "active": 1, "create_date": 1139951076000, "last_update": 1139975840000}, partition: 0
Topic printing ceased
```

