# 01_Ejemplo_Comentado

[Docs - JDBC Source Config](https://docs.confluent.io/kafka-connectors/jdbc/current/source-connector/source_config_options.html#csfle-and-cspe-configurations)

!!! quote "JDBC"

```SQL linenums="1"
CREATE SOURCE CONNECTOR `raw_customer` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    --- CUIDADO puerto tiene que coincidir
    --- CUIDADO nombre de la base de datos
    "connection.url" = 'jdbc:mysql://mariadb:3306/sakila?serverTimezone=Europe/Madrid',
    --- CUIDADO cambia el user y password a lo que tengas
    "connection.user" = 'sak_user',
    "connection.password" = 'sak_pass',
    "db.timezone" = 'Europe/Madrid',
    --- CUIDADO si no pongo esto mira todas las tablas
    "table.whitelist" = 'customer',
    --- como identifica cada mensaje
    --- increment o timestamp, bulk
    "mode" = 'incrementing',
    "incrementing.column.name" = 'customer_id',
    --- no hacer nada con nulos
    "validate.non.null" = 'false',
    --- va a etiquetar los mensajes como topicos
    --- raw.customer (prefix + table.whitelist) ¿?
    --- sienta las bases de llevar del operacional en tiempo continuo
    "topic.prefix" = 'raw.',
    "tasks.max" = '1');
```

!!! quote "Ver el resultado"
```SQL
print 'raw.customer' from beginning limit 5;
```