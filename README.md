# <img src=".repo/assets/icon-512x512.png"  width="52" height="52"> TrivialSec

[![pipeline status](https://gitlab.com/trivialsec/mysql/badges/main/pipeline.svg)](https://gitlab.com/trivialsec/mysql/commits/main)

## Production DR - Mysql main and replica

- Ensure you run `make setup` to create docker volumes
- Start `docker-compose up -d mysql-main` but don't run any create statements yet
- then connect and run `GRANT REPLICATION REPLICA ON *.* TO "root"@"%"; FLUSH PRIVILEGES;`
- then run `SHOW MASTER STATUS \G` and note the log file and position
- Start `docker-compose up -d mysql-replica`
- Get the master password `aws ssm get-parameter --name '/Prod/Deploy/trivialsec/mysql_main_password' --output text --with-decryption --query 'Parameter.Value'`
- then connect and run:
```sql
STOP REPLICA;
CHANGE MASTER TO SOURCE_HOST='prd-main.trivialsec.com', SOURCE_USER='root', SOURCE_PASSWORD='', SOURCE_LOG_FILE='mysql-bin.000001', SOURCE_LOG_POS=0, GET_SOURCE_PUBLIC_KEY=1;
START REPLICA;
```
- Run `SHOW REPLICA STATUS` and check everything is correct
- connect to main and run `backup.sql`
- connect to replica and confirm schema and data replicated

## Docker (local) - Mysql main and replica

- Ensure you run `make setup` to create docker volumes
- Start `make up` but don't run any create statements yet
- then connect and run `GRANT REPLICATION SLAVE ON *.* TO "root"@"%"; FLUSH PRIVILEGES;`
- then run `SHOW MASTER STATUS` and note the log file and position
- Start `docker-compose up -d mysql-replica`
- then connect and run `CHANGE MASTER TO MASTER_HOST='mysql-main', MASTER_USER='root', MASTER_PASSWORD='<your password>', MASTER_LOG_FILE='<log file from main>', MASTER_LOG_POS=<position from main>, GET_MASTER_PUBLIC_KEY=1; START SLAVE`
- Run `SHOW SLAVE STATUS` check `slave_sql_running_state` (should be "Replica has read all relay log; waiting for more updates")
- connect to main and run `schema.sql` and `init-data.sql`
- connect to replica and confirm schema and data replicated

### Troubleshoot replication

Replace `SLAVE` with `REPLICA` and `GET_MASTER_PUBLIC_KEY` with `GET_SOURCE_PUBLIC_KEY` for prod (TODO; temporary until Docker gets updated to MariaDB)

```sql
STOP SLAVE;
RESET SLAVE;
DROP SCHEMA trivialsec;

CHANGE MASTER TO 
	MASTER_HOST='<host>', 
	MASTER_USER='root', 
	MASTER_PASSWORD='<pwd>', 
	MASTER_LOG_FILE='<from master>',
	MASTER_LOG_POS=<int from master>, 
	GET_MASTER_PUBLIC_KEY=1;

START SLAVE;

SHOW SLAVE STATUS
-- for more error info
SELECT * FROM performance_schema.replication_applier_status_by_worker;

```