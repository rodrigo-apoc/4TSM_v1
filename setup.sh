#!/bin/bash

## Autor: 4Teams | Rodrigo (Apoc)
## Created: 03/06/2020
## Version: v1.1
## Last update: 08/06/2020

# Create Dir #
mkdir ./tmp

# Alias #
echo "" >> ~/.profile
echo "alias 4teams=\"/home/ubuntu/4TSM_v1/update.sh\"" >> ~/.profile
echo "alias 4team=\"/home/ubuntu/4TSM_v1/update.sh\"" >> ~/.profile
echo "alias 4t=\"/home/ubuntu/4TSM_v1/update.sh\"" >> ~/.profile

. ~/.profile

# Permission #
chmod +x ./update.sh