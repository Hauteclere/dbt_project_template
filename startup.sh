#!/usr/bin/env bash

set -e

RED=$(tput setaf 1)
NORMAL=$(tput sgr0)
PROJECT_NAME=${PWD##*/}
PROJECT_DIR=${PWD}

if ! command -v uv >/dev/null 2>&1; then 
    printf "${RED}ERROR: UV package manager not found. ${NORMAL}"
    printf "\nAborting. Install UV with"
    printf "\n\n\tcurl -LsSf https://astral.sh/uv/install.sh | sh\n\n"
    printf "before running this script again!\n"
    exit 1
fi

uv init .
uv add dbt-duckdb
cat >> .gitignore <<EOL
*.duckdb
.env
EOL

echo "DBT_PROFILES_DIR=${PROJECT_DIR}/.dbt" >> .env
echo "export UV_ENV_FILE=${PROJECT_DIR}/.env" >> .venv/bin/activate
echo "export DBT_PROFILES_DIR=${PROJECT_DIR}/.dbt" >> .venv/bin/activate

mkdir .dbt
touch .dbt/profiles.yml

uv run --env-file .env dbt init "${PROJECT_NAME}"
mv ${PROJECT_NAME}/*
rm -r ${PROJECT_NAME}

cat > ./dbt_project.yml <<EOL
name: ${PROJECT_NAME}
version: '1.0'
config-version: 2

profile: ${PROJECT_NAME}

model-paths: ["models"]
EOL

cat > create_db.py << EOL
import duckdb
with duckdb.connect("dev.duckdb") as con:
    pass
EOL

uv run --env-file .env create_db.py

rm create_db.py

mkdir models

cat > ./models/schema.yml <<EOL
version: 2

sources:
- name: dev_db
  schema: main
  tables:
# - name: <insert_table_name_here>

EOL

rm -- "$0"
