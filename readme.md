# Rocket deployment using docker compose

Rocket is distributed under a propietary license in the form of docker images that can be pulled form a private repository located on Google Cloud Platform.

In order to be able to deploy its components you must get a service account key file from Paranoid Software at https://paranoid.software with read access permissions over your purchased version(s).

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
cat <KEY-FILE.json> |
docker login -u _json_key --password-stdin https://<HOSTNAME>
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

## Rocket master account

Rocket is a data service protected using JTW and in order to be able to create your access tokens you will need at least one master account secret.

That secret is located at **api/auth** folder under the name **master-account.cookie**, it can be any string but we recommend to be a complex and long string like this one:

```
WR%{7M-G-M[e(VwEAqFfXY4#+pV]2C%;#}=3?Ce?qi({RL;c5[Bu{aJ]27}pG3fe
```

When the deployment is finished you will be able to create your first token by issuing the following command:

```bash
curl --location --request POST 'http://localhost:9000/accounts/token' \
--header 'Content-Type: application/json' \
--data-raw '{
      "secret": "WR%{7M-G-M[e(VwEAqFfXY4#+pV]2C%;#}=3?Ce?qi({RL;c5[Bu{aJ]27}pG3fe",
      "grantType": "master"
    }'
```

The result to this command will be something like:

```json
{
	"access_token": "<access_token>",
	"expires_in": 43200,
	"scope": "read:accounts create:accounts modify:accounts-scope modify:accounts-applications-scope delete:accounts read:applications create:applications modify:applications delete:applications read:objects-meta modify:objects-meta read:objects create:objects modify:objects delete:objects",
	"token_type": "Bearer"
}
```

### Tokens signing and verification

Every token is signed and verified using the keypairs located at **api/auth** under the name **signing-keypair.json** and **verification-keypair.json**. You can always change this keypairs, but remember to update both of them so the verification can be done.

### Using your new token to create an application and your first object

With this master token you have the required scopes to manage all accounts, applications and objects. In order to create an application and one object on that application you just have to issue the following commands:

Creating hello_rocket application

```bash
curl --location --request POST 'http://localhost:9000/hello_rocket' \
--header 'Authorization: Bearer <access_token>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Hello Rocket",
    "description": "My first rocket application"
}'
```

Creating todo_list object

```bash
curl --location --request POST 'http://localhost:9000/hello_rocket/todo_list' \
--header 'Authorization: Bearer <access_token>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Document docker-compose 4 rocket repo",
    "taskType": "Documentation",
    "effort": 5
}'
```

Response

```bash
{"_id":"63604740cfc645c87a41d9c2"}
```

Querying all todo_list objects

```bash
curl --location --request GET 'http://localhost:9000/hello_rocket/todo_list' \
--header 'Authorization: Bearer <access_token>'
```

Response

```json
{
	"items": [{
		"_id": "63604740cfc645c87a41d9c2",
		"effort": 5,
		"name": "Document docker-compose 4 rocket repo",
		"rocket_meta": {
			"created_by": "master-account"
		},
		"taskType": "Documentation"
	}],
	"total": 1
}
```

Cleanning up

```bash
curl --location --request DELETE 'http://localhost:9000/hello_rocket' \
--header 'Authorization: Bearer <access_token>'
```

## Rocket field level encryption support

To be able to encrypt/decrypt stored data MongoDB needs a local master key that we call **cookie.monsta** which is located at **api/secrets** and **bridge/secrets** folder. This is a ramdom string stored in binary format.

## RabbitMQ, MongoDB and Elasticsearch

Rocket depends on this 3 components to work, that is why the docker-compose.yaml includes a service for each of this components, but as you can imagine it is not mandatory that you deploy this services; you can already have one instance of every one of them or any of them. 

In that case you just need to review the settings file to modify the corresponding connection parameters to your already deployed instances and finally modify your docker-compose.yaml file so the optional services to be removed before going up.

## Settings files in a nutshell

### API Settings

The API relies on a settings file with the structure and information like the one located at **api/config/settings.json**

Very important values in this file are those ones related to the connection parameters to MongoDb and Elasticsearch instances. They are for default configured to the services deployed by this docker compose but they can be changed to any instance you already have.

### Bridge Settings

The Bridge relies on a settings file with the structure and information like the one located at **bridge/Config/settings.json**

Very important values in this file are those ones related to the connections parameters to MongoDb and RabbitMQ instances. They are for default configured to the services deployed by this docker compose but they can be changed to any instance you already have.

### Indexer Settings

The Bridge relies on a settings file with the structure and information like the one located at **indexer/Config/settings.json**

Very important values in this file are those ones related to the connections parameters to Elasticsearch and RabbitMQ instances. They are for default configured to the services deployed by this docker compose but they can be changed to any instance you already have.
