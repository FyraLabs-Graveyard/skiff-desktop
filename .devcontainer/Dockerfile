ARG VERSION="37"
FROM fedora:${VERSION}
ARG VERSION

RUN dnf -y install git 'dnf-command(config-manager)'
RUN dnf config-manager --add-repo="https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/tau1.repo"
RUN dnf -y install libhelium-devel gcc vala meson desktop-file-utils vala-language-server starship tau-starship tau-hydrogen muon gdb blueprint-compiler tau-manrope-fonts appstream vala-lint-nightly

RUN useradd -m vscode
RUN echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode
USER vscode
