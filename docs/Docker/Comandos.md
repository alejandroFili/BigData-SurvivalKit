# Comandos

## Compose UP

>[!Warning] El el .yml es docker-compose.yml

!!! warning "el .yml es docker-compose.yml"

```bash
docker compose up -d
```

>[!Warning] El el .yml tiene nombre especifico

!!! warning "El el .yml tiene nombre especifico"

```bash
docker compose -f etsiinf-jupydbt.yml up -d
```

## Health

>[!Info] Tambien se puede ver en docker desktop

!!! info "tambien se puede ver en docker desktop"

>[!Warning] El el .yml es docker-compose.yml

!!! warning "el .yml es docker-compose.yml"

```bash
docker compose ps -a
```


>[!Warning] El el .yml tiene nombre especifico

!!! warning "El el .yml tiene nombre especifico"

```bash
docker compose -f etsiinf-jupydbt.yml ps -a
```

## Compose DOWN

```bash
docker compose down
```

## Conexion terminal

```bash
docker exec it <name of container> /bin/bash
```

## Logs

[LINK Documentacion](https://docs.docker.com/reference/cli/docker/container/logs/)

```bash
docker logs -f <name of container>
```

```bash
-f : follow
```

!!! Warning Guardar los logs en windows:

Necesitas powershell

```bash
docker logs -ft ksqldb-server 2>&1 | tee logs_v2.txt
```

## Copy


>[!Warning] Abre una terminal en la carpeta del fichero. Ahorras escribir la ruta

!!! warning  Abre una terminal en la carpeta del fichero. Ahorras escribir la ruta

>[!Danger] location NO acaba en /

!!! danger location NO acaba en /

```bash
docker cp file dockerName:location
```

## Kafka

### Conexion CLI

#### Bash
```bash
docker exec -it ksqldb-cli /bin/sh
```

#### KSQL
```bash
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
```

### Conexion Server

>[!Danger] Solo si necesitas importar algun fichero, para moverlo etc

!!! danger " Solo si necesitas importar algun fichero, para moverlo etc"

```bash
docker exec -it ksqldb-server /bin/bash
```