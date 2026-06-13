CREATE SOURCE CONNECTOR `sak_customer` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    "connection.url" = 'jdbc:mysql://mariadb:3306/sakila?serverTimezone=Europe/Madrid',
    "connection.user" = 'root',
    "connection.password" = 'rootpassword',
    "table.whitelist" = 'customer',
    "mode" = 'incrementing',
    "incrementing.column.name" = 'customer_id',
    "validate.non.null" = 'false',
    "topic.prefix" = 'sak.',
    --- OJO transforma el key (sin esquema)
    --- Key format: JSON or KAFKA_STRING
    "transforms" = 'createKey,extractInt',
    "transforms.createKey.type" = 'org.apache.kafka.connect.transforms.ValueToKey',
    "transforms.createKey.fields" = 'customer_id',
    "transforms.extractInt.type" = 'org.apache.kafka.connect.transforms.ExtractField$Key',
    "transforms.extractInt.field" = 'customer_id',
    "tasks.max" = '1');