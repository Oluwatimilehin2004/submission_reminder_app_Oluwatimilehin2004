#!/bin/bash

# =========================================
# Copilot Assistant for Student Submissions
# Helps teachers check different assignments quickly
# =========================================

# Find the actual submission reminder directory
find_app_directory() {
    local dir_pattern="submission_reminder_*"
    local found_dirs=($(find . -maxdepth 1 -type d -name "submission_reminder_*" 2>/dev/null))
    
    case ${#found_dirs[@]} in
        0)
            echo "Setup Error: No submission reminder directory found."
            echo "   Please run create_environment.sh first to create the application."
            exit 1
            ;;
        1)
            APP_DIRECTORY="${found_dirs[0]}"
            echo "Found application directory: $APP_DIRECTORY"
            ;;
        *)
            echo "Multiple submission directories found:"
            for i in "${!found_dirs[@]}"; do
                echo "$((i+1))) ${found_dirs[$i]}"
            done
            read -p "Select which directory to use (1-${#found_dirs[@]}): " dir_choice
            case $dir_choice in
                [1-9]*)
                    if [ $dir_choice -le ${#found_dirs[@]} ]; then
                        APP_DIRECTORY="${found_dirs[$((dir_choice-1))]}"
                        echo "Selected directory: $APP_DIRECTORY"
                    else
                        echo "Invalid selection. Using first directory: ${found_dirs[0]}"
                        APP_DIRECTORY="${found_dirs[0]}"
                    fi
                    ;;
                *)
                    echo "Invalid input. Using first directory: ${found_dirs[0]}"
                    APP_DIRECTORY="${found_dirs[0]}"
                    ;;
            esac
            ;;
    esac
}

# Initialize paths after finding directory
initialize_paths() {
    STARTUP_SCRIPT="startup.sh"
    CONFIG_FILE="$APP_DIRECTORY/config/config.env"
    
    # Verify critical files exist
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config Error: Configuration file not found at $CONFIG_FILE"
        echo "   The application may not be properly set up."
        exit 1
    fi
    
    if [ ! -f "$APP_DIRECTORY/$STARTUP_SCRIPT" ]; then
        echo "Script Error: Startup script not found at $APP_DIRECTORY/$STARTUP_SCRIPT"
        echo "   The application may not be properly set up."
        exit 1
    fi
}

# User control variables
user_choice="y"
new_assignment_name=""

# Function to validate and process user input using switch case
get_valid_assignment() {
    while true; do
        echo ""
        echo "Which assignment would you like to check today?"
        echo ""
        echo "Available assignments:"
        echo "1) Shell Navigation"
        echo "2) Shell Basics" 
        echo "3) Git"
        echo "4) Custom assignment (type your own)"
        echo ""

        read -p "Enter your choice (1-4): " choice

        case $choice in
            1)
                new_assignment_name="Shell Navigation"
                echo "Selected: Shell Navigation"
                break
                ;;
            2)
                new_assignment_name="Shell Basics"
                echo "Selected: Shell Basics"
                break
                ;;
            3)
                new_assignment_name="Git"
                echo "Selected: Git"
                break
                ;;
            4)
                read -p "Enter custom assignment name: " custom_name
                case "$custom_name" in
                    "")
                        echo "Error: Assignment name cannot be empty"
                        ;;
                    *)
                        new_assignment_name="$custom_name"
                        echo "Custom assignment set: $custom_name"
                        break
                        ;;
                esac
                ;;
            *)
                echo "Invalid choice! Please enter 1, 2, 3, or 4"
                sleep 1
                ;;
        esac
    done
}

# Function to update configuration file - FIXED for spaces
update_configuration() {
    local assignment="$1"
    
    # Create backup of original config
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup" 2>/dev/null
    
    # Use proper quoting to handle spaces in assignment names
    if sed -i "s|ASSIGNMENT=.*|ASSIGNMENT=\"$assignment\"|" "$CONFIG_FILE" 2>/dev/null; then
        echo "Configuration updated successfully"
        
        # Verify the update worked
        local updated_assignment=$(grep "^ASSIGNMENT=" "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"')
        echo "Verified assignment in config: $updated_assignment"
        return 0
    else
        echo "Config Error: Failed to update configuration file."
        echo "   Restoring backup configuration..."
        cp "$CONFIG_FILE.backup" "$CONFIG_FILE" 2>/dev/null
        rm -f "$CONFIG_FILE.backup" 2>/dev/null
        return 1
    fi
}

# Function to run the application
launch_application() {
    if [ ! -d "$APP_DIRECTORY" ]; then
        echo "Directory Error: Application directory not found."
        return 1
    fi

    cd "$APP_DIRECTORY" || {
        echo "Directory Error: Cannot enter application directory."
        return 1
    }
    
    if [ -f "$STARTUP_SCRIPT" ] && [ -x "$STARTUP_SCRIPT" ]; then
        ./"$STARTUP_SCRIPT"
        cd ..
        return 0
    else
        echo "Script Error: Cannot execute startup script."
        cd ..
        return 1
    fi
}

# Main function to handle assignment checking
check_assignment_submissions() {
    local assignment_to_check="$1"

    echo "Checking submissions for: '$assignment_to_check'"
    echo "Updating system configuration..."
    
    # Update the configuration with new assignment
    if update_configuration "$assignment_to_check"; then
        echo "Starting the reminder application..."
        launch_application
    else
        echo "Failed to update configuration. Application not started."
    fi
}

# Welcome message
echo "========================================"
echo "  Assignment Submission Checker"
echo "========================================"

# Find and initialize the application directory
find_app_directory
initialize_paths

# Main program loop
while [[ "$user_choice" == "y" || "$user_choice" == "Y" ]]; do
    # Get valid assignment from user using switch case menu
    get_valid_assignment

    # Process the assignment and show results
    check_assignment_submissions "$new_assignment_name"

    echo ""
    # Ask if user wants to continue
    while true; do
        read -p "Would you like to check another assignment? (y/n): " user_choice
        case $user_choice in
            [yY])
                echo ""
                break
                ;;
            [nN])
                echo ""
                echo "Thank you for using the Submission Checker!"
                echo "Have a great teaching day!"
                echo "========================================"
                exit 0
                ;;
            *)
                echo "Please enter 'y' for yes or 'n' for no"
                ;;
        esac
    done
done
