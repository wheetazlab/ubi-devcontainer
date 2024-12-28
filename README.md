# Fedora-devcontainer

devcontainer profile and docker file for Fedora 41 image (with podman) for vscode

## Folder Structure

- **.devcontainer/**: Contains the devcontainer configuration files, including `devcontainer.json` and Dockerfile. These files define the development container environment and its dependencies.
- **useful-files/**: Contains miscellaneous files that are useful for the project but do not fit into the other categories. This may include configuration files, templates, or other resources.
- **fedora-dev-build/**: Contains files and configurations specific to building and developing with the Fedora environment. This includes Dockerfiles, build scripts, and other related resources.

## Building the Image with Podman

To build the Docker image using Podman, navigate to the directory containing the `Dockerfile` and run the following command:

```sh
podman build -t ghcr.io/wheetazlab/ubi-devcontainer:latest .
```

## Pushing the Image to a Repository

To push the built image to a container registry, use the following command:

```sh
podman push ghcr.io/wheetazlab/ubi-devcontainer:latest
```
