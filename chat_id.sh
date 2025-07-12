#!/bin/bash

#curl -s "https://api.telegram.org/bot8054960601:AAFk1KglVIOGZWrRd1fkL7B3E9y438X446I/getUpdates" \
#| jq '.result[].message.chat.id'

BOT_TOKEN="8054960601:AAFk1KglVIOGZWrRd1fkL7B3E9y438X446I"

curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates"
