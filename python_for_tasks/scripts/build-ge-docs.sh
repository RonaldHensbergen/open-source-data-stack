#!/usr/bin/env sh
set -eu

great_expectations docs build
rm -rf /site/*
cp -r great_expectations/uncommitted/data_docs/local_site/* /site/
