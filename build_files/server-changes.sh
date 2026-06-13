#!/usr/bin/env bash

set ${SET_X:+-x} -eou pipefail

dnf5 config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
dnf5 install -y nomad

dnf5 install -y incus
systemctl enable incus

#### Make `ucore-brew` package additions

# Add Homebrew to `ucore`
# Add Packages repo
dnf5 -y copr enable ublue-os/packages
# Install Homebrew
dnf5 -y install ublue-brew
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable ublue-os/packages

#### Make `ucore-brew` Systemd modifications (using example from Bluefin)
#### https://github.com/ublue-os/bluefin/blob/5d0b3e67601f87fd3435f39c79d0582a299e566a/build_files/base/17-cleanup.sh#L18-L20

systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer
