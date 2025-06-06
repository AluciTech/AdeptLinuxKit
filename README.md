# AdeptLinuxKit

> [!WARNING]
> This project is in early development and is not yet ready for production use. The scripts are developed and tested on Ubuntu 22.04, Ubuntu 24.04 LTS and Debian 12.x LTS. Other distributions may work, but are not guaranteed to work. Use at your own risk.

## Overview

AdeptLinuxKit is a collection of scripts and tools to help you build a custom experience for development. It is designed to be easy to use and flexible, allowing you to create a development setup that meets your specific needs.

## Dev

### Prerequisites

- Install [Docker](https://docs.docker.com/desktop/setup/install/linux/)

### Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/AluciTech/AdeptLinuxKit.git
   cd AdeptLinuxKit
   ```

2. Build the Docker image:

   ```bash
   docker build -t adeptlinuxkit .
   ```

3. Run the Docker container:

   ```bash
   docker run -it --rm adeptlinuxkit
   ```

4. Inside the environment, you can, for example, run:

   ```bash
   ./data_science/python_project_setup.sh --help
   ```

## License

This project is licensed under the Apache License (Version 2.0).

See [LICENSE](LICENSE) for details.
