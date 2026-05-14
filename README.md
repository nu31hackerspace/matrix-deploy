# Matrix Deploy

Deploy config for `matrix.nu31.space`.

## Requires

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

## What it does

- renders `inventory/hosts`
- renders `inventory/host_vars/matrix.nu31.space/vars.yml`
- syncs them to `nu31forum`
- pulls `spantaleev/matrix-docker-ansible-deploy`
- installs Ansible roles
- runs `ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,start`
