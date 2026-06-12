- [ ] MariaDB
- [ ] MySQL
- [ ] Ficheros locales
	- [ ] Parquet
	- [ ] Parquet - Hive
	- [ ] CSV
	- [ ] JSON
	- [ ] Arrow ?
- [ ] S3 - Minio
	- [ ] Conexion Directa
	- [ ] Conexion Named Collections
	- [ ] Tipo Ficheros
		- [ ] Parquet
		- [ ] Parquet - Hive
		- [ ] CSV
		- [ ] JSON
		- [ ] Arrow



# MariaDB

```SQL
SELECT *
FROM mysql(
  'mariadb_big:3306',
  'eurostar',
  'Stations',
  'alex',
  'alexpassword'
) LIMIT 10;
```

```SQL
SELECT *
FROM mysql(
  'host:port',
  'database',
  'table',
  'user',
  'password'
);
```

# Parquet

## Local

### Copiar los ficheros a docker

!!! warning " Abre una terminal en la carpeta del fichero. Ahorras escribir la ruta "

```bash
docker cp eurotrain.parquet clickhouse:/var/lib/clickhouse/user_files
```

```bash
docker cp file dockerName:location
```

### Permisos del fichero copiado

!!! danger " Ojo con los permisos "

```bash
ls -l eurotrain.parquet 
# verificar los permisos
```

```bash
chmod 777 eurotrain.parquet 
# damos todos los permisos a todos, obviamente no seguro, pero total es en nuestro docker
```

### Consulta

```SQL
SELECT *
FROM file('eurotrain.parquet', Parquet) 
LIMIT 10;
```

## Online


# Parquet Hive

## Local

### Copiar los ficheros a docker

!!! warning " Abre una terminal en la carpeta del fichero. Ahorras escribir la ruta "

```bash
docker cp EuroTrain.zip clickhouse:/var/lib/clickhouse/user_files
```

```bash
docker cp file dockerName:location
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
# CSV

# Jupyter

```PYTHON
import clickhouse_connect
```

```PYTHON
client = clickhouse_connect.get_client(
    host='clickhouse',
    port=8123,
    username='default',
    password='defaultpassword',
    database='etsiinf'
)
```

!!! danger " Si tienes Syntax error (Multi-statements are not allowed) "
las `'''` tienen se que ser pegadas
mal :
![](Assets/img/Pasted%20image%2020260501202558.png)
bien:
![](Assets/img/Pasted%20image%2020260501202717.png)


```PYTHON
query = '''SELECT
    toString(EventDate) AS Fecha,
    EventID AS EvID,
    sumMerge(sV1) AS sV1,
    avgMerge(mV2) AS mV2,
    uniqMerge(uV2) AS uV2
FROM etsiinf.aggEvents
GROUP BY EventDate, EventID
ORDER BY EventDate, EventID;'''

result = client.query(query)
for row in result.result_rows:
    print(row)
```

# Terminal

Encendemos el docker:

```BASH
docker compose up -d
```

Acceso general al contenedor:

```bash
docker exec -it <nombre contenedor> comando
```

```Bash
docker exec -it clickhouse /bin/bash
```

!!! danger " Hay dos comandos : "
>clickhouse - cosas generales de management ¿? (no pide contraseña)
>clickhouse-client : donde se ejecuta el SQL (pide contraseña)

```BASH
%% si has hecho antes /bin/bash %%
clickhouse-client 
%% te pedira la contraseña %%

%% alternativa %%

clickhouse-client -u<NombreUsuario> -p<ContraseñaUsuario>

%% si no has hecho /bin/bash %%

docker exec -it clickhouse clickhouse-client
```

# DBeaver

## Local

![](docs/Assets/img/Pasted%20image%2020260504132410.png)

!!! warning " Puerto, usuario, password del docker compose "

## Online

![](docs/Assets/img/Pasted%20image%2020260504132518.png)

!!! warning " Link etc del profe "

# S3 Minio

## Conexion directa

!!! quote " Muestra los credenciales, no utiliza el config "

!!! quote " Describe para ver como se van a inferir los datos "
```SQL
DESCRIBE TABLE
s3(
'https://izar.ls.fi.upm.es:30009/sakstar/dim_date.csv',
'ST8FznBWCiBL1Wk5GZZX',
'PMajya6c8RZYpYdUvWHigRA8uwQLUy7txElFBZma',
'CSV'
);
```

```SQL
DESCRIBE TABLE
s3(
'https://host:port/folder/file',  
'ACCESS_KEY',  
'SECRET_KEY',  
'CSV'
)
```

!!! danger " Puede que sea http o https (USE_SSL es que es https) "

```SQL
select * from
s3(
'https://izar.ls.fi.upm.es:30009/sakstar/dim_date.csv',
'ST8FznBWCiBL1Wk5GZZX',
'PMajya6c8RZYpYdUvWHigRA8uwQLUy7txElFBZma',
'CSV'
)
limit 10
;
```

## Conexion con Named Collections

Necesitas un fichero (el nombre en si da igual) .xml en 

```BASH
/etc/clickhouse-server/config.d/
```

Dos opciones :
- Copiar directamente 
- bind volume en docker compose

```BASH
docker cp nc.xml clickhouse:/etc/clickhouse-server/config.d/
```

```docker
    volumes
      - ./nc.xml:/etc/clickhouse-server/config.d/nc.xml
```

Dentro del fichero XML:

```XML
<clickhouse>
  <named_collections>
    <minio_sakstar>
      <url>https://izar.ls.fi.upm.es:30009/sakstar/</url>
      <access_key_id>ST8FznBWCiBL1Wk5GZZX</access_key_id>
      <secret_access_key>PMajya6c8RZYpYdUvWHigRA8uwQLUy7txElFBZma</secret_access_key>
    </minio_sakstar>
    <minio_root>
      <url>https://izar.ls.fi.upm.es:30009/</url>
      <access_key_id>ST8FznBWCiBL1Wk5GZZX</access_key_id>
      <secret_access_key>PMajya6c8RZYpYdUvWHigRA8uwQLUy7txElFBZma</secret_access_key>
    </minio_root>
    <mariadb_profe>
            <host>izar.ls.fi.upm.es</host>
            <port>36060</port>
            <!-- <database>eurostar</database> -->
            <user>eurostar</user>
            <password>eurostar</password>
    </mariadb_profe>
  </named_collections>
</clickhouse>
```

!!! danger " Puedes conectar directamente a una carpeta en s3 o a una base de datos en mariadb "

Si tienes el docker encendido puedes hacer docker compose restart (o docker compose down , docker compose up -d) o directamente en dbeaver recargar la configuracion

```SQL
SYSTEM RELOAD CONFIG;
```

Para ver si se han cargado, o si te has olvidado los nombres que has puesto

```SQL
SELECT name FROM system.named_collections;
```

Ejemplo Query:

```SQL
SELECT *
FROM s3(minio_sakstar, filename='dim_date.csv', format='CSV')
LIMIT 10
;

SELECT *
FROM s3(minio_root, filename='sakstar/dim_date.csv', format='CSV')
LIMIT 10
;
```

!!! warning " La primera utiliza la conexión directa a la carpeta sakstar la segunda no asi que tienes que ponerlo en el filename "

