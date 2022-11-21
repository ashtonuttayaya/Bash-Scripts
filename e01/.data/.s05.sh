
grep -i href in*.html > hrefs.txt
grep -iE "jpg|jpeg|gif" in*.html > pics.txt

cat hrefs.txt | wc -l
cat pics.txt | wc -l 
cat pics.txt | grep -i gif | wc -l
