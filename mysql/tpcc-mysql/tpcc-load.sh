PASSWD=$1
DBNAME=$2
WH=$3

cd /root/tpcc-mysql

# Create DB
echo "Create DB"
mysql -u root -p $PASSWD -e "create database $DBNAME;"
mysql -u root -p $PASSWD $DBNAME < create_table.sql
mysql -u root -p $PASSWD $DBNAME < add_fkey_idx.sql

# Load data
echo "Load data"
./tpcc_load 127.0.0.1 $DBNAME root "$PASSWD" $WH
