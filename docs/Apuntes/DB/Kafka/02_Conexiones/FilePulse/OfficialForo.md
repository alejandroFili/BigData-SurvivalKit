# Official Foro


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
    "skip.headers" = '1',
    "topic" = 'connect-file-pulse-csv',
    "tasks.reader.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.reader.LocalRowFileInputReader',
    "tasks.file.status.storage.class" = 'io.streamthoughts.kafka.connect.filepulse.state.KafkaFileObjectStateBackingStore',
    "tasks.file.status.storage.bootstrap.servers" = 'redpanda:9092',
    "tasks.file.status.storage.topic" = 'connect-file-pulse-status',
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