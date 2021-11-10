# <img src=".repo/assets/icon-512x512.png"  width="52" height="52"> TrivialSec

[![pipeline status](https://gitlab.com/trivialsec/forward-proxy/badges/main/pipeline.svg)](https://gitlab.com/trivialsec/forward-proxy/commits/main)


## Mysql main and replica

- Ensure you run `make setup` to create docker volumes
- Start `docker-compose up -d mysql-main` but don't run any create statements yet
- then connect and run `GRANT REPLICATION REPLICA ON *.* TO "root"@"%"; FLUSH PRIVILEGES;`
- then run `SHOW MASTER STATUS \G` and note the log file and position
- Start `docker-compose up -d mysql-replica`
- Get the master password `aws ssm get-parameter --name '/Prod/Deploy/trivialsec/mysql_main_password' --output text --with-decryption --query 'Parameter.Value'`
- then connect and run:
```sql
STOP REPLICA;
CHANGE MASTER TO SOURCE_HOST='prd-main.trivialsec.com', SOURCE_USER='root', SOURCE_PASSWORD='', SOURCE_LOG_FILE='mysql-bin.000001', SOURCE_LOG_POS=0 GET_SOURCE_PUBLIC_KEY=1;
START REPLICA;
```
- connect to main and run `schema.sql` and `init-data.sql`
- connect to replica and confirm schema and data replicated
