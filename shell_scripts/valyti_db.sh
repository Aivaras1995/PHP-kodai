docker#!/bin/bash
date=$(date +%F)

# Copy necessary files to the server
docker cp sql_failai d001-db-1:/tmp
docker cp shell_scripts d001-db-1:/tmp
docker exec -it d001-db-1 /bin/sh -c "chmod +x /tmp/shell_scripts/*.sh"

# Create backup
docker exec -it d001-db-1 /bin/sh -c "./tmp/shell_scripts/create_DB_backup.sh"
docker cp d001-db-1:/tmp/mysql-backup-2023-01-11.sql ../sql_failai

# Cleanup DB
docker exec -it d001-db-1 /bin/sh -c "./tmp/shell_scripts/reset_mysql.sh"

read -p "Are you sure you want to Create default MySQL databases? This action cannot be undone. [y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi
# Prepare default data
#docker exec -it d001-db-1 /bin/sh -c "mysql -u root -proot < /tmp/sql_failai/mysql-backup-$date.sql"
docker exec -it d001-db-1 /bin/sh -c "mysql -u root -proot < /tmp/sql_failai/create_schemas.sql"
docker exec -it d001-db-1 /bin/sh -c "mysql -u root -proot < /tmp/sql_failai/add_data.sql"
echo "Darbas baigtas"