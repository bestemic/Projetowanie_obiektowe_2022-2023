#!/bin/bash

endpoint="http://localhost:8000/api/product"

echo "Preparing database"

cd aplication/var/

cp data.db data_back.db

sqlite3 data.db "
DROP TABLE product;
CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255),
    price DOUBLE PRECISION
);
"
cd ../../

echo "Testing POST..."

status=$(curl -X POST -H "Content-Type: application/json" -d "{\"name\": \"Bread\", \"price\": 15}" $endpoint --silent -o out.json --write-out %{http_code})

if [[ $status == 200 ]]; then
  echo "{\"id\":1,\"name\":\"Bread\",\"price\":15}" >>expected.json
  result=$(diff -y -w expected.json out.json)
  if [[ $? -eq 0 ]]; then
    echo "OK"
  else
    echo "Diff not the same"
    echo "$result"
  fi
  rm out.json
  rm expected.json
else
  echo "POST returned an error: $status"
fi

echo "Testing GET..."

status=$(curl -X GET $endpoint/1 --silent -o out.json --write-out %{http_code})

if [[ $status == 200 ]]; then
  echo "{\"id\":1,\"name\":\"Bread\",\"price\":15}" >>expected.json
  result=$(diff -y -w expected.json out.json)
  if [[ $? -eq 0 ]]; then
    echo "OK"
  else
    echo "Diff not the same"
    echo "$result"
  fi
  rm out.json
  rm expected.json
else
  echo "GET returned an error: $status"
fi

echo "Testing UPDATE..."

status=$(curl -X PUT -H "Content-Type: application/json" -d "{\"name\": \"Apple\", \"price\": 1.4}" $endpoint/1 --silent -o out.json --write-out %{http_code})

if [[ $status == 200 ]]; then
  echo "{\"id\":1,\"name\":\"Apple\",\"price\":1.4}" >>expected.json
  result=$(diff -y -w expected.json out.json)
  if [[ $? -eq 0 ]]; then
    echo "OK"
  else
    echo "Diff not the same"
    echo "$result"
  fi
  rm out.json
  rm expected.json
else
  echo "UPDATE returned an error: $status"
fi

echo "Testing DELETE..."

status=$(curl -X DELETE $endpoint/1 --silent -o /dev/null --write-out %{http_code})

if [[ $status == 200 ]]; then
  echo "OK"
else
  echo "DELETE returned an error: $status"
fi

cd aplication/var/
sqlite3 data.db "
INSERT INTO product VALUES (1, 'Book', 100);
INSERT INTO product VALUES (2, 'Pencil', 200);
"
cd ../../

echo "Testing GET ALL..."

status=$(curl -X GET $endpoint --silent -o out.json --write-out %{http_code})

if [[ $status == 200 ]]; then
  echo "[{\"id\":1,\"name\":\"Book\",\"price\":100},{\"id\":2,\"name\":\"Pencil\",\"price\":200}]" >>expected.json
  result=$(diff -y -w expected.json out.json)
  if [[ $? -eq 0 ]]; then
    echo "OK"
  else
    echo "Diff not the same"
    echo "$result"
  fi
  rm out.json
  rm expected.json
else
  echo "GET ALL returned an error: $status"
fi

echo "Restoring database"
cd aplication/var/
rm data.db
mv data_back.db data.db
