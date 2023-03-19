#!/bin/bash

FILE="app"

docker pull kprzystalski/projobj-pascal

docker run --rm -it -v "$(pwd)":/home/student/projobj/ kprzystalski/projobj-pascal:latest fpc $FILE.pas
echo
docker run --rm -it -v "$(pwd)":/home/student/projobj/ kprzystalski/projobj-pascal:latest ./$FILE