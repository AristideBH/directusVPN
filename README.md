# directusVPN

directusVPN is a VPN (Virtual Private Network) solution built with Directus and OpenVPN. It allows you to create and manage VPN users, providing secure access to your network resources.

## Features
> Todo

## Requirements

- Debian 11
- Docker
- Node (optional, will be needed when loading extensions)

## Installation

0. Connect to your VPS through SSH. 

1. Navigate to your desired folder and clone the repository:
   ```shell
   git clone https://github.com/AristideBH/directusVPN.git
   cd directusVPN
    ```

2. Run the `init_server.sh` to install requirements, and chose the desired options.
    ```shell
    ./scripts/init_server.sh
    ```

3. Copy the `.env.example` to a new `.env` file, and fill-in your credentials and settings.

4. Run the deployement
    ```shell
    docker compose up
    # or 
    docker compose up -d
    ```

### Tips
- If you happen to change the `PREFIX` varianle in `.env`, make sure to exclude the appropriate folder in `.gitignore`.
- To load a specific version of Directus (currently 10.4.2), edit the `Dockerfile`.


### Troubleshoot

If you have problems uploading your files to Directus administration, make sure that the `uploads` folder have the necessary permissions : 
```shell
sudo chmod 777 /app_data/uploads
```

### Bugs
> There's currently a problem loading the extensions volume, please do NOT enable it, or try to uncomment RUN command in Dockerfile
