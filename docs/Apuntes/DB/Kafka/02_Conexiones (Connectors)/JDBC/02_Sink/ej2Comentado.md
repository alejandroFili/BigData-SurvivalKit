# Ej2 Comentado

[Link bitacora](https://kafka.datastack.seibe.org/Tutorial/JDBCSink2/#conector-jdbcsink)

!!! quote "JDBC SINK"

```SQL
CREATE SINK CONNECTOR `sink-jdbc-albsong2` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSinkConnector',
    "connection.url" = 'jdbc:mysql://mysql:3306/kafka',
    "topics" = 'albsong2',
    "table.name.format" = 'albsong2',
    "key.converter" = 'io.confluent.connect.avro.AvroConverter',
    "key.converter.schema.registry.url" = 'http://schema-registry:8081',
    "key.converter.schemas.enable" = 'true',
    "value.converter" = 'io.confluent.connect.avro.AvroConverter',
    "value.converter.schema.registry.url" = 'http://schema-registry:8081',
    "value.converter.schemas.enable" = 'true',
    "connection.user" = 'kafka',
    "connection.password" = 'kafka',
    "auto.create" = 'false',
    --- ojo
    "pk.mode" = 'record_key',
    "pk.fields" = '',
    --- que parte del valor del mensaje se pone
    --- en este caso hay solo un campo, 
    --- se pone para documentarlo tambien
    "fields.withelist" = 'N',
    "insert.mode" = 'upsert',
    "delete.enabled" = 'true',
    "tasks.max" = '1');
```