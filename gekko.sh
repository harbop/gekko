#!/bin/bash

logdir=/var/log/gekko
logfile=$logdir/gekko.log

function makeGekkoStartOnReboot {
        echo "@reboot /root/gekko/gekko.sh" >> /var/spool/cron/crontabs/root
}

function installNode {
        # possible one time setup of environment
        sudo apt-get update

        # patch in correct version of node (default is 4.x we need 6.x)
        curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
        sudo apt-get -y install nodejs
}

function startGekko {
        cd /root/gekko        

        # create log dir
        mkdir $logdir

        # set up logrotate
        cp logrotage.gekko /etc/logrotate.d/gekko

        # begin gekko specific stuff
        npm install --only=production 2>&1 | tee -a $logfile

        # make sure we have prefetched data
        node gekko --config config-prod.js --import 2>&1 | tee -a $logfile

        # start the trader
        node gekko --config config-prod.js 2>&1 | tee -a $logfile
}

installNode
startGekko
