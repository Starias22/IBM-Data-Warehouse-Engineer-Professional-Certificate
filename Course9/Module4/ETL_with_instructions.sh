#!/bin/sh
MYSQL_PASSWORD=USZcIbnut8E6qtXopgRQusDG
MYSQL_DB=sales
MYSQL_TABLE=sales_data
SALES_FILE=/home/project/sales.csv
SALES_TEMP_FILE=/home/project/temp_sales_commas.csv
DIM_DATE_FILE=/home/project/DimDate.csv
FACT_SALES_FILE=/home/project/FactSales.csv
PGHOST=postgres


## Write your code here to load the data from sales_data table in Mysql server to a sales.csv.Select the data which is not more than 4 hours old from the current time.

#Hint: To load the data from a table to a csv file you can refer to the following example syntax:
mysql -h mysql -P 3306 -u root --password=$MYSQL_PASSWORD --database=$MYSQL_DB --execute="select * from $MYSQL_TABLE" --batch --silent > $SALES_FILE

#This command connects to a MySQL server, executes a SELECT query to fetch specific columns from a specified table in a database, and saves the query results as a CSV file.

#The output options --batch: Causes MySQL to output rows with tab-separated values. This is useful for scripting.

#--silent: Suppresses the display of query output.

#The csv generated will have tabs. We then replace all the tabs by commas by executing the command below:

tr '\t' ',' < $SALES_FILE >  $SALES_TEMP_FILE


# Move the temporary file with commas to the original file location
mv $SALES_TEMP_FILE $SALES_FILE


export PGPASSWORD=YG5WsiqE2ICLPB3sxSvuM4jM


psql --username=postgres --host=$PGHOST --dbname=sales_new -c "\COPY sales_data(rowid,product_id,customer_id,price,quantity,timestamp) FROM '$SALES_FILE' delimiter ',' csv header;" 




## Delete sales.csv present in location /home/project
rm $SALES_FILE

## Write your code here to load the DimDate table from the data present in sales_data table
#dateid int,day varchar(20),month varchar(30),year varchar(5)
psql --username=postgres --host=$PGHOST --dbname=sales_new -c  "INSERT INTO DimDate(dateid, day, month, year)  SELECT dateid, to_char(timestamp, 'DAY'), to_char(timestamp, 'mon'), to_char(timestamp, 'year') FROM sales_data;"

## Write your code here to load the FactSales table from the data present in sales_data table

#FactSales(rowid int,product_id int,customer_id int,price decimal,total_price decimal);

psql --username=postgres --host=$PGHOST --dbname=sales_new -c  "INSERT INTO FactSales SELECT rowid, product_id customer_id, price, quantity*price as total_price FROM sales_data;"

## Write your code here to export DimDate table to a csv

psql --username=postgres --host=$PGHOST --dbname=sales_new -c "\COPY DimDate TO '$DIM_DATE_FILE' DELIMITER ',' CSV HEADER;"

## Write your code here to export FactSales table to a csv
 
psql --username=postgres --host=$PGHOST --dbname=sales_new -c "\COPY FactSales TO '$FACT_SALES_FILE' DELIMITER ',' CSV HEADER;"

