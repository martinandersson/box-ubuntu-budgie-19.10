# Changelog

All noteworthy changes to this project will be documented in this file.

The format is based on [Keep a Changelog][changelog-1].

Versioning adheres to [Semantic Versioning][changelog-2], i.e.
*Major.Minor.Patch*.

New box releases do not add additional software unless strictly necessary for
bug fixes and system stability. New releases are most likely a result of a new
version of the included VirtualBox Guest Additions, VMware Tools or a new Linux
kernel.

A version change that affects the "major" part of one of these software
components also bumps the "major" part of this box version. The same strategy is
applied for the "minor" and "patch" parts. The software versions of these
components are documented below.

[changelog-1]: http://keepachangelog.com/en/1.0.0/
[changelog-2]: http://semver.org/spec/v2.0.0.html

## [Unreleased][unreleased-1]

- VirtualBox: Proper 3D acceleration ([issue #2][unreleased-2])

[unreleased-1]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-19.10/compare/v1.0.0...HEAD
[unreleased-2]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-19.10/issues/2

## 1.0.0 - 2020-01-19

Initial release.

### Software

- Ubuntu version: `19.10`
- Budgie version: `10.5`
- Linux Kernel: `5.3.0-26-generic`
- VirtualBox Guest Additions: `6.1.2r135662`
- VMware Tools: `11.0.1.15528 (build-14773994)`
- Built with Packer: `1.5.1`
- ..on host: `Windows Pro 10.0.18363`
