#!/bin/zsh


swaymsg -m -t subscribe '["output"]' | while read -r event; do
    output_list=$(swaymsg -t get_outputs | jq '[.[].name | select(. !="eDP-1")] | length')
    # trigger a script
    if [ "$output_list" -eq 0 ]; then
        lid_state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
        laptop_display_status=$(swaymsg -t get_outputs | jq -r '.[] | select(.name=="eDP-1") | .dpms')

        if [ "$lid_state" = "closed" ] && [ "$laptop_display_status" = "false" ]; then
            swaymsg output eDP-1 enable
            systemctl suspend
        fi
    fi


done

