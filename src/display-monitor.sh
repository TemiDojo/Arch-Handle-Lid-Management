#!/bin/zsh


# set a polling logic that subscribes to swaymsg
# we use jq to extrack the data
#   jq: A JSON processor
#/home/ojo/Arch-Handle-Lid-Management/src/poll_lidEvent.sh
#echo "Checking for change in list of OutPuts"
# else we keep polling for any changes
swaymsg -m -t subscribe '["output"]' | while read -r event; do
#    echo "Out of Block"
    #echo $REPLY
#kwhile true; do
    output_list=$(swaymsg -t get_outputs | jq '[.[].name | select(. !="eDP-1")] | length')
    # print out the value
    #echo $output_list
    # trigger a script
    if [ "$output_list" -eq 0 ]; then
        #/home/ojo/Arch-Handle-Lid-Management/src/off_display.sh
        #
        lid_state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
        laptop_display_status=$(swaymsg -t get_outputs | jq -r '.[] | select(.name=="eDP-1") | .dpms')

        if [ "$lid_state" = "closed" ] && [ "$laptop_display_status" = "false" ]; then
            swaymsg output eDP-1 enable
            systemctl suspend
        fi
    fi


done

