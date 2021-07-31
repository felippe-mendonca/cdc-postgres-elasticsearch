#!/bin/bash

if [ ! -f demo-small-en.zip ]; then
  curl -L --output demo-small-en.zip https://edu.postgrespro.com/demo-small-en.zip
fi
if [ ! -f demo-small-en-20170815.sql ]; then
  unzip demo-small-en.zip
fi
