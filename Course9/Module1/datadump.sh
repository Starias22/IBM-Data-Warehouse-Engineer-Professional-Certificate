#!/bin/bash

mysqldump --host=172.21.68.113 --port=3306 --user=root --password=oE2CGaCGBfydvGa6kCiAZBWu sales sales_data > sales_data.sql

echo "Data exported successfully to sales_data.sql."
