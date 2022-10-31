# Rocket deployment using docker compose

Rocket is distributed under a propietary license in the form of docker images that can be pulled form a private repository located on Google Cloud Platform.

In order to be able to deploy its components you must get a service account key file from Paranoid Software at https://paranoid.software/rocket with read access permissions over your purchased version(s).

## Before we start

It is important that you review the following requirements:

- GIT to clone this repo (optional; you can also just download it)
- Docker and Docker Compose
- A valid service account to access the private repository(s)
- Identify the images and tags (allowed versions) for:
  - Rocket API
  - Rocket Bridge
  - Rocket Indexer
- A running MongoDB instance (optional*)
- A running Elasticsearch instance (optional*)
- A running RabbitMQ instance (optional*)

> (*) This guide includes a docker-compose.yaml file with services for MongoDB, Elasticsearch and RabbitMQ

## Step by step deployment

1. Loging to the private repository by issuing the following command:

Linux / Mac
```bash
cat <KEY-FILE.json> | docker login -u _json_key --password-stdin https://<HOSTNAME>
```

Windows

```powershell
Get-Content <KEY-FILE.json> |
docker login -u _json_key --password-stdin https://<HOSTNAME>
```

2. Clone or download this repo
3. Request images names and tags available for your service account
4. Modify .env file to specify image name and tags to deploy

.env file sample

```
ROCKET_API_DOCKER_IMAGE=https://private.registry.com/rocket-api:latest
ROCKET_BRIDGE_DOCKER_IMAGE=https://private.registry.com/rocket-bridge:latest
ROCKET_INDEXER_DOCKER_IMAGE=https://private.registry.com/rocket-indexer:latest
```

5. Review and modify settings file if necessary. This files are located at its corresponding folders:

  - api (API settings and secrets)
  - bridge (Bridge settings and secrets)
  - indexer (indexer settings)

6. Execute the create-volumes.sh script file (From a linux capable terminal preferably). This script will create one volume for every component and will pre-populate them with its settings and secrets files accordingly.

7. Verify the volumes creation under the names:

  - rocket-api
  - rocket-bridge
  - rocket-indexer

8. Execute the deployment by running the following command:

```bash
docker-compose up -d
```
