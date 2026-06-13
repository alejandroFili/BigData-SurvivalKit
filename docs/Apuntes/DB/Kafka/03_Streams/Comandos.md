# Commandos

## RAW

>[!danger] Cuidado value format, si hace auto parse con ese formato

!!! danger "Cuidado value format, si hace auto parse con ese formato"

```sql linenums="1"
-- En este caso los tipos se obtienen directamente del parser Kafka 
CREATE STREAM `RAW_FILE_PULSE` WITH (
KAFKA_TOPIC='nombre topico', 
value_format='tipo fichero csv=AVRO ¿?');
```


```sql linenums="1"
-- En este caso los tipos se obtienen directamente del parser Kafka 
CREATE STREAM `RAW_FILE_PULSE` WITH (
KAFKA_TOPIC='connect-file-pulse-base-csv', 
value_format='AVRO');
```

>[!Danger] para ver los tipos del topico

!!! danger "para ver los tipos del topico"

```bash
print `nombre topico` from beginning limit 5;
```

>[!Danger] ojo te puede meter datos en Key tambien

!!! danger "ojo te puede meter datos en Key tambien"

ejemplo output:

```bash
Key format: ¯\_(ツ)_/¯ - no data processed
Value format: AVRO
rowtime: 2026/06/12 13:26:16.269 Z, key: <null>, value: {"album": "Superunknown", "artist": "Soundgarden", "duration": "05:06", "filename": "metal-musics-dataset.csv", "release": 1994, "title": "Black Hole Sun", "type": "Rock"}, partition: 0
rowtime: 2026/06/12 13:26:16.269 Z, key: <null>, value: {"album": "Nevermind", "artist": "Nirvana", "duration": "05:01", "filename": "metal-musics-dataset.csv", "release": 1991, "title": "Smells Like Teen Spirit", "type": "Grunge"}, partition: 0
rowtime: 2026/06/12 13:26:16.269 Z, key: <null>, value: {"album": "Nevermind", "artist": "Nirvana", "duration": "03:03", "filename": "metal-musics-dataset.csv", "release": 1991, "title": "Breed", "type": "Grunge"}, partition: 0
rowtime: 2026/06/12 13:26:16.269 Z, key: <null>, value: {"album": "Nevermind", "artist": "Nirvana", "duration": "04:17", "filename": "metal-musics-dataset.csv", "release": 1991, "title": "Lithium", "type": "Grunge"}, partition: 0
rowtime: 2026/06/12 13:26:16.269 Z, key: <null>, value: {"album": "Ten", "artist": "Pearl Jam", "duration": "03:51", "filename": "metal-musics-dataset.csv", "release": 1991, "title": "Once", "type": "Grunge"}, partition: 0
```

## TYPED

>[!Danger] Siempre mas recomendable

!!! danger "Siempre mas recomendable"

```SQL linenums="1"
-- Definir typed stream 
-- Los tipos se definen explícitamente (siempre más recomendable) 

CREATE STREAM `raw_songs` ( 
title STRING, 
album STRING, 
duration STRING, 
artist STRING, 
type STRING, 
release INTEGER, 
filename VARCHAR) 
WITH (
kafka_topic='connect-file-pulse-csv', 
value_format='AVRO');
```

## Comprobaciones

!!! quote "version corta"

```sql
DESCRIBE `nombre topic`;
```

!!! quote "version extendida"

```sql
DESCRIBE `nombre topic` EXTENDED;
```

## Ver el stream

>[!Danger] es importante que sea las comillas del codigo siguente las \` no las \'

!!! danger es importante que sea las comillas del codigo siguente las \` no las \' para el nombre del stream

```SQL
SET 'auto.offset.reset'='earliest';  
select * from `stream_name` emit changes limit 10;
```

## Acceso a datos

```sql linenums="1"
-- Acceso a datos  
SET 'auto.offset.reset'='earliest';  
select * from `raw_songs` emit changes limit 10;
```

>[!Warning] El SET earliest muestra los pasados tambien

!!! warning "El SET earliest muestra los pasados tambien"

>[!Danger] Para volver a lo normal, que muestre solo los nuevos

!!! danger "Para volver a lo normal, que muestre solo los nuevos"

```sql
SET 'auto.offset.reset'='latest';
```

