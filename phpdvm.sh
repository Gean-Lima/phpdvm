#!/bin/bash

BASE_DIR="$(dirname "$(realpath "$0")")"

command="$1"
commandValue="$2"
commandRun="${@:3}"

phpVersionAlias=$(cat $BASE_DIR/phpdvm.conf | grep DEFAULT_PHP_VERSION= | cut -d '=' -f2)
dockerfilesVersion=$(cat $BASE_DIR/phpdvm.conf | grep DOCKERFILES_VERSION= | cut -d '=' -f2)

# Function to get the Docker image name for the specified PHP version
getPHPDVMContainerName() {
  echo "phpdvm-$commandValue-$dockerfilesVersion:$commandValue"
}

# Function to check if a Docker image for the specified PHP version exists
existVersion() {
  existVersion=$(docker images -a | grep phpdvm-$1 2>/dev/null)

  if [ -z "$existVersion" ]; then
    echo "Version $1 not installed. Please install it first."
    exit 1
  fi
}

# Function to check if a command is empty
commandEmpty() {
  if [ -z "$1" ]; then
    echo "$2"
    exit 1
  fi
}

# Handle commands

# Show help message
if [ "$command" == "help" ] || [ -z "$command" ]; then

  echo "PHPDVM - PHP Docker Version Manager"
  echo ""
  echo "Usage: phpdvm <command> [options]"
  echo ""
  echo "Commands:"
  echo "  list                     List available PHP Docker versions"
  echo "  install <version>        Install a specific PHP Docker version"
  echo "  run <version|alias> [cmd] Run a specific PHP Docker version or the default alias with an optional command"
  echo "  alias <version>          Set the default PHP version alias"
  echo "  help                     Show this help message"
  echo ""
  echo "Examples:"
  echo "  phpdvm install 8.1          Install PHP version 8.1"
  echo "  phpdvm run 8.1 php -v       Run PHP version 8.1 and execute 'php -v'"
  echo "  phpdvm alias 8.1            Set the default PHP version to 8.1"
  echo "  phpdvm run alias php -v     Run the default PHP version and execute 'php -v'"

fi

# List available PHP Docker versions
if [ "$command" == "list" ]; then

  echo "Available PHP Docker versions:"

  docker images -a | grep phpdvm

fi

# Install a specific PHP Docker version
if [ "$command" == "install" ]; then

  echo "Installing PHP Docker version $commandValue..."

  commandEmpty "$commandValue" "No version provided for install command. Usage: phpdvm install <version>"

  if [ -z "$(existVersion $commandValue)" ]; then
    echo "Version $commandValue already installed."
    exit 0
  fi

  if [ ! -f "$BASE_DIR/dockerfiles/Dockerfile.$dockerfilesVersion" ]; then
    echo "Dockerfile for version $dockerfilesVersion not found in dockerfiles/ directory."
    exit 1
  fi

  docker build --build-arg PHP_VERSION=$commandValue -t $(getPHPDVMContainerName) -f $BASE_DIR/dockerfiles/Dockerfile.$dockerfilesVersion .

fi

# Run a specific PHP Docker version
if [ "$command" == "run" ]; then

  if [ ! -z "$phpVersionAlias" ] && [ "$commandValue" == "alias" ]; then
    commandValue="$phpVersionAlias"
  elif [ "$commandValue" == "alias" ]; then
    echo "No default PHP version set in phpdvm.conf."
    exit 1
  fi

  echo "Running PHP Docker version $commandValue..."

  commandEmpty "$commandValue" "No version provided for run command. Usage: phpdvm run <version>"

  existVersion $commandValue

  docker run --rm -it -v "$PWD":/app -w /app $(getPHPDVMContainerName) $commandRun

fi

# Set the default PHP version alias
if [ "$command" == "alias" ]; then

  commandEmpty "$commandValue" "No version provided for alias command. Usage: phpdvm alias <version>"

  existVersion $commandValue

  sed -i "s/^DEFAULT_PHP_VERSION=.*/DEFAULT_PHP_VERSION=$commandValue/" $BASE_DIR/phpdvm.conf
  echo "Set default PHP version to $commandValue in $BASE_DIR/phpdvm.conf"

fi
