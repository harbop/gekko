#!/bin/bash

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

        # begin gekko specific stuff
        npm install --only=production

        # make sure we have prefetched data
        node gekko --config config-prod.js --import

        # start the trader
        node gekko --config config-prod.js
}

installNode
startGekko

