# 02 Clave NO estructurada

!!! danger "Si el topico no esta creado, lo crea al crear la tabla"

```SQL linenums="1"
CREATE TABLE `AlbSong1`
WITH (KAFKA_TOPIC='albsong1', KEY_FORMAT='AVRO', VALUE_FORMAT='AVRO')
AS SELECT
     artist as k1,
     album as k2,
     AS_VALUE(artist) AS artist,
     AS_VALUE(album) AS album,
     count(*) as N
   FROM `raw_songs`
   WHERE title IS NOT NULL
   GROUP BY artist, album;
```


!!! warning "GROUP BY mete los campos en KEY automaticamente"

!!! danger "NO puede haber coincidencias de campos entre KEY y VALUE; por eso as k1 ; as k2"

!!! warning "queremos duplicar la info de los KEY tambien en value por eso AS_VALUE"

!!! warning "los acumuladores ej: count se meten automaticamente en VALUE"

!!! quote "k1,k2,artist,album se transforman en mayusculas por defecto si no tienen \`"

## Ver resultados

### Print (Topic)

```sql
print 'albsong1' from beginning limit 2;
```

```bash title="Ejemplo"
ksql> print 'albsong1' from beginning limit 2;
Key format: AVRO or HOPPING(KAFKA_STRING) or TUMBLING(KAFKA_STRING) or KAFKA_STRING
Value format: AVRO or KAFKA_STRING
# --------------------------------------- artist as k1  ------------ album as k2 ------------ AS_VALUE(ARTIST)-------- AS_VALUE(ALBUM)-------- ACUMULATOR
rowtime: 2026/06/13 12:29:19.538 Z, key: {"K1": "Soundgarden", "K2": "Superunknown"}, value: {"ARTIST": "Soundgarden", "ALBUM": "Superunknown", "N": 1}, partition: 0
rowtime: 2026/06/13 12:29:19.538 Z, key: {"K1": "Nirvana", "K2": "Nevermind"}, value: {"ARTIST": "Nirvana", "ALBUM": "Nevermind", "N": 3}, partition: 0
Topic printing ceased
```

### Select (Table)

```sql
select * from `AlbSong1`;
```

!!! danger "Como la clave no es estructurada K1 y K2 en dos columnas diferentes"

```bash title="Ejemplo"
ksql> select * from `AlbSong1`;
+---------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+
|K1                                     |K2                                     |ARTIST                                 |ALBUM                                  |N                                      |
+---------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+
|Nirvana                                |Nevermind                              |Nirvana                                |Nevermind                              |3                                      |
|Pearl Jam                              |Ten                                    |Pearl Jam                              |Ten                                    |4                                      |
|Soundgarden                            |Superunknown                           |Soundgarden                            |Superunknown                           |1                                      |
|Tool                                   |Aenima                                 |Tool                                   |Aenima                                 |1                                      |
|Tool                                   |Lateralus                              |Tool                                   |Lateralus                              |1                                      |
Query terminated
```