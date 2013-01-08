curl -X POST --data-urlencode content@README.new.md \
http://documentup.com/compiled -d"name=Mocky"  > index.html && open index.html
