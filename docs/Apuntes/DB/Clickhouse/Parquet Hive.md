# Parquet Hive

## Local

### Copiar los ficheros a docker

!!! warning " Abre una terminal en la carpeta del fichero. Ahorras escribir la ruta "

```bash
docker cp EuroTrain.zip clickhouse:/var/lib/clickhouse/user_files
```

nos conectamos al bash de docker: 

```BASH
docker exec -it clickhouse /bin/bash
```
### Unzip

Entramos en la carpeta donde tenemos el zip
```BASH
cd /var/lib/clickhouse/user_files
```

```bash
unzip EuroTrain.zip
```

!!! danger " Da error unzip ? "
>verifica si lo tienes instalado:
>```Bash
>which unzip
>```
>si no aparece nada
>
>```Bash
>sudo apt-get install unzip
>```

Ahora si entras en la carpeta EuroTrains deberias ver las carpetas de hive

```Bash
cd EuroTrains
ls
```

### Query

Parece funcionar en DBeaver tambien, pero si quieres en terminal:

Nos conectamos al cliente de clickhouse
```BASH
docker exec -it clickhouse clickhouse-client
```

```SQL
SELECT * FROM file('EuroTrain/*/*/*/*.parquet', 'Parquet') LIMIT 10 SETTINGS use_hive_partitioning = 1;
```

!!! warning " EuroTrain tiene 3 carpetas para llegar al fichero por eso 4 * "

!!! warning " Como es en la carpeta especial de clickhouse se puede poner directamente el nombre de EuroTrain no todo el path ¿? "

Alternativa, poniendo el nombre de las carpetas

```SQL
SELECT * FROM file(
'EuroTrain/ServiceType=*/ns=*/StopCode=*/*.parquet'
, 'Parquet'
) 
LIMIT 10 
SETTINGS use_hive_partitioning = 1;
```

!!! danger " Errores raros ? -> verifica permisos "
>```Bash
>chmod -R 777 /var/lib/clickhouse/user_files
>```
>Damos todos los permisos a todas las carpetas y ficheros dentro de esa carpeta