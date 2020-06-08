#!/bin/bash

## Autor: 4Teams | Rodrigo (Apoc)
## Created: 03/06/2020
## Version: v1.1
## Last update: 08/06/2020

# 4Teams SM Update #
cd /home/ubuntu/4TSM_v1

clear
echo "############################################"
echo "#### Verificando Atualizações 4Teams SM ####"
echo "############################################"

echo ""
echo "Apagando arquivos antigos..."
rm ~/.4tsm

echo ""
echo "Baixando versão atual..."
git pull
sleep 2

echo ""
echo "Atualização completa!"
cat base.sh >> ~/.4tsm
chmod +x ~/.4tsm

cd
bash ~/.4tsm
