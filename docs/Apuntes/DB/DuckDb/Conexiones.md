# Conexiones

## CSV

```SQL
%% INSERT INTO dim_customer %%
SELECT *
FROM read_csv(
'C:\Alex\Obsidian\Año III\InfraestructurasBigData\Moodle Official\Tema 4\Duck\SakStar\dim_customer.csv.gz',
delim = ';',
header = true
);
```

## Parquet

!!! danger " Ojo / vs \ vs doble \ "
>Si copias y pegas en windows normalmente te lo pone \ hay que sustituir con doble \ o simple / 

### Local

#### Normal

```SQL
DESCRIBE

FROM read_parquet(
'C:/Alex/Obsidian/Año III/InfraestructurasBigData/Datos/eurotrain.parquet',
hive_partitioning = true
)
;
```

#### Hive

!!! warning " Si el fichero hive esta particionado en 3 carpetas (cuantas carpetas tienes que entrar para ver un fichero .parquet) entonces necesitas cuatro *  "
>una por cada carpeta + 1 para el fichero

!!! danger " Recuerda que puedes filtrar directamente las carpetas (solucion EE1) "

Versiones:

```SQL
SELECT *

FROM read_parquet(
'C:\\Alex\\Obsidian\\Año III\\InfraestructurasBigData\\Datos\\EuroTrain_Hive\\EuroTrain\\*\\*\\*\\*.parquet',
hive_partitioning = TRUE
)
LIMIT 10
;
```

```SQL
SELECT *
FROM read_parquet(
	'C:/Alex/Obsidian/Año III/InfraestructurasBigData/Datos/EuroTrain_Hive/EuroTrain/*/*/*/*.parquet', 
	hive_partitioning  = TRUE
)
LIMIT 10
;
```

```SQL
SELECT *
FROM read_parquet(
  'C:/Alex/Obsidian/Año III/InfraestructurasBigData/Datos/EuroTrain_Hive/EuroTrain/ServiceType=*/ns=*/StopCode=*/*.parquet',
  hive_partitioning = true
)
LIMIT 10
;
```

## JSON

```SQL
SELECT * FROM 'C:\Alex\Obsidian\Año III\InfraestructurasBigData\Datos\Alex\MOCK_DATA.json';
```

```SQL
SELECT *
FROM read_json('C:\Alex\Obsidian\Año III\InfraestructurasBigData\Datos\Alex\MOCK_DATA.json',
               format = 'array',
               columns = {id: 'UBIGINT',
                          first_name: 'VARCHAR',
                          last_name: 'VARCHAR',
                          email: 'VARCHAR',
                          gender: 'VARCHAR',
                          ip_address: 'VARCHAR'
})
LIMIT 10

```