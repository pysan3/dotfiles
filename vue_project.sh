#!/bin/bash

if [ $1 = "install" ]; then
    sudo apt update
    sudo apt install nodejs -y
    sudo apt install npm

    sudo npm cache clean
    sudo npm install -g n
    sudo n stable

    sudo npm update -g npm

    sudo npm i -g @vue/cli
fi

sudo vue create frontend