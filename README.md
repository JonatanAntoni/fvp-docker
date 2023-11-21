# fvp-docker

This builds a docker wrapper around FVP models.

This requires Docker to be setup and running.

## Initialize wrapper

Run `gen.sh` to generate the wrapper links for a specific model version.
The version can be selected by setting `FVP_VERSION` to the full version.

Available versions can be found at https://artifacts.keil.arm.com/avh/.

## Build the image

The Docker image is built automatically on first use.
In order to pre-build the Docker image run `./build.sh` script.

## Use FVP wrappers

Put `$(pwd)/bin` into your `PATH`.
Now you can run models like installed locally.
