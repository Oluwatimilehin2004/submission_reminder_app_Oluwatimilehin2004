#!/bin/bash
# =========================================
# Submission Reminder Application Startup
# Author: Ojudun Ayomide
# Description: Initializes environment, verifies files,
# and launches the reminder app with logs.
# =========================================

#Loading animation function for reuseablility
loading_ani(){
	echo -n "$1"
	for i in {1..3}; do
 		echo -n "."
  		sleep 0.5
	done
	echo -e "\n"
}

#creates necessary folders and files for the SSR
SSR_setup(){
    loading_ani "Creating directory structure"
    
    # Create all directories first
    mkdir -p app
    mkdir -p modules  
    mkdir -p assets
    mkdir -p config
    
    loading_ani "Creating application files"
    
    # Now create files in their respective directories
    touch app/reminder.sh  
    touch modules/functions.sh
    touch assets/submissions.txt
    touch config/config.env
    touch startup.sh
}

# Function to populate files with content
populate_files(){
    loading_ani "Populating files with content"

# Create reminder.sh content
    cat > app/reminder.sh << 'STOP'
#!/bin/bash
echo "Reminder application would run here"
# Your actual reminder.sh content will go here
EOF

# Create functions.sh content
    cat > modules/functions.sh << 'STOP'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
STOP

# Create submissions.txt content
    cat > assets/submissions.txt << 'STOP'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Ojudun, Shell Navigation, not submitted
Ayomide, Git, submitted
Chiamaka, Shell Basics, not submitted
Emmanuel, Shell Navigation, submitted
Fatima, Git, not submitted
STOP

# Create config.env content
    cat > config/config.env << 'STOP'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
STOP

# Create startup.sh content
    cat > startup.sh << 'STOP'
#!/bin/bash
#base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$BASE_DIR/config/config.env"
APP_SCRIPT="$BASE_DIR/app/reminder.sh"

# Function to display startup header
display_header() {
    echo "========================================"
    echo "  Submission Reminder Application"
    echo "========================================"
    echo ""
}

# Function to check if required files exist
check_requirements() {
    local missing_files=()

    if [[ ! -f "$CONFIG_FILE" ]]; then
        missing_files+=("config/config.env")
    fi

    if [[ ! -f "$APP_SCRIPT" ]]; then
        missing_files+=("app/reminder.sh")
    fi

    if [[ ! -f "$BASE_DIR/modules/functions.sh" ]]; then
        missing_files+=("modules/functions.sh")
    fi

    if [[ ! -f "$BASE_DIR/assets/submissions.txt" ]]; then
        missing_files+=("assets/submissions.txt")
    fi
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        echo " Error: Missing required files:"
        for file in "${missing_files[@]}"; do
            echo "   - $file"
        done
        echo ""
        echo "Please run create_environment.sh first to set up the application."
        exit 1
    fi
}

# Function to check file permissions
check_permissions() {
    if [[ ! -x "$APP_SCRIPT" ]]; then
        echo "   Making reminder.sh executable..."
        chmod +x "$APP_SCRIPT"
    fi

    if [[ ! -x "$BASE_DIR/modules/functions.sh" ]]; then
        echo "   Making functions.sh executable..."
        chmod +x "$BASE_DIR/modules/functions.sh"
    fi
}

# Function to load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        echo " Loaded configuration:"
        echo "   - Assignment: $ASSIGNMENT"
        echo "   - Due Date: $DUE_DATE"
        echo ""
    else
        echo " Error: Configuration file not found at $CONFIG_FILE"
        exit 1
    fi
}

# Function to display system info
display_system_info() {
    echo " System Information:"
    echo "   - Base Directory: $BASE_DIR"
    echo "   - Config File: $CONFIG_FILE"
    echo "   - App Script: $APP_SCRIPT"
    echo ""
}

# Function to start the application
start_application() {
    echo " Starting Submission Reminder Application..."
    echo ""

    # Add a small delay for better user experience
    sleep 1

    # Launch the main reminder application
    "$APP_SCRIPT"

    # Check if the application ran successfully
    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        echo ""
        echo " Application completed successfully!"
    else
        echo ""
        echo " Application exited with error code: $exit_code"
        exit $exit_code
    fi
}

# Main execution flow
main() {
    display_header

    echo " Checking system requirements..."
    check_requirements

    echo " Checking file permissions..."
    check_permissions

    echo "   Loading configuration..."
    load_config

    display_system_info

    start_application
}

# Error handling
handle_error() {
    echo " An error occurred in startup.sh at line $1"
    exit 1
}

# Set error trap
trap 'handle_error $LINENO' ERR

#Run main function
main "$@"
STOP

# Make all scripts executable
    chmod +x app/reminder.sh
    chmod +x modules/functions.sh
    chmod +x startup.sh
}

# Prompt user for their, so it can you use to create the dir needed.
echo "====================================="
echo -e "You Are About To Create Your Student Submission Reminder (SSR) \nWe Will Need Your Name To Setup Your Folder"
read -p "Enter your name: " student_name
echo "Thank you! Name received!"
echo "======================================="


# Loading animation (just for style)
loading_ani "Processing"

create_folder_structure(){
	BASE_NAME="submission_reminder_$student_name"
	mkdir -p $BASE_NAME
	if [[ -d "$BASE_NAME" ]]; then
		loading_ani "Checking for $student_name folder"
		echo "$BASE_NAME found!"
		loading_ani "Navigating into it"
		cd $BASE_NAME
		loading_ani "Welcome to your Submission Reminder Folder(SRF)"
		SSR_setup
		populate_files
		echo "Operation successful!!!"
	else
		echo "$BASE_NAME folder doesn't exist"
		exit
	fi
}

create_folder_structure
