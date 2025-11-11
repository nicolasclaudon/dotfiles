#!/bin/bash

# Create certificates directory if it doesn't exist
mkdir -p ~/.local/share/certificates

# Extract Capgemini certificates from macOS Keychain
security find-certificate -c "CapgeminiPKIRootCA" -p > ~/.local/share/certificates/capgemini-root.pem
security find-certificate -c "CapgeminiPKIIssuingCA1" -p > ~/.local/share/certificates/capgemini-issuing.pem
security find-certificate -c "ztnzia-internet.capgemini.com" -p > ~/.local/share/certificates/capgemini-ztnzia.pem

# Bundle them together
cat ~/.local/share/certificates/capgemini-root.pem ~/.local/share/certificates/capgemini-issuing.pem ~/.local/share/certificates/capgemini-ztnzia.pem > ~/.local/share/certificates/root.pem

echo "Certificate bundle created: ~/.local/share/certificates/root.pem"
