#!/bin/bash

# Load variables from .env file
if [ -f ".env" ]; then
    echo "Loading environment variables from .env file..."
    source .env
    echo "Environment variables loaded."
else
    echo ".env file not found."
    exit 1
fi

# Get the current directory of the script
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Navigate up one level
parent_dir=$(dirname "$script_dir")

# Define the path of the "app_data" directory
app_data_dir="$parent_dir/$DIRECTUS_DATA_FOLDER"

# Check if the "uploads" directory exists
if [ -d "$app_data_dir/uploads" ]; then
    echo "The 'uploads' directory already exists."

    # Prompt the user for a choice
    read -p "Do you want to replace the 'uploads' directory? (y/n): " choice

    # Handle the user's choice
    case $choice in
        y|Y)
            # Remove the existing 'uploads' directory
            rm -rf "$app_data_dir/uploads"
            echo "Existing 'uploads' directory removed."
            ;;
        n|N)
            echo "No changes made to the 'uploads' directory."
            ;;
        *)
            echo "Invalid choice. No changes made to the 'uploads' directory."
            ;;
    esac
fi

mkdir -p "$app_data_dir/database"
chmod 777 "$app_data_dir/database"
# Create the "uploads" directory
mkdir -p "$app_data_dir/uploads"
chmod 777 "$app_data_dir/uploads"
echo "Created 'uploads' directory: $app_data_dir/uploads"

# Check if any of the "extensions" subdirectories exist
extensions=("displays" "endpoints" "hooks" "interfaces" "layouts" "modules" "panels" "operations")
existing_extensions=()
for extension in "${extensions[@]}"; do
    if [ -d "$app_data_dir/extensions/$extension" ]; then
        existing_extensions+=("$extension")
    fi
done

# Check if any existing extensions need to be overwritten
if [ ${#existing_extensions[@]} -gt 0 ]; then
    echo "The following existing extensions were found: ${existing_extensions[*]}"

    # Prompt the user for a choice to replace all extensions
    read -p "Do you want to replace all existing extensions? (y/n): " choice_all

    case $choice_all in
        y|Y)
            # Remove all existing extension directories
            for extension in "${existing_extensions[@]}"; do
                rm -rf "$app_data_dir/extensions/$extension"
                echo "Existing '$extension' extension directory removed."
            done
            ;;
        n|N)
            # Prompt the user for individual choices per extension
            for extension in "${existing_extensions[@]}"; do
                read -p "Do you want to replace the '$extension' extension directory? (y/n): " choice

                case $choice in
                    y|Y)
                        # Remove the existing extension directory
                        rm -rf "$app_data_dir/extensions/$extension"
                        echo "Existing '$extension' extension directory removed."
                        ;;
                    n|N)
                        echo "No changes made to the '$extension' extension directory."
                        ;;
                    *)
                        echo "Invalid choice. No changes made to the '$extension' extension directory."
                        ;;
                esac
            done
            ;;
        *)
            echo "Invalid choice. No changes made to the existing extensions."
            ;;
    esac
fi

# Create the "extensions" subdirectories
mkdir -p "$app_data_dir/extensions/"{displays,endpoints,hooks,interfaces,layouts,modules,panels,operations}
chmod 777 "$app_data_dir/extensions/"
chmod 777 "$app_data_dir/extensions/"{displays,endpoints,hooks,interfaces,layouts,modules,panels,operations}
echo "Created 'extensions' subdirectories: ${extensions[*]}"

echo "Directory setup completed."
