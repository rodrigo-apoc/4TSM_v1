#!/bin/bash

## Autor: 4Teams.gg | Rodrigo (Apoc)
## Created: 03/06/2020
## Version: v1.0
## Last update:

export NEWT_COLORS='
#window=,red
#border=white,red
#textbox=white,red
#button=black,white
'

# Config #
start_log="./tmp/start.log"
stop_log="./tmp/stop.log"
update_log="./tmp/update.log"
start_lck_file="/home/csgoserver/lgsm/lock/csgoserver.lock"
details_log="./tmp/details.log"
admins_log="./tmp/admins.log"
tempfile1="./tmp/tempfile1.txt"

# Steam Update #
echo ""
echo "##############################################"
echo "#### Verificando Atualizações Steam/CS:GO ####"
echo "##############################################"
sudo su - csgoserver -c "./csgoserver update"

# Menu #
advancedMenu() {
        ADVSEL=$(whiptail --title "4Teams Server Manager v1.0" --fb --menu "O que deseja fazer?" 17 60 7 \
                "1" "Start teste" \
                "2" "Stop final"  \
                "3" "Restart"   \
                "4" "Infos" \
                "5" "Editar configs (incompleto)"    \
                "6" "Quit" 3>&1 1>&2 2>&3)
        case $ADVSEL in
                1)
                        startServer() {
                                passchoice=$(whiptail --title "Defina uma senha" --inputbox "Digite uma senha que será necessária para conectar ao server." --fb 10 60 3>&1 1>&2 2>&3)
                                statuspasschoice=$?
                                if [ $statuspasschoice = 0 ]; then
                                        nohup sudo su - csgoserver -c "sed -i '/sv_password/c\sv_password \"$passchoice\"' ./serverfiles/csgo/cfg/csgoserver.cfg" &>/dev/null &
                                fi
                                nohup sudo su - csgoserver -c "./csgoserver start" &> $start_log &
                                {
                                        for ((i = 0 ; i <= 100 ; i+=1)); do
                                                if [[ $i -gt 80 ]]; then
                                                        if [[ $(ps -ef |grep 'start'|grep 'sudo') ]]; then
                                                                sleep 2
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                else
                                                        if [[ $(ps -ef |grep 'start'|grep 'sudo') ]]; then
                                                                sleep 0.4
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                fi
                                        done
                                } | whiptail --gauge "Iniciando servidor..." 6 50 0

                                whiptail --title "Start" --msgbox "O servidor foi iniciado, prossiga para visualizar detalhes." 8 45
                                nohup sudo su - csgoserver -c "./csgoserver details" &> $details_log &
                                {
                                        for ((i = 0 ; i <= 100 ; i+=1)); do
                                                if [[ $i -gt 80 ]]; then
                                                        if [[ $(ps -ef |grep 'details'|grep 'sudo') ]]; then
                                                                sleep 2
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                else
                                                        if [[ $(ps -ef |grep 'details'|grep 'sudo') ]]; then
                                                                sleep 0.2
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                fi
                                        done
                                } | whiptail --gauge "Reunindo informações..." 6 50 0

                                server_name=$(grep -e 'Server name:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Server name:' '{print $2}')
                                server_ip=$(grep -m 1 -e 'Internet IP:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Internet IP:' '{print $2}')
                                server_password=$(grep -e 'Server password:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Server password:' '{print $2}')
                                server_cmap=$(grep -e 'Current map:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Current map:' '{print $2}')
                                server_tick=$(grep -e 'Tick rate:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Tick rate:' '{print $2}')
                                server_status=$(grep -m 1 -e 'Status:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Status:' '{print $2}')

                                echo "Server Name: $server_name" >> $tempfile1
                                echo "Internet IP: $server_ip" >> $tempfile1
                                echo "Server password: $server_password" >> $tempfile1
                                echo "Current map: $server_cmap" >> $tempfile1
                                echo "Tick rate: $server_tick" >> $tempfile1
                                echo "Status: $server_status" >> $tempfile1
                                echo "" >> $tempfile1
                                echo "Copie e cole no console do CS:\nconnect$server_ip;password$server_password" >> $tempfile1

                                whiptail --title "Infos do Servidor" --textbox $tempfile1 15 55 --scrolltext

                                rm $start_log &>/dev/null
                                rm $details_log &>/dev/null
                                rm $tempfile1 &>/dev/null

                                advancedMenu
                        }

                        if [ -f $start_lck_file ]; then
                                whiptail --title "AVISO" --msgbox "O servidor já está Online!\nTente conectar ou use a opção \"Restart\"." 10 75
                                advancedMenu
                        else
                                mapname=$(grep -e 'defaultmap=' -n /home/csgoserver/lgsm/config-lgsm/csgoserver/csgoserver.cfg| awk -F 'defaultmap=' '{print $2}')
                                tick=$(grep -e 'tickrate=' -n /home/csgoserver/lgsm/config-lgsm/csgoserver/csgoserver.cfg| awk -F 'tickrate=' '{print $2}')
                                if whiptail --title "4Teams Server Manager v1.0" --yesno "O mapa que será iniciado é: $mapname\nO tickrate será: $tick\nDeseja alterar?" 12 50; then
                                        mapchoice=$(whiptail --title "Escolha o mapa" --inputbox "Digite o nome do mapa que deseja iniciar, exemplo: de_inferno" --fb 10 60 3>&1 1>&2 2>&3)
                                        statusmapchoice=$?
                                        if [ $statusmapchoice = 0 ]; then
                                                nohup sudo su - csgoserver -c "sed -i '/defaultmap=/c\defaultmap=\"$mapchoice\"' ./lgsm/config-lgsm/csgoserver/csgoserver.cfg" &>/dev/null &
                                        fi
                                        tickratechoice=$(whiptail --title "Escolha o mapa" --inputbox "Digite o tickrate que deseja iniciar, exemplo: 128" --fb 10 60 3>&1 1>&2 2>&3)
                                        statustickratechoice=$?
                                        if [ $statustickratechoice = 0 ]; then
                                                nohup sudo su - csgoserver -c "sed -i '/tickrate=/c\tickrate=\"$tickratechoice\"' ./lgsm/config-lgsm/csgoserver/csgoserver.cfg" &>/dev/null &
                                        fi
                                        startServer
                                else
                                        startServer
                                fi
                        fi
                ;;
                2)
                        if [ -f $start_lck_file ]; then
                                nohup sudo su - csgoserver -c "./csgoserver stop" &> /dev/null &
                                {
                                        for ((i = 0 ; i <= 100 ; i+=1)); do
                                                if [[ $i -gt 80 ]]; then
                                                        if [[ $(ps -ef |grep 'stop'|grep 'sudo') ]]; then
                                                                sleep 2
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                else
                                                        if [[ $(ps -ef |grep 'stop'|grep 'sudo') ]]; then
                                                                sleep 0.4
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                fi
                                        done
                                } | whiptail --gauge "Parando servidor..." 6 50 0
                        else
                                whiptail --title "AVISO" --msgbox "O servidor já está Offline!" 10 60
                                advancedMenu
                        fi
                ;;
                3)
                        if [ -f $start_lck_file ]; then
                                nohup sudo su - csgoserver -c "./csgoserver restart" &> /dev/null &
                                {
                                        for ((i = 0 ; i <= 100 ; i+=1)); do
                                                if [[ $i -gt 80 ]]; then
                                                        if [[ $(ps -ef |grep 'restart'|grep 'sudo') ]]; then
                                                                sleep 2
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                else
                                                        if [[ $(ps -ef |grep 'restart'|grep 'sudo') ]]; then
                                                                sleep 0.6
                                                                echo $i
                                                        else
                                                                echo $i
                                                        fi
                                                fi
                                        done
                                } | whiptail --gauge "Reiniciando servidor..." 6 50 0
                        else
                                whiptail --title "AVISO" --msgbox "O servidor está Offline!" 10 60
                                advancedMenu
                        fi
                ;;
                4)
                        nohup sudo su - csgoserver -c "./csgoserver details" &> $details_log &
                        {
                                for ((i = 0 ; i <= 100 ; i+=1)); do
                                        if [[ $i -gt 80 ]]; then
                                                if [[ $(ps -ef |grep 'details'|grep 'sudo') ]]; then
                                                        sleep 2
                                                        echo $i
                                                else
                                                        echo $i
                                                fi
                                        else
                                                if [[ $(ps -ef |grep 'details'|grep 'sudo') ]]; then
                                                        sleep 0.2
                                                        echo $i
                                                else
                                                        echo $i
                                                fi
                                        fi
                                done
                        } | whiptail --gauge "Reunindo informações..." 6 50 0

                        server_name=$(grep -e 'Server name:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Server name:' '{print $2}')
                        server_ip=$(grep -m 1 -e 'Internet IP:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Internet IP:' '{print $2}')
                        server_password=$(grep -e 'Server password:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Server password:' '{print $2}')
                        server_cmap=$(grep -e 'Current map:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Current map:' '{print $2}')
                        server_tick=$(grep -e 'Tick rate:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Tick rate:' '{print $2}')
                        server_status=$(grep -m 1 -e 'Status:' -n $details_log| sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"| awk -F 'Status:' '{print $2}')

                        echo "Server Name: $server_name" >> $tempfile1
                        echo "Internet IP: $server_ip" >> $tempfile1
                        echo "Server password: $server_password" >> $tempfile1
                        echo "Current map: $server_cmap" >> $tempfile1
                        echo "Tick rate: $server_tick" >> $tempfile1
                        echo "Status: $server_status" >> $tempfile1
                        echo "" >> $tempfile1
                        echo "Copie e cole no console do CS:\nconnect$server_ip;password$server_password" >> $tempfile1

                        whiptail --title "Infos do Servidor" --textbox $tempfile1 15 55 --scrolltext

                        rm $details_log &>/dev/null
                        rm $tempfile1 &>/dev/null

                        advancedMenu
                ;;
                5)
                        if whiptail --title "AVISO" --yesno "Não edite essas configurações sem verificar os passos no manual.\nAs mudanças registradas aqui afetam diretamente na jogabilidade do servidor.\nDeseja prosseguir?" 12 70; then
                                editconfigMenu() {
                                        ADVSEL=$(whiptail --title "CS:GO Server Manager" --fb --menu "O que deseja fazer?" 17 60 7 \
                                                "1" "Adicionar admin"   \
                                                "2" "Remover admin"     \
                                                "3" "Listar admins"     \
                                                "4" "Voltar"    \
                                                "5" "Quit" 3>&1 1>&2 2>&3)
                                        case $ADVSEL in
                                                1)
                                                        steamid=$(whiptail --title "Adicionar admin" --inputbox "Insira o SteamID do usuário.\nDeve seguir o modelo: STEAM_9:9:999999999" --fb 10 60 3>&1 1>&2 2>&3)
                                                        statussteamid=$?
                                                        if [ $statussteamid = 0 ]; then
                                                                username=$(whiptail --title "Adicionar admin" --inputbox "Insira o nickname do usuário.\nEste mesmo nickname deverá ser usado para remover o cargo de admin do usuário." --fb 15 60 3>&1 1>&2 2>&3)
                                                                statususername=$?
                                                                if [ $statususername = 0 ]; then
                                                                        nohup sudo su - csgoserver -c "echo '\"$steamid\"' '\"z\"' //$username >> ./serverfiles/csgo/addons/sourcemod/configs/admins_simple.ini" &>/dev/null &
                                                                        editconfigMenu
                                                                else
                                                                        editconfigMenu
                                                                fi
                                                        else
                                                                editconfigMenu
                                                        fi
                                                ;;
                                                2)
                                                        remuser=$(whiptail --title "Remover admin" --inputbox "Insira o nickname do usuário que deseja remover do cargo de admin.\nO mesmo nickname que foi usado para adicionar, deve ser usado para remover." --fb 10 60 3>&1 1>&2 2>&3)
                                                        statusremuser=$?
                                                        if [ $statusremuser = 0 ]; then
                                                                nohup sudo su - csgoserver -c "sed -i '/$remuser/d' ./serverfiles/csgo/addons/sourcemod/configs/admins_simple.ini" &>/dev/null &
                                                                editconfigMenu
                                                        else
                                                                editconfigMenu
                                                        fi
                                                ;;
                                                3)
                                                        adminslist=$(sudo grep "##" /home/csgoserver/serverfiles/csgo/addons/sourcemod/configs/admins_simple.ini | awk -F '//' '{print $2}' | awk -F '##' '{print $1}')
                                                        echo $adminslist >> $admins_log
                                                        whiptail --title "Lista de Admins" --textbox $admins_log 14 27 --scrolltext
                                                        rm $admins_log &>/dev/null
                                                ;;
                                                4)
                                                        advancedMenu
                                                ;;
                                                5)
                                                        exit 1
                                                ;;
                                        esac
                                }
                                editconfigMenu
                        else
                                advancedMenu
                        fi
                ;;
                6)
                        exit 1
                ;;
        esac
        clear
}

advancedMenu
