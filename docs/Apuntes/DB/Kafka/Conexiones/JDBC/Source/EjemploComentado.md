# Ejemplo Comentado

!!! quote "JDBC"

```SQL
CREATE SOURCE CONNECTOR `raw_customer` WITH(
    "connector.class" = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    --- ojo puerto tiene que coincidir
    --- ojo nombre de la base de datos
    "connection.url" = 'jdbc:mysql://mariadb:3306/sakila?serverTimezone=Europe/Madrid',
    --- cambia el user y password a lo que tengas
    "connection.user" = 'sak_user',
    "connection.password" = 'sak_pass',
    "db.timezone" = 'Europe/Madrid',
    --- si no pongo esto mira todas las tablas
    "table.whitelist" = 'customer',
    --- como identifica cada mensaje
    --- increment o timestamp, bulk
    "mode" = 'incrementing',
    "incrementing.column.name" = 'customer_id',
    --- no hacer nada con nulos
    "validate.non.null" = 'false',
    --- va a etiquetar los mensajes como topicos
    --- raw.customer
    --- sienta las bases de llevar del operacional en tiempo continuo
    "topic.prefix" = 'raw.',
    "tasks.max" = '1');
```