#!/bin/bash

## Autor: 4Teams | Rodrigo (Apoc)
## Created: 03/06/2020
## Version: v1.0
## Last update:

# Steam Update #
echo "############################################"
echo "#### Verificando Atualizações 4Teams SM ####"
echo "############################################"

git pull

cat base.sh >> ~/.4tsm
chmod +x ~/.4tsm

nohup bash ~/.4tsm &> /dev/null &