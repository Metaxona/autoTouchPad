#!/bin/bash

INTERVAL_IN_SECONDS=5
LOG_MAX_LINES_PRESERVED=1000

IS_SINGLE_EXEC=false

LOG_FILE=/home/$(whoami)/.touchPadService/log/service.log

if [ "$1" = "-s" ]; then
    IS_SINGLE_EXEC=true
fi

getLineCount(){
    # return `wc -l "$1" | sed "s/\s\/var\/log\/touchPadService\/service\.log//"`
    return `wc -l "$1" | sed "s/\s\/home\/$(whoami)\/\.touchPadService\/log\/service\.log//"`
}

log() {
    if [ $IS_SINGLE_EXEC = false ] && [ -f $LOG_FILE ]; then
        echo "[$(date)] $1" >> $LOG_FILE
        
        LINE_COUNT= getLineCount $LOG_FILE
        
        echo "$(tail -n $LOG_MAX_LINES_PRESERVED $LOG_FILE)" > $LOG_FILE 

    else
        echo "[$(date)] $1"
    fi
}

log_event() {
    log "[$(date)] TouchPad is $1"
}

execute() {
    
    local TOUCHPAD_ID=$1
    local MOUSE_ID=$2

    log "TOUCHPAD ID : $TOUCHPAD_ID | MOUSE ID: $MOUSE_ID"

    if [ ! $MOUSE_ID ]; then
        log "MOUSE NOT FOUND KEEPING TOUCHPAD ACTIVE"
        xinput enable $TOUCHPAD_ID
        log_event "ENABlED"
        return
    fi

    TOUCHPAD_IS_ENABLED=`xinput list-props ${TOUCHPAD_ID} | grep "Device Enabled"`
    MOUSE_IS_ENABLED=`xinput list-props ${MOUSE_ID} | grep "Device Enabled"`

    IS_TP_ENABLED=${TOUCHPAD_IS_ENABLED: -1}
    IS_M_ENABLED=${MOUSE_IS_ENABLED: -1}

    log "CURRENT STATES > TOUCHPAD: $IS_TP_ENABLED | MOUSE ID: $IS_M_ENABLED"

    if [[ $IS_M_ENABLED -gt 0 ]]; then
        xinput disable $TOUCHPAD_ID
        log_event "DISABLED"
    else
        xinput enable $TOUCHPAD_ID
        log_event "ENABlED"
    fi

    TOUCHPAD_IS_ENABLED=`xinput list-props ${TOUCHPAD_ID} | grep "Device Enabled"`
    MOUSE_IS_ENABLED=`xinput list-props ${MOUSE_ID} | grep "Device Enabled"`

    log "UPDATED STATES > TOUCHPAD: $IS_TP_ENABLED | MOUSE ID: $IS_M_ENABLED"

}

DEVICE_TOUCHPAD_ID=`xinput list | grep "TouchPad" | grep -P 'id=\d+' -o | sed 's/id=//'`
DEVICE_MOUSE_ID=`xinput list | grep -P "(Wireless\s*Receiver|Mouse)" | grep -v "Keyboard" | grep -P 'id=\d+' -o | sed 's/id=//'`

if [ "$1" = "-s" ]; then
    
        # Running In Single Execution Mode

        log "Running In Single Execution Mode"

        execute $DEVICE_TOUCHPAD_ID $DEVICE_MOUSE_ID

else

    # Running In Service Execution Mode
        
    while true; do 

        log "Running In Service Mode"

        execute $DEVICE_TOUCHPAD_ID $DEVICE_MOUSE_ID

        sleep $INTERVAL_IN_SECONDS

    done
fi
