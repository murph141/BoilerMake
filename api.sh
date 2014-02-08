#!/bin/bash

api_file=test.xml
url_file=urls
clean_file=clean.xml
twitter_url=twitter
youtube_url=youtube
pictures=pics
link_file=Profiles

clear
echo "If you don't know any of the values, leave them blank"
read -p "Enter fire name: " firstname
read -p "Enter middle name: " middlename
read -p "Enter last name: " lastname
read -p "Enter state (Two letter code): " state
read -p "Enter city: " city
read -p "Enter email: " email
read -p "Enter phone: " phone
read -p "Enter username: " username

# Create a new directory
dir="$firstname$lastname$username"
mkdir -p $dir
cd $dir

wget -O $api_file "http://api.pipl.com/search/v3/xml/?email=$email&phone=$phone&username=$username&first_name=$firstname&last_name=$lastname&middle_name=$middlename&state=$state&city=$city&exact_name=0&query_params_mode=and&key=samplekey"

sed -e 's/>/>\n/g' -e 's_</_\n</_g' $api_file | grep -v "^$" >> $clean_file
awk '/url/{getline; print}' $clean_file | grep -v \<domain\> | grep -v "^$" | grep -v "peoplesmart" | grep -v "instantcheckmate" | grep -v "api.pipl" | grep -v "^$" | sort -u > $url_file
grep twitter urls | grep -v Support | sort -u > $twitter_url
grep youtube.com/user urls | sort -u > $youtube_url
egrep -i "jpg|png|bmp" urls > $pictures

i=1
mkdir -p Pictures



#Youtube Profile
touch $link_file
echo "Youtube Profile:" > $link_file

if [[ -s "$youtube_url" ]]; then
  for item in `cat $youtube_url`; do
    echo "$item" >> $link_file
  done
else
  echo "No youtube profile found" >> $link_file
fi



#Pictures
echo >> $link_file
echo "Pictures:" >> $link_file

if [[ -s "$pictures" ]]; then
  for item in `cat $pictures`; do
    echo "$item" >> $link_file
    wget -O ./Pictures/pic$i${item: -4} $item
    i=$[i+1]
  done
else
  echo "No pictures found" >> $link_file
fi



#Twitter Profile
echo >> $link_file
echo "Twitter Profile:" >> $link_file

if [[ -s "$twitter_url" ]]; then
  for item in `cat $twitter_url`; do
    echo "$item" >> $link_file
  done
else
  echo "No twitter profile found" >> $link_file
fi


# Removes extra file
rm -f pics twitter youtube

clear
cat ./$link_file
