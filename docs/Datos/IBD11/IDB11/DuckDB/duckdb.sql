INSTALL httpfs;
LOAD httpfs;
-- etsiinf S3 MinIO
CREATE OR REPLACE SECRET etsiinf (
TYPE s3,
PROVIDER config,
KEY_ID 'w5hjdhNjUg5lUsxMdN1s',
SECRET 'sj7dite5clwx77WAsOs6gJ09BBuzyHWGeEjnkh0d',
ENDPOINT 'izar.ls.fi.upm.es:30009',
URL_STYLE 'path',
--REGION 'eu-southt-2',
USE_SSL true
);
FROM duckdb_secrets();

WITH allData AS (
	SELECT *
	FROM read_parquet('s3://etsiinf26/Ene26.parquet', hive_partitioning = false)
	ORDER BY ServiceID,tts
)
SELECT 
ServiceType,
ServiceID,
StopCode as Origen,
LAG(StopCode) OVER (ORDER BY tts) Destino,
StopDepartureTime as Salida,
StopArrivalTime as Llegada
FROM allData
;