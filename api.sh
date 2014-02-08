#!/bin/bash

api_file=test.xml
url_file=urls
clean_file=clean.xml
twitter_url=twitter
youtube_url=youtube
pictures=pics

clear
echo "If you don't know any of the values, leave them blank"
read -p "Enter fire name: " firstname
read -p "Enter middle name: " middlename
read -p "Enter last name: " lastname
read -p "Enter state: " state
read -p "Enter city: " city
read -p "Enter email: " email
read -p "Enter phone: " phone
read -p "Enter username: " username

wget -O $api_file "http://api.pipl.com/search/v3/xml/?email=$email&phone=$phone&username=$username&first_name=$firstname&last_name=$lastname&middle_name=$middlename&state=$state&city=$city&exact_name=0&query_params_mode=and&key=samplekey"

#wget -O $api_file "http://api.pipl.com/search/v3/xml/?first_name=$first&last_name=$last&state=$state&city=$city&exact_name=0&query_params_mode=and&key=samplekey"
#wget -O $api_file "http://api.pipl.com/search/v3/xml/?first_name=Alex&last_name=Akagi&state=Indiana&city=Indianapolis&exact_name=0&query_params_mode=and&key=samplekey"

sed -e 's/>/>\n/g' -e 's_</_\n</_g' $api_file >> $clean_file
awk '/url/{getline; print}' $clean_file | grep -v \<domain\> | grep -v "^$" | grep -v "peoplesmart" | grep -v "instantcheckmate" | grep -v "api.pipl" | sort -u > $url_file
grep twitter urls | grep -v Support | sort -u > $twitter_url
grep youtube.com/user urls | sort -u > $youtube_url
egrep -i "jpg|png|bmp" urls > $pictures

#num_pics=`wc -l $pictures | awk '{ print $1 }'`

i=1

mkdir -p Pictures

for item in `cat $pictures`; do
  wget -O ./Pictures/pic$i.jpg $item
  i=$[i+1]
done
