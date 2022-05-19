# Introduction

This project is **for** building yocto image for chipsee device using docker.

## Supported chipsee devices
*(Currently under development)*

Only runs on qemu right now.

## Version

### Yocto
https://wiki.yoctoproject.org/wiki/Releases

Codename | Yocto Project Version | Release Date | Current Version    | Support Level         | Poky Version | BitBake branch 
-------- | --------------------- | ------------ | ------------------ | --------------------- | ------------ | -------------- 
 Dunfell | 3.1                   | April 2020   | 3.1.15(March 2022) | LTS (until Apr. 2024) | 23.0         | 1.46          

## Instructions
### Steps
1. Install build packages required to successfully build yocto based operating system into docker container.
2. Clone `poky`. It is a reference distribution of the `yocto` used to bootstrap the linux distribution.
3. Setup **hardware layers**. A layer is a set of instructions and a hardware layer(or **BSP Layer**) defines instructions to interact with specific board. You have to search for a BSP layer compatible for the board type using this website https://git.yoctoproject.org/.
4. Setup **software layer**. A software later is used to install applications to yocto disto.  
5. Setup environment by sourcing build env of poky `oe-init-build-env`. This will generate the build folder with 3 types of config- 
   1. `bblayers.conf` - it tells BitBake what layers you want considered during the build.
   2. `local.conf` - contains local configuration packages.
   3. `templateconf.cfg` - contains relative path to the poky's meta-poky configuration files.
6. Update `bblayers.conf` and `local.conf` as per requirement.
7. Start build using `bitbake`. It executes the tasks provided in the recipe.
8. To add custom drivers layer -
   1. `bitbake-layers create-layer ../meta-chipsee` creates layer named meta-chipsee
   2. `bitbake-layers add-layer ../meta-chipsee` to add layer meta-chipsee to bitbake build
   3. `bitbake-layers show-layers` to list the layer. Confirm if you can see `meta-chipsee` on the list.
   4. Create a recipe for drivers. 
      1. Copy `poky/meta-skeleton/recipes-kernel/hello-mod` to  `meta-chipsee/recipies-chipsee`. And replace driver files in `recipies-chipsee`. Edit `site.conf` and add `IMAGE_INSTALL_append += "driver_name"` `KERNEL_MODULE_AUTOLOAD += "driver_name"`. This will add bitbake to install driver recipe at image build.
      2. Create DriverTree for drivers by running `recipetool appendsrcfile path/to/meta-chipsee virtual/kernel /path/to/your.dts 'arch/${ARCH}/boot/dts/your.dts'`
      3. Edit `site.conf` and add `KERNEL_DEVICETREE += "your.dtb"`
      4. run `bitbake -c cleansstate <RECIPE_NAME>` to clean any corrupted recipe state.
      5. Test recipe by running `yocto-check-layer ../meta-chipsee` . Before running this command make sure that this recipe is not included in the `bblayers.conf`

## Run
 * `./make build` : builds OS 
 * `./make clean` : cleans build folder (except downloads and sstate-cache directory)  
 * `./make run`   : runs OS using qemu

OS image will be generated on `build/tmp/deploy/images` folder.
