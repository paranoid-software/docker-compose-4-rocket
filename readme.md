# Rocket deployment using docker compose

## Antes de empezar

1. Instalar Docker
2. Instalar GIT

## Paso a paso

1. Clonar repositorio https://github.com/paranoid-software/docker-compose-4-rocket
2. Solicitar llave para cuenta de servicio con acceso al repositorio
3. Iniciar sesión en docker con la llave obtenida

Windows

```bash
Get-Content KEY-FILE |
docker login -u _json_key --password-stdin https://HOSTNAME
```

Linux / Mac
```bash
cat KEY-FILE | docker login -u _json_key --password-stdin \
https://HOSTNAME
```

4. Crear archivo con variables de entorno (.env) para especificar el repositorio y las imagenes correspondientes
5. Ejecutar comando PULL para las imagenes (Recomendado antes de ejecutar docker-compose)
6. Ejecutar script para crear volumenes (create-volumes.sh), en el caso de windows ejecutar la creación de cada volumen por separado utilizando GIT Bash
7. Ejecutar comando docker-compose up -d
