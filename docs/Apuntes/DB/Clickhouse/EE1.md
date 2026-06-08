# Lecturas directas

```SQL
SELECT
    ns AS Semana,
    Country AS Pais,
    uniqExact(ServiceID) AS Servicios,
    uniqExact(StopCode) AS Estaciones
FROM file('eurotrain.parquet', Parquet) AS p
INNER JOIN mysql(
    'mariadb:3306',
    'eurostar',
    'Stations',
    'alex',
    'alexpassword'
) AS s
ON p.StopCode = s.StopCode
GROUP BY Semana, Pais
HAVING uniqExact(ServiceID) > 50
ORDER BY Semana, Pais;
```

!!! danger " Como se haria el equivalente a los secrets "
# Creando tablas

# Con Secrets

Configurar externo sin saber las cosas (no se llama secrets). 

# Con funciones de aggregacion ?

