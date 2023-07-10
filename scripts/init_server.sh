#!/bin/bash

# Function to display a message and wait for user confirmation
function confirm {
    local response
    read -p "$1 [Y/n]: " response
    response=${response,,}  # Convert response to lowercase
    if [[ $response =~ ^(yes|y|)$ ]]; then
        return 0  # User confirmed (proceed)
    else
        return 1  # User canceled (skip)
    fi
}

# Options menu
while true; do
    echo "Options:"
    echo "0 - Initial update"
    echo "1 - Docker installation"
    echo "2 - NVM install and configuration"
    echo "q - Quit"
    echo

    read -p "Enter the option number to proceed (or 'q' to quit): " option

    case $option in
        0)
            # Initial update
            confirm "Perform initial update?"
            if [[ $? -eq 0 ]]; then
                sudo apt update && sudo apt upgrade
            fi
            ;;
        1)
            # Docker installation
            confirm "Uninstall previous Docker versions?"
            if [[ $? -eq 0 ]]; then
                for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
                    sudo apt-get remove $pkg
                done
            fi

            confirm "Install dependencies and add Docker repository?"
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

                confirm "Install Docker?"
                if [[ $? -eq 0 ]]; then
                    sudo apt-get update
                    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                fi
            fi
            ;;
        2)
            # NVM install and conf
            # Add your NVM installation and configuration commands here
            confirm "Install NVM and latest Node version?"
            if [[ $? -eq 0 ]]; then
                sudo apt-get install curl gnupg2 -y
                curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
                source ~/.bashrc
                nvm install node
            fi
            ;;
            ;;
        q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac

    echo
done
