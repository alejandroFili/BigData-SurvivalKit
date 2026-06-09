# Musiteca Comentado

!!! quote "File Pulse"

```SQL

CREATE SOURCE CONNECTOR `connect-file-pulse-csv` WITH(
"connector.class" = 'io.streamthoughts.kafka.connect.filepulse.source.FilePulseSourceConnector',
"task.reader.class" = 'io.streamthoughts.kafka.connect.filepulse.reader.LocalRowFileInputReader',
"fs.cleanup.policy.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.clean.LogCleanupPolicy',
"fs.cleanup.policy.triggered.on" = 'COMMITTED',
"fs.listing.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.LocalFSDirectoryListing',
--- carpeta kdbsql-server
"fs.listing.directory.path" = '/home/appuser/alex/',
"fs.listing.filters" = 'io.streamthoughts.kafka.connect.filepulse.fs.filter.RegexFileListFilter',
"fs.listing.interval.ms" = '10000',
"file.filter.regex.pattern" = '.*\\.csv$',
"offset.policy.class" = 'io.streamthoughts.kafka.connect.filepulse.offset.DefaultSourceOffsetPolicy',
"offset.attributes.string" = 'name',
--- no crea mensaje con cabecera (si los tiene)
"skip.headers" = '1',
--- nombre del topic del mensajes cuando se cargan
--- normalmente no se dejan crear conectores por defecto
--- normalmente te asignan debajo de otros seibe.filepulse.connect ...
"topic" = 'connect-file-pulse-csv',
"tasks.reader.class" = 'io.streamthoughts.kafka.connect.filepulse.fs.reader.LocalRowFileInputReader',
"tasks.file.status.storage.class" = 'io.streamthoughts.kafka.connect.filepulse.state.KafkaFileObjectStateBackingStore',
"tasks.file.status.storage.bootstrap.servers" = 'redpanda:9092',
--- mensajes de control de tareas
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
---
"internal.kafka.reporter.bootstrap.servers" = 'redpanda:9092',
"internal.kafka.reporter.topic" = 'connect-file-pulse-status',
"tasks.max" = '1');

```