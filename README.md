# DBT Local Dev Template Script

This script sets up a local DBT development environment. To use:

1. Clone this repo down, targeting a directory named for your project:
    ```bash
    git clone https://github.com/Hauteclere/dbt_project_template.git <your_project_name_here> && cd $_
    ```
2. Run the startup script:
    ```bash
    ./startup.sh
    ```
3. Write a script to populate your database, update the `./models/schema.yml`, and get going with your models!