#!/bin/sh

## Gets rid of redundant METHOD lines.
echo Converting $1
## backup
cp $1 $1_old
sed 's/METHOD/## METHOD/'< $1_old > $1



