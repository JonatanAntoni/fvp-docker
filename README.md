# fvp-docker

This builds a docker wrapper around FVP models.

This requires Docker to be setup and running.

On Arm-Macs some settings are required to allow Docker to run `linux/amd64` containers through Rosetta, see
https://levelup.gitconnected.com/docker-on-apple-silicon-mac-how-to-run-x86-containers-with-rosetta-2-4a679913a0d5.

## Build image

Export ARTIFACTORY_URL to the host name of your Artifactory server hosting the depot.
Export ARTIFACTORY_API_KEY to contain your personal Artifactory access key.

Run `build.sh` to generate the docker image.

## Use FVP wrappers

Put `$(pwd)/bin` into your `PATH`.
Now you can run models like installed locally.
