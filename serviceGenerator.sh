#!/bin/bash

FILE_NAME="toggleTouchPad.service"
USER=$(whoami)

rm -f $FILE_NAME

echo "[Unit]" >> $FILE_NAME
echo "Description=Toggles Touch Pad When Mouse is Connected or Disconnected" >> $FILE_NAME
echo "After=graphical-session.target graphical.target" >> $FILE_NAME
echo "" >> $FILE_NAME
echo "[Service]" >> $FILE_NAME
echo "Environment="DISPLAY=:0"" >> $FILE_NAME
echo "ExecStart=/home/${USER}/.touchPadService/toggleTouchPad.sh" >> $FILE_NAME
echo "Type=simple" >> $FILE_NAME
echo "#User=$USER" >> $FILE_NAME
echo "#Group=$USER" >> $FILE_NAME
# echo "User=$USER" >> $FILE_NAME
# echo "Group=$USER" >> $FILE_NAME
echo "Restart=on-failure" >> $FILE_NAME
echo "" >> $FILE_NAME
echo "[Install]" >> $FILE_NAME
echo "WantedBy=default.target" >> $FILE_NAME
echo "Alias=$FILE_NAME" >> $FILE_NAME
