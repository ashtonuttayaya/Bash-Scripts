
#!/bin/bash
fname=$1
lname=$2
echo "The characters lengths are requested for $fname and $lname"
wc -c $fname
wc -c $lname

