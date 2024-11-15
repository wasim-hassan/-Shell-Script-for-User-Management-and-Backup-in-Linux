# User Management and Backup Script

## Introduction
The project is an automation of user management and the creation of backups within a Linux environment.

## Features
- User management: add, delete, modify user accounts.
- Group management.
- Compression support for backup.
- Backup rotation.

## Installation
Clone the repository and make the script executable:
```bash
git clone https://github.com/yourusername/User-Management-Backup.git
cd User-Management-Backup
chmod +x user_management.sh
```

## Usage
Run the script with commands:
- Add a user: `sudo ./user_management.sh add`
- Delete a user: `sudo ./user_management.sh delete`
- Backup: `sudo ./user_management.sh backup`
- Modify a User’s Shell: `sudo ./user_management.sh modify`
