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
	"access_token": "eyJhbGciOiJSUzI1NiIsImlzcyI6InNlbGYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJzZWxmIiwic3ViIjoibWFzdGVyLWFjY291bnQiLCJhdWQiOiJodHRwczovL3JvY2tldC1hcGkucGFyYW5vaWQuc29mdHdhcmUiLCJpYXQiOjE2NjcyNTI3NzgsImV4cCI6MTY2NzI5NTk3OCwic2NvcGUiOiJyZWFkOmFjY291bnRzIGNyZWF0ZTphY2NvdW50cyBtb2RpZnk6YWNjb3VudHMtc2NvcGUgbW9kaWZ5OmFjY291bnRzLWFwcGxpY2F0aW9ucy1zY29wZSBkZWxldGU6YWNjb3VudHMgcmVhZDphcHBsaWNhdGlvbnMgY3JlYXRlOmFwcGxpY2F0aW9ucyBtb2RpZnk6YXBwbGljYXRpb25zIGRlbGV0ZTphcHBsaWNhdGlvbnMgcmVhZDpvYmplY3RzLW1ldGEgbW9kaWZ5Om9iamVjdHMtbWV0YSByZWFkOm9iamVjdHMgY3JlYXRlOm9iamVjdHMgbW9kaWZ5Om9iamVjdHMgZGVsZXRlOm9iamVjdHMifQ.KlEPhlQiGxuJTcCuTpt5ddRmF8jqeJ3kS4QRIyYJTWfp4QlBqfaoVnvQhbhLg7yj5Kl2XVkxvUZAiFtf2EUMWRjKeAuSxRh_9mRTLtWI8eGUhhBfXoR-5_gbotGk_XB7xXlY1Qds4UBlkZDk-LV2BTKba3UbyINeS5MO1rIytgDWQiGwzieZuhXQUlKUW82PLkmr4c01ZGyxhB0YMGp9LcSU8L3B6VGJesfIDd2JhXoNW6dtYD7i-DNvnEnsTV9yfS3wigLj5ZaA_pidgQlTmPK7XNdlUd96V4mK_LkfdQ1S5KfXELDrWii8oGEWhmKJNYmkaeHCTTchNyS_wxpgmQ",
	"expires_in": 43200,
	"scope": "read:accounts create:accounts modify:accounts-scope modify:accounts-applications-scope delete:accounts read:applications create:applications modify:applications delete:applications read:objects-meta modify:objects-meta read:objects create:objects modify:objects delete:objects",
	"token_type": "Bearer"
}
```


