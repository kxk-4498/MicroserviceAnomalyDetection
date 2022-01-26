#!/bin/sh

# Install cilium
cilium install
# Enable hubble
cilium hubble enable
cilium hubble port-forward&