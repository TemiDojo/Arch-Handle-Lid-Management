#!/bin/zsh

lid_state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
laptop_display_status=$(swaymsg -t get_outputs | jq -r '.[] | select(.name=="eDP-1") | .dpms')


if [ "$lid_state" = "closed" ] && [ "$laptop_display_status" == "false" ]; then
    swaymsg output eDP-1 enable 
    systemctl suspend
