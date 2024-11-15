#!/bin/bash
# User Management and Backup Script

# Enable error handling and set a log file
set -e
LOG_FILE="/var/log/user_management_backup.log"

# Check if the script is running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo" | tee -a "$LOG_FILE"
    exit 1
fi

# Logging function
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to add a user
add_user() {
    read -p "Enter username to add: " username
    if id "$username" &>/dev/null; then
        log "Error: User $username already exists."
    else
        useradd -m "$username"
        log "User $username added successfully."
    fi
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        userdel -r "$username"
        log "User $username deleted successfully."
    else
        log "Error: User $username does not exist."
    fi
}

# Function to modify user (change shell)
modify_user() {
    read -p "Enter username to modify: " username
    if id "$username" &>/dev/null; then
        read -p "Enter new shell (e.g., /bin/bash): " shell
        usermod -s "$shell" "$username"
        log "Shell for $username changed to $shell."
    else
        log "Error: User $username does not exist."
    fi
}

# Function to create a backup with rotation
backup_dir="/var/backups/user_data"
rotate_backups() {
    # Keep only the last 3 backups
    local backups=($(ls -1tr "$backup_dir" 2>/dev/null))
    while [ "${#backups[@]}" -gt 3 ]; do
        rm -f "$backup_dir/${backups[0]}"
        log "Deleted old backup: ${backups[0]}"
        backups=("${backups[@]:1}")
    done
}

create_backup() {
    read -p "Enter directory to back up: " dir
    if [ ! -d "$dir" ]; then
        log "Error: Directory $dir does not exist."
        exit 1
    fi
    mkdir -p "$backup_dir"
    backup_file="$backup_dir/$(basename "$dir")_backup_$(date +'%Y%m%d%H%M%S').tar.gz"
    tar -czf "$backup_file" "$dir"
    log "Backup created: $backup_file"
    rotate_backups
}

# Display usage
usage() {
    echo "Usage: $0 {add|delete|modify|backup}"
    exit 1
}

# Main script execution
case "$1" in
    add)
        add_user
        ;;
    delete)
        delete_user
        ;;
    modify)
        modify_user
        ;;
    backup)
        create_backup
        ;;
    *)
        usage
        ;;
esac

