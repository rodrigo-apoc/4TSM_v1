#!/bin/bash

## Autor: 4Teams | Rodrigo (Apoc)
## Created: 03/06/2020
## Version: v1.0
## Last update:

# 4Teams SM Update #
clear
echo "############################################"
echo "#### Verificando Atualizações 4Teams SM ####"
echo "############################################"

echo ""
echo "Apagando arquivos antigos..."
rm ~/.4tsm

echo ""
echo "Baixando versão atual..."
git pull >> /dev/null
sleep 2

echo ""
echo "Atualização completa!"
cat base.sh >> ~/.4tsm
chmod +x ~/.4tsm

bash ~/.4tsm