# Matrix Deploy

Deployment repo for Matrix on `matrix.nu31.space`.

It stores only the local deploy config and pushes it into the official
`spantaleev/matrix-docker-ansible-deploy` checkout on `nu31forum`.

## What this repo does

- `inventory/hosts.template` renders the Ansible inventory for the Matrix server.
- `inventory/host_vars/matrix.nu31.space/vars.yml.template` renders the playbook host vars.
- `scripts/render-template.sh` renders `${VAR}` placeholders from environment variables.
- `.github/workflows/deploy.yml` syncs the rendered files to `nu31forum` and runs the playbook.

## What you need to deploy

GitHub `vars`:

- `HOST`
- `MATRIX_PLAYBOOK_MIGRATION_VALIDATED_VERSION`
- `MATRIX_DOMAIN`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_USER`
- `POSTGRES_DATABASE`

GitHub `secrets`:

- `ROOT_SSH_PRIVATE_KEY`
- `MATRIX_HOMESERVER_GENERIC_SECRET_KEY`
- `POSTGRES_PASSWORD`

## Target architecture

- Homeserver: Synapse
- Matrix domain: `nu31.space`
- Matrix server: `matrix.nu31.space`
- Base domain service discovery: `/.well-known/matrix/*` on `nu31.space`
- Public client UI: Cinny
- Fallback client: Element Web
- Admin UI: Synapse Admin
- Database: external PostgreSQL on `nu31-vm`
- Reverse proxy: playbook-managed Traefik fronted by `nu31-vm` Caddy

## External PostgreSQL

The Matrix playbook supports an external Postgres server, but it is not seamless:

- the integrated Postgres is disabled with `postgres_enabled: false`
- Synapse must get an explicit `matrix_synapse_database_*` configuration
- the database must be reachable from inside the Matrix containers
- the connection is not SSL encrypted in the current playbook
- TLS is terminated by `nu31-vm` Caddy, not by the Matrix playbook

For this setup, `nu31-vm` already exposes Postgres on `5432/tcp`.

## How deployment works

1. Render inventory and vars from templates.
2. Copy the rendered files to the playbook checkout on `nu31forum`.
3. Run `ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,start`.

## Local rendering

Create a `.env` file from the example, export the values, then render:

```bash
cp .env.example .env
set -a
. ./.env
set +a
sh scripts/render-template.sh
```

Then inspect:

- `rendered/inventory/hosts`
- `rendered/inventory/host_vars/matrix.nu31.space/vars.yml`

## Notes

- This repo assumes the playbook already exists at `/root/matrix-docker-ansible-deploy` on `nu31forum`.
- Do not commit rendered vars or real secrets.
- The external Postgres host should be a reachable hostname or IP from the Matrix containers.
