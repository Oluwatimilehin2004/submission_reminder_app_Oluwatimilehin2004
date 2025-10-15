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

#This function starts the application
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

    start_application
}

#Error handling
handle_error() {
    echo " An error occurred in startup.sh at line $1"
    exit 1
}

# Set error trap
trap 'handle_error $LINENO' ERR

#Runs main function
main "$@"
