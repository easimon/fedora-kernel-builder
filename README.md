# Build a (patched) Fedora 31 kernel on Docker

Docker based build of a Fedora Kernel, can be modified to apply additional patches.

## Usage

Exceute `./scripts/run-kernel-builder.sh`

## Customization

At the moment it builds a patched Fedora 31 kernel, containing a cgroup fix for an issue causing
kernel panics on my machine.

Patch the spec in `./docker-scripts/buildkernel.sh` to contain whatever modification your kernel needs,
or remove the patching to build a stock RPM.

## Github actions build

On an unmodified Github runner, the build ran into "disk full" issues. By deactivating swap, combining free
space of the OS disk and Temp disk of the runner (into an LVM volume), these issues went away. See `./scripts/prepare-github-builder.sh`.

At the time of writing, the build works. But since this modification relies on the concrete Azure instances
(and their disk layout) Github uses, this might break at any time. Also the missing Swap space might
cause OOM errors.

## History

When Fedora 28 came out, it contained a broken driver for cx23885 DVB-C cards,
at least on my machine.

Since the fix for that needed some time to be released, but I needed a working
card, and found an unreleased patch fixing the issue, I started to create a
patched kernel RPM for each kernel release.

It is implemented as a docker container, so I can even build the RPM on
non-Fedora systems (e.g. on Ubuntu, my Mac, or even on Github).
