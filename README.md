# Build a patched Fedora 28 kernel for DVBSky T982

Takes the most recent Fedora 28 Kernel Source RPM, applies a patch to
deactivate a recent change (as of Kernel 4.18) that breaks the
cx23885 DVB-C driver on my machine.

Since the fix for that might still need some time, but I need a working
card, I started to create a patched kernel RPM for each kernel release.

It is implemented as a docker container, so I can even build the RPM on
non-Fedora systems (e.g. on my Mac, or even on Travis CI, if it would not
take so long).

## Usage

Exceute `./scripts/run-kernel-builder.sh`

## Customization

TODO. Could be adjusted for arbitrary patches (or just to rebuild the original).
