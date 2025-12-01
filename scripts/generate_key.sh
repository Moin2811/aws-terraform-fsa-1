#!/bin/bash
set -e
out="${HOME}/.ssh/projectkey"
ssh-keygen -t rsa -b 2048 -f "${out}" -N ""
echo "Created ${out} and ${out}.pub"
