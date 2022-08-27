#!/bin/sh

. /lib/functions.sh

load_config() {
  config_get TELEGRAM_BOT_TOKEN ipcam telegram_token
  config_get CHAT_ID ipcam chat_id
  # echo "TELEGRAM_TOKEN=$telegram_token CHAT_ID=$chat_id"
}

config_load ipcam
config_foreach load_config ipcam

# curl -F document=@"$1" https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument?chat_id=$CHAT_ID

curl -F video=@"$1" https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendVideo?chat_id=$CHAT_ID

