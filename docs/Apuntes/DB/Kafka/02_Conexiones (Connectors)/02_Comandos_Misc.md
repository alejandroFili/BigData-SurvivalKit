# Comandos Misc

## Ver los connectores

```SQL title="Ver los connectores"
SHOW CONNECTORS;
```

!!! danger "mira status (running, warning, error)"

```bash title="Ejemplo output"
ksql> SHOW CONNECTORS;

 Connector Name         | Type   | Class                                                                     | Status
-------------------------------------------------------------------------------------------------------------------------------------------
 connect-file-pulse-csv | SOURCE | io.streamthoughts.kafka.connect.filepulse.source.FilePulseSourceConnector | RUNNING (1/1 tasks RUNNING)
 sink-jdbc-songs        | SINK   | io.confluent.connect.jdbc.JdbcSinkConnector                               | RUNNING (1/1 tasks RUNNING)
 sink-jdbc-albsong1     | SINK   | io.confluent.connect.jdbc.JdbcSinkConnector                               | WARNING (0/1 tasks RUNNING)
-------------------------------------------------------------------------------------------------------------------------------------------
```

## Describe connector (ver si algo ha ido mal)

```SQL title="Describe connector"
DESCRIBE CONNECTOR `name`;
```

## Quitar un connector

```SQL title="Quitar un connector (no olvides \`)"
drop connector `sink-jdbc-songs`;
```

