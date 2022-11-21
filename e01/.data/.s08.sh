
#!/bin/bash
echo -n "Please enter a filename : "
read file
if [ -e $file ]
then
echo "$file exists."
grep -iw good $file
else
echo "$file does not exist."
exit
fi


