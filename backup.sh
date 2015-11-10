#!/bin/sh

filename=example_`date +"%y%m%d-%H%M.zip"`

zip -r ../backups/example/${filename} *

echo 'Backups created '${filename}


