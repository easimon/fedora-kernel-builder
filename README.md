# Build a (patched) Fedora 31 kernel

Docker based build of a Fedora Kernel, can be modified to apply additional patches.

## Usage

Exceute `./scripts/run-kernel-builder.sh`

## Customization

Patch the spec in `./scripts/buildkernel.sh` to contain whatever modification your kernel needs.

## History

When Fedora 28 came out, it contained a broken driver for cx23885 DVB-C cards,
at least on my machine.

Since the fix for that needed some time to be released, but I needed a working
card, I started to create a patched kernel RPM for each kernel release.

It is implemented as a docker container, so I can even build the RPM on
non-Fedora systems (e.g. on my Mac, or even on Github or Travis CI, if it would
not take so long).
