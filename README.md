# This project is dead.
See https://blog.fyralabs.com/goodbye-skiff-desktop/ for an informal retrospective.

<img align="left" style="vertical-align: middle" width="120" height="120" alt="Skiff Icon" src="data/icons/app.svg">

# Skiff Desktop

Skiff, now on a Linux Desktop near you!

###

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

## 🛠️ Dependencies

Please make sure you have these dependencies first before building.

```bash
gtk4
libhelium-1
meson
vala
blueprint-compiler
webkitgtk-6.0
json-glib-1.0
```

## 🏗️ Building

Simply clone this repo, then:

```bash
meson _build --prefix=/usr && cd _build
sudo ninja install
```
