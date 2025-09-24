# PHPDVM - PHP Docker Version Manager

A simple tool to manage multiple PHP versions using Docker containers.

## Features
- Install and run different PHP versions in isolated Docker containers
- Easily switch the default PHP version
- Supports Alpine and Debian based Docker images

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed and running
- Bash shell

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Gean-Lima/phpdvm.git phpdvm
   cd phpdvm
   ```
2. Make the script executable:
   ```bash
   chmod +x phpdvm.sh
   ```
3. (Optional) Add to your PATH for easier access:
   ```bash
   echo 'alias phpdvm="$PWD/phpdvm.sh"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Configuration

Edit `phpdvm.conf` to set your default PHP version and Dockerfile type (alpine or debian):

```
DEFAULT_PHP_VERSION=7.4
DOCKERFILES_VERSION=alpine
```

## Usage

Show help:
```bash
phpdvm help
```

List available PHP Docker versions:
```bash
phpdvm list
```

Install a specific PHP version:
```bash
phpdvm install 8.1
```

Run a specific PHP version (with optional command):
```bash
phpdvm run 8.1 php -v
```

Set the default PHP version alias:
```bash
phpdvm alias 8.1
```

Run the default PHP version:
```bash
phpdvm run alias php -v
```

## Dockerfiles

Dockerfiles for different PHP versions are located in the `dockerfiles/` directory. Make sure the correct Dockerfile exists for your desired version.

## License
MIT
