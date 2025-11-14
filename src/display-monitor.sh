#!/bin/zsh


# set a polling logic that subscribes to swaymsg
# we use jq to extrack the data
#   jq: A JSON processor


echo "Checking for change in list of OutPuts"
# else we keep polling for any changes
swaymsg -m -t subscribe '["output"]' | while read -r event; do
    echo "Out of Block"
    #echo $REPLY

    output_list=$(swaymsg -t get_outputs | jq '[.[].name | select(. !="eDP-1")]')
    # print out the value
    echo $output_list
    # we only care about the size or if its > than 1 (edge case will be if the laptops
    # display 
    #
    # if length greater than 0
        # then we know are still docked in
        # if lid is closed || open
            # turn the display off 
        # continue polling
    # if length == 0
        # then we know we are only dealing with the laptops display
        # if lid is closed
            # leave the display off
        # else if lid is open
            # turn the display on

done

# it will probably be best to have two process running this
# but I think for now I should just keep it simple
# IF WE'RE DOCKED IN TURN OF THE DISPLAY -> will make life so much easier lol



### Assumptions -> early stages of this will require to make some assumptions
