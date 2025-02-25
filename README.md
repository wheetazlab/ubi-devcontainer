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

or for multiarch

```sh
podman manifest create ghcr.io/wheetazlab/ubi-devcontainer:latest
podman buildx build --platform linux/amd64,linux/arm64 --manifest ghcr.io/wheetazlab/ubi-devcontainer:latest .
```

## Pushing the Image to a Repository

To push the built image to a container registry, use the following command:

```sh
podman push ghcr.io/wheetazlab/ubi-devcontainer:latest
```

or for multiarch

```sh
podman manifest push ghcr.io/wheetazlab/ubi-devcontainer:latest
```

## GitHub Workflow for Building and Pushing Multi-Arch Image

This repository includes a GitHub Actions workflow that automatically builds and pushes a multi-arch Docker image when a new release is created or the workflow is manually triggered.

The workflow file is located at `.github/workflows/build-multi-arch-image-on-release.yml`.

I have setup up arc-runners on my lab clusters (5 node RPI cm4 k3s cluster and a 4 node RK1 k3s cluster. The serve as my self-hosted runners and do multiarch builds). See the ansible folder for a sample playbook for creating Github Action Runner Controller for scale set and creating a ARC scale set that uses docker in docker for building.

To trigger the workflow manually, navigate to the "Actions" tab in your GitHub repository, select the "Build Multi-Arch Image on Release" workflow, and click the "Run workflow" button.

The workflow performs the following steps:
1. Checks out the code.
2. Sets up QEMU for multi-arch support.
3. Sets up Docker Buildx.
4. Logs in to the GitHub Container Registry.
5. Builds and pushes the multi-arch Docker image to the GitHub Container Registry.
