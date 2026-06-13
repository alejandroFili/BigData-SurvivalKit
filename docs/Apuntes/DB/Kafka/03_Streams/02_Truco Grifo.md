# 02 Truco Grifo

<iframe style="border:none" width="800" height="450" src="https://whimsical.com/embed/M4TXAmhiByegoZ9mi8VD2r@2Ux7TurymNcNrPoCC5jk"></iframe>

[Ejemplo tutorial (cuidado erratas)](https://kafka.datastack.seibe.org/Tutorial/JDBCSink1/)

## Descripcion

Basicamente el truco consiste en crear un query (de insert) entre dos streams.
Asi el segundo se puede eliminar (si te das cuenta que lo has creado mal etc.).

## Abrir el grifo (Query ID)

!!! danger "Al crear el query te da un ID, podrias guardarlo para saber que usar en terminate"

```bash title="Ejemplo Query"
ksql> INSERT INTO `songs`
>  SELECT *
>  FROM `raw_songs` EMIT CHANGES;

 Message
--------------------------------------
 Created query with ID INSERTQUERY_11
--------------------------------------
```

!!! warning "No lo has guardado? Puedes usar SHOW QUERIES; (mira el query string)"

```SQL title="Ver todos los queries"
SHOW QUERIES;
```

```bash title="Ejemplo output"
 Query ID           | Query Type | Status    | Sink Name  | Sink Kafka Topic | Query String                                                                                                                                                                                                                                                                                                                                                       
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 INSERTQUERY_11     | PERSISTENT | RUNNING:1 | songs      | songs            | INSERT INTO `songs`   SELECT *   FROM `raw_songs` EMIT CHANGES;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
 CTAS_ALBSONG2_20   | PERSISTENT | RUNNING:1 | AlbSong2   | albsong2         | CREATE TABLE `AlbSong2` WITH (CLEANUP_POLICY='compact', KAFKA_TOPIC='albsong2', KEY_FORMAT='AVRO', PARTITIONS=1, REPLICAS=1, RETENTION_MS=604800000, VALUE_FORMAT='AVRO') AS SELECT   STRUCT(ARTIST:=`raw_songs`.ARTIST, ALBUM:=`raw_songs`.ALBUM) K,   COUNT(*) N FROM `raw_songs` `raw_songs` WHERE ((`raw_songs`.TITLE IS NOT NULL) AND (`raw_songs`.ALBUM IS NOT NULL)) GROUP BY STRUCT(ARTIST:=`raw_songs`.ARTIST, ALBUM:=`raw_songs`.ALBUM) EMIT CHANGES;   
```

## Cerrar el grifo

```SQL title="Cerrar el grifo"
TERMINATE <query id>;
```

```SQL title="ejemplo"
ksql> TERMINATE INSERTQUERY_11;

 Message
-------------------
 Query terminated.
-------------------
```