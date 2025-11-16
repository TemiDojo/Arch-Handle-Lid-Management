#!/bin/zsh


journalctl -f -u systemd-logind | grep --line-buffered "Lid" | while read -r line; do
    echo $line
    my_status=$(echo $line | awk '{printf $7}')
    echo "$my_status"
    output_list=$(swaymsg -t get_outputs | jq '[.[].name | select(. != "eDP-1")] | length')
    laptop_display_status=$(swaymsg -t get_outputs | jq -r '.[] | select(.name=="eDP-1") | .dpms')
    
    if [ "$my_status" = "closed." ] && [ "$output_list" -gt 0 ] && [ "$laptop_display_status" = "true" ]; then
        swaymsg output eDP-1 disable
    elif [ "$my_status" = "opened." ] && [ "$output_list" -gt 0 ] && [ "$laptop_display_status" = "false" ]; then
        swaymsg output eDP-1 enable
    fi

done
