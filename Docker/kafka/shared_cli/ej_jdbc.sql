CREATE SOURCE CONNECTOR `raw_customer` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    "connection.url" = 'jdbc:mysql://mariadb:3306/sakila?serverTimezone=Europe/Madrid',
    "connection.user" = 'root',
    "connection.password" = 'rootpassword',
    "db.timezone" = 'Europe/Madrid',
    "table.whitelist" = 'customer',
    "mode" = 'incrementing',
    "incrementing.column.name" = 'customer_id',
    "validate.non.null" = 'false',
    "topic.prefix" = 'raw.',
    "tasks.max" = '1');
    --- NO key format
    --- Key format: ¯\_(ツ)_/¯ - no data processed