
create table rawEE2
engine = S3
(
  'https://izar.ls.fi.upm.es:30009/etsiinf26/Ene26.parquet',
  'w5hjdhNjUg5lUsxMdN1s',
  'sj7dite5clwx77WAsOs6gJ09BBuzyHWGeEjnkh0d',
  'parquet'
);

select * from rawEE2;

select tts as ArrivalTime, ServiceType, StopCode  from rawEE2 
group by ArrivalTime, ServiceType, StopCode 
order by ArrivalTime, ServiceType, StopCode;

COUNT(DISTINCT ServiceID) OVER(PARTITION BY c.customer_country) as nc

select tts as ArrivalTime, ServiceType, StopCode  from rawEE2 
group by ArrivalTime, ServiceType, StopCode 
order by ArrivalTime, ServiceType, StopCode;
