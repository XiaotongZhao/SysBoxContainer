#!/bin/bash
echo "change password"
USER_PASS=${LOCAL_USER_PASSWORD:-"smartide123.@IDE"}
USERNAME=smartide
echo "$USERNAME:$USER_PASS" | chpasswd &
exec "$@"
