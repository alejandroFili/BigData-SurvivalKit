# 03 Clave estructurada

!!! danger "Si el topico no esta creado, lo crea al crear la tabla"

```sql linenums=1 hl_lines="4 8"
CREATE TABLE `AlbSong2`
WITH (KAFKA_TOPIC='albsong2', KEY_FORMAT='AVRO', VALUE_FORMAT='AVRO')
AS SELECT
     struct(artist := artist, album := album) as k,
     count(*) as N
   FROM `raw_songs`
   WHERE title IS NOT NULL AND album IS NOT NULL
   GROUP BY struct(artist := artist, album := album);
```

!!! danger "Para crear una tabla con clave estructurada necesitas struct"

## Ver Resultados

### Print (Topic)

```sql
print 'albsong2' from beginning limit 2;
```

```bash
ksql> print 'albsong2' from beginning limit 2;
Key format: AVRO or HOPPING(KAFKA_STRING) or TUMBLING(KAFKA_STRING) or KAFKA_STRING
Value format: AVRO or KAFKA_STRING
rowtime: 2026/06/13 12:29:19.538 Z, key: {"ARTIST": "Soundgarden", "ALBUM": "Superunknown"}, value: {"N": 1}, partition: 0
rowtime: 2026/06/13 12:29:19.538 Z, key: {"ARTIST": "Nirvana", "ALBUM": "Nevermind"}, value: {"N": 3}, partition: 0
Topic printing ceased
```

### Select (Table)

```sql
select * from `AlbSong2`;
```

!!! danger "Como la clave no es estructurada K1(artist) y K2(album) en la misma columna"

```bash
ksql> select * from `AlbSong2`;
+------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
|K                                                                                                     |N                                                                                                     |
+------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
|{ARTIST=Nirvana, ALBUM=Nevermind}                                                                     |3                                                                                                     |
|{ARTIST=Pearl Jam, ALBUM=Ten}                                                                         |4                                                                                                     |
|{ARTIST=Soundgarden, ALBUM=Superunknown}                                                              |1                                                                                                     |
|{ARTIST=Tool, ALBUM=Aenima}                                                                           |1                                                                                                     |
|{ARTIST=Tool, ALBUM=Lateralus}                                                                        |1                                                                                                     |
Query terminated
```