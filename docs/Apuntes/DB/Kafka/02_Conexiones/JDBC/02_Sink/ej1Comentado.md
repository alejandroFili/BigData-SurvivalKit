# Ej1 Comentado

!!! quote "JDBC SINK"

```SQL
CREATE SINK CONNECTOR `sink-jdbc-albsong1` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSinkConnector',
    "connection.url" = 'jdbc:mysql://mysql:3306/kafka',
    "topics" = 'albsong1',
    "table.name.format" = 'albsong1',
    --OJO
    "key.converter" = 'io.confluent.connect.avro.AvroConverter',
    "key.converter.schema.registry.url" = 'http://schema-registry:8081',
    "key.converter.schemas.enable" = 'true',
    "value.converter" = 'io.confluent.connect.avro.AvroConverter',
    "value.converter.schema.registry.url" = 'http://schema-registry:8081',
    "value.converter.schemas.enable" = 'true',
    "connection.user" = 'kafka',
    "connection.password" = 'kafka',
    "auto.create" = 'false',
    ---OJO
    "pk.mode" = 'record_value',
    "pk.fields" = 'ARTIST,ALBUM',
    --- OJO
    "insert.mode" = 'upsert',
    "delete.enabled" = 'false',
    "tasks.max" = '1');
```