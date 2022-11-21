#!/bin/bash
cp backup target
diff target backup
sed -i 's/KEY/Answer Key/g' target
sed -i 's/OK/Great!/g' target


