#!/bin/bash

set -ex

SCHEMA="./../../../../tmp/schema.json"

apollo-codegen introspect-schema http://localhost:4000/graphql --output $SCHEMA
apollo-codegen generate ./js/store/reducers/accounts.ts \
  --schema $SCHEMA \
  --target typescript \
  --output js/Schema.ts
