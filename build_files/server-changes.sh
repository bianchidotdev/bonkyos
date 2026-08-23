#!/usr/bin/env bash

set ${SET_X:+-x} -eou pipefail


### Test out zrs - NOT WORKING because there's a strict requirement on docker-ce
tee /etc/yum.repos.d/zrs-edge.repo << 'EOF'
[zrs-edge]
name=ZRS edge
baseurl=https://us-central1-yum.pkg.dev/projects/zrs-app/zrs-rpm-edge
enabled=1
gpgcheck=0
EOF

dnf5 install -y zrs

# add vector for log and metric shipping
dnf5 install -y vector

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
