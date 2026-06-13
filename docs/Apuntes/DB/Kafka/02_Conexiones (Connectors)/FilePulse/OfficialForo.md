# Official Foro

!!! danger "No olvides: por defecto se borran los archivos/carpetas de server y hay que ponerlos otra vez"

[LINK](/Apuntes/DB/Kafka/02_Conexiones/FilePulse/FilePulse.txt)

!!! danger "No olvides cambiar la carpeta con la que necesitas"

```SQL linenums="6"
"fs.listing.directory.path" = '/tmp/FilePulse/',
```

!!! warning "si no funciona intenta copiarlo del link"

```SQL
CREATE SOURCE CONNECTOR `connect-file-pulse-csv` WITH(
    "connector.class" = 'io.streamthoughts.kafka.connect.filepulse.source.FilePulseSourceConnector',
    "fs.cleanup.policy.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.clean.LogCleanupPolicy',
    "fs.cleanup.policy.triggered.on" = 'COMMITTED',
    "fs.listing.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.LocalFSDirectoryListing',
    --- CUIDADO : cambia la carpeta a la que necesites
    "fs.listing.directory.path" = '/tmp/FilePulse/',
    "fs.listing.filters" = 'io.streamthoughts.kafka.connect.filepulse.fs.filter.RegexFileListFilter',
    "fs.listing.interval.ms" = '10000',
    --- CUIDADO : busca .csv
    "file.filter.regex.pattern" = '.*\\.csv$',
    "offset.policy.class" = 'io.streamthoughts.kafka.connect.filepulse.offset.DefaultSourceOffsetPolicy',
    "offset.attributes.string" = 'name',
    --- no crea mensaje con cabecera (si los tiene)
    "skip.headers" = '1',
    --- CUIDADO : aqui se pone el topic completo (no combina prefix etc)
    --- nombre del topic del mensajes cuando se cargan
    --- normalmente no se dejan crear conectores por defecto
    --- normalmente te asignan debajo de otros seibe.filepulse.connect ...
    "topic" = 'connect-file-pulse-csv',
    "tasks.reader.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.reader.LocalRowFileInputReader',
    "tasks.file.status.storage.class" = 'io.streamthoughts.kafka.connect.filepulse.state.KafkaFileObjectStateBackingStore',
    "tasks.file.status.storage.bootstrap.servers" = 'redpanda:9092',
    --- mensajes de control de tareas
    --- otro topic 
    "tasks.file.status.storage.topic" = 'connect-file-pulse-status',
    -- se puede usar sin est
    "filters" = 'ParseCSVLine,FileName,ReleaseToInt',
    "filters.ParseCSVLine.extract.column.name" = 'headers',
    "filters.ParseCSVLine.trim.column" = 'true',
    "filters.ParseCSVLine.separator" = ';',
    "filters.ParseCSVLine.type" = 'io.streamthoughts.kafka.connect.filepulse.filter.DelimitedRowFilter',
    "filters.FileName.type" = 'io.streamthoughts.kafka.connect.filepulse.filter.AppendFilter',
    "filters.FileName.field" = '$.filename',
    "filters.FileName.value" = '$metadata.name',
    "filters.ReleaseToInt.type" = 'io.streamthoughts.kafka.connect.filepulse.filter.ConvertFilter',
    "filters.ReleaseToInt.field" = 'release',
    "filters.ReleaseToInt.to" = 'INTEGER',
    "filters.ReleaseToInt.default" = '0',
    "internal.kafka.reporter.bootstrap.servers" = 'redpanda:9092',
    "internal.kafka.reporter.topic" = 'connect-file-pulse-status',
    "tasks.max" = '1');
```

!!! quote "Ver si se ha creado"

```SQL
list topics;
```

!!! quote "Ver el resultado"

```SQL
print 'connect-file-pulse-csv' from beginning limit 5;
```

## Problemas

Verifica:

- [ ] Tienes la carpeta creada en server
- [ ] Tienes el fichero en la carpeta en server
- [ ] Permisos ? de la carpeta/fichero en server

```SQL title="Conexion al servidor"
docker exec -it ksqldb-server /bin/bash
```

```SQL title="Creamos la carpeta"
mkdir /tmp/FilePulse
```

```SQL title="Movemos el fichero (en mi caso del shared_server que es un bind volume)"
cd shared_server
--- puedes pulsar tab despues de estribir me y se autocompleta
cp metal-musics-dataset.csv /tmp/FilePulse 
```

!!! warning "Verifica en CLI si te va con list topics; si no (ojo coge cada x milisegundos intentalo varias veces)-> prueba permisos"

```SQL title="Permisos en server"
chmod -R 777 /tmp/FilePulse
```