## To create database
1. On docker container run `cd aplication`
2. `php bin/console doctrine:migrations:migrate`

## To run endpoint test 
1. On docker container run `symfony server:start`
2. Execute script `./api_tests.sh`