#!/bin/sh

. /lib/functions.sh

load_config() {
  config_get TELEGRAM_BOT_TOKEN ipcam telegram_token
  config_get CHAT_ID ipcam chat_id
  # echo "TELEGRAM_TOKEN=$telegram_token CHAT_ID=$chat_id"
}

config_load ipcam
config_foreach load_config ipcam

curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": "'$CHAT_ID'", "text": "'"$1"'", "disable_notification": true}' \
     https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage


# curl -F document=@"$1" https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument?chat_id=$CHAT_ID

# curl -F photo=@"$1" https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendPhoto?chat_id=$CHAT_ID

