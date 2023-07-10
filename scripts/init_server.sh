#!/bin/bash

# Function to display a message and wait for user confirmation
function confirm {
    local response
    read -p "$(tput bold)$1 [Y/n]: $(tput sgr0)" response
    response=${response,,}  # Convert response to lowercase
    if [[ $response =~ ^(yes|y|)$ ]]; then
        return 0  # User confirmed (proceed)
    else
        return 1  # User canceled (skip)
    fi
}

# Function to display a banner
function display_banner {
    echo "$(tput setaf 5)"
    
    echo "██████╗ ██╗██████╗ ███████╗ ██████╗████████╗██╗   ██╗███████╗    ██╗   ██╗██████╗ ███╗   ██╗"
    echo "██╔══██╗██║██╔══██╗██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔════╝    ██║   ██║██╔══██╗████╗  ██║"
    echo "██║  ██║██║██████╔╝█████╗  ██║        ██║   ██║   ██║███████╗    ██║   ██║██████╔╝██╔██╗ ██║"
    echo "██║  ██║██║██╔══██╗██╔══╝  ██║        ██║   ██║   ██║╚════██║    ╚██╗ ██╔╝██╔═══╝ ██║╚██╗██║"
    echo "██████╔╝██║██║  ██║███████╗╚██████╗   ██║   ╚██████╔╝███████║     ╚████╔╝ ██║     ██║ ╚████║"
    echo "╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝      ╚═══╝  ╚═╝     ╚═╝  ╚═══╝"
    echo "$(tput sgr0)"
    echo "Welcome to the Directus server config script!"
    echo
}

# Display the banner
display_banner

# Options menu
while true; do
    echo "$(tput bold)Options:"
    echo "1. Initial server updates"
    echo "2. Docker installation for Debian"
    echo "3. NVM install and configuration"
    echo "4. Clone repo"
    echo "q. Quit"
    echo

    read -p "Please select an option (or 'q' to quit): " option

    case $option in
        1)
            # Initial update
            confirm "$(tput bold)Perform initial update?"
            if [[ $? -eq 0 ]]; then
                sudo apt update && sudo apt upgrade
            fi
            ;;
        2)
            # Docker installation
            confirm "$(tput bold)Uninstall previous Docker versions?"
            if [[ $? -eq 0 ]]; then
                for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
                    sudo apt-get remove $pkg
                done
            fi

            confirm "$(tput bold)Install dependencies and add Docker repository?"
            if [[ $? -eq 0 ]]; then
                sudo apt-get update
                sudo apt-get install -y ca-certificates curl gnupg

                sudo install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                sudo chmod a+r /etc/apt/keyrings/docker.gpg

                echo \
                    "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
                    $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
                    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                confirm "$(tput bold)Install Docker?"
                if [[ $? -eq 0 ]]; then
                    sudo apt-get update
                    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                fi
            fi
            ;;
        3)
            # NVM install and conf
            # Add your NVM installation and configuration commands here
            confirm "$(tput bold)Install NVM and latest Node version?"
            if [[ $? -eq 0 ]]; then
                sudo apt-get install curl gnupg2 -y
                curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
                source ~/.bashrc
                nvm install node
            fi
            ;;
        4)
            # Clone repository
            confirm "$(tput bold)Clone the repository?"
            if [[ $? -eq 0 ]]; then
                read -p "Enter the Git repository URL: " repo_url
                git clone "$repo_url" && cd $(basename "$repo_url" .git)
            fi
            ;;
        q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    echo
done
