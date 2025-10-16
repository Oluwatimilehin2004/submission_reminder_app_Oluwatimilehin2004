#!/bin/bash

# ========================================
# COPILOT SHELL SCRIPT
# Updates assignment name in config.env
# ========================================

#Set the base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#Get the exactly app Papa/Vanessa whichever dynamically.
for APP_DIR in "$BASE_DIR"/submission_reminder_*; do
    if [[ -d "$APP_DIR" ]]; then
        CONFIG_FILE="$APP_DIR/config/config.env"
        STARTUP_SCRIPT="startup.sh"
    fi
done

#This is to display header.
display_header() {
    echo "========================================"
    echo "        COPILOT SHELL SCRIPT"
    echo "========================================"
    echo ""
}

#Function to check if config file exists or not.
check_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Error: Config file not found at $CONFIG_FILE"
        echo "Please run create_environment.sh first to set up the application."
        exit 1
    fi
}

#This function does the updating.
update_assignment() {
    echo "Update Assignment"
    echo "-------------------"

     #Prompts user for their new assignment name
     read -p "Enter the new assignment name(Git, Shell Basics, Shell Navigate, etc.): " new_assignment
    
    if [[ -z $new_assignment ]]; then
	    echo "Assignment cannot be empty, restart operation."
	    exit 1 
    else
    	#Replaces line 2 with the new assignment value
    	sed -i "2s/.*/ASSIGNMENT=$new_assignment/" "$CONFIG_FILE"
	
    	if [[ $? -eq 0 ]]; then
        	echo "Assignment updated successfully!"
        	echo "New assignment set to: $(grep '^ASSIGNMENT=' "$CONFIG_FILE")"
    	else
        	echo "Failed to update assignment. Please check the file permissions."
        	exit 1
    	fi

        # Rerun startup.sh after success
        if [[ -f "$STARTUP_SCRIPT" ]]; then
           echo ""
           echo "Running startup.sh for new assignment check..."
           bash "$STARTUP_SCRIPT"
        else
           echo "⚠️ startup.sh not found in $BASE_DIR. Skipping startup run."
        fi
   fi
}


#Declare the main function that houses all functions
main() {
    display_header
    check_config
    update_assignment
}

#Calls the main function that houses others
main
