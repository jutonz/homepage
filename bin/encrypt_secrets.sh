#!/bin/bash

set -e

keyfile="key.txt"
decrypted_secretfile="secrets.txt"
encrypted_secretfile="secrets.txt.encrypted"

if ! command -v ccrypt > /dev/null; then
  echo "Please install ccrypt and run this script again"
  exit 1
fi

if ! test -f "$keyfile"; then
  echo "The keyfile \"$keyfile\" is not present. Please add it then run this script again."
  echo ""
  echo "You can do this by finding the secret \"Secret key\" in 1password,"
  echo "then running \`echo -n \"[secret key]\" > $keyfile"\`
  exit 1
fi

if test -f $encrypted_secretfile; then
  echo "It looks like the secrets are already present at \"$encrypted_secretfile\""
  echo "Did you mean to decrypt them?"
  exit 1
fi

if ! test -f "$decrypted_secretfile"; then
  echo "Expected to find a secret file at \"$decrypted_secretfile\" but did not."
  echo "Please check this and try again."
  exit 1
fi

set -x

ccrypt \
  --encrypt \
  --keyfile $keyfile \
  --suffix ".encrypted" \
  $decrypted_secretfile

echo "Encrypted secrets to \"$encrypted_secretfile\""
