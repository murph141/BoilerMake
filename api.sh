#!/bin/bash

#File definitions
api_file=test.xml
url_file=Urls
clean_file=clean.xml
twitter_url=Twitter
youtube_url=Youtube
pictures=Pics
link_file=Profiles
family_file=Family
id_file=IDs
date_file=Birthday

#Take the user input
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


#Generate xml file via the Pipl API
wget -O $api_file "http://api.pipl.com/search/v3/xml/?email=$email&phone=$phone&username=$username&first_name=$firstname&last_name=$lastname&middle_name=$middlename&state=$state&city=$city&exact_name=0&query_params_mode=and&key=samplekey"

#Generate clean file
sed -e 's/>/>\n/g' -e 's_</_\n</_g' $api_file | grep -v "^$" >> $clean_file

#Generate url file
awk '/url/{getline; print}' $clean_file | grep -v \<domain\> | grep -v "^$" | grep -v "peoplesmart" | grep -v "instantcheckmate" | grep -v "api.pipl" | grep -v "^$" | grep -v \< | sort -u > $url_file

#Generate twitter file
grep twitter $url_file | grep -v Support | sort -u > $twitter_url

#Generate youtube file
grep youtube.com/user $url_file | sort -u > $youtube_url

#Generate picture file
egrep -i "jpg|png|bmp" $url_file > $pictures

#Generate family file
awk '/family/{getine; getline; getline; getline; getline; getline; getine; getline; getline; getline; getline; getline; getline; getline; print}' $clean_file | sort -u > $family_file

#Generate ID file
awk '/<user_id>/{getline; print}' $clean_file | sort -u > $id_file

#Generate Phone Number file
awk '/<date_range>/{getline; getine; print}' $clean_file | grep -v 01-01 | grep -v 12-31 | sort -u >> $date_file

#Counter variable
i=1

#Make a directory to store the pictures
mkdir -p Pictures


touch $link_file
echo "Information Supplied:" > $link_file
echo "First name: $firstname" >> $link_file
echo "Middle name: $middlename" >> $link_file
echo "Last name: $lastname" >> $link_file
echo "State: $state" >> $link_file
echo "City: $city" >> $link_file
echo "Email: $email" >> $link_file
echo "Phone: $phone" >> $link_file
echo "Username: $username" >> $link_file


#Youtube Profile
echo >> $link_file
echo "Possible Youtube Profile(s):" >> $link_file

if [[ -s "$youtube_url" ]]; then
  for item in `cat $youtube_url`; do
    echo "$item" >> $link_file
  done
else
  echo "No possible youtube profile(s) found" >> $link_file
fi



#Pictures
echo >> $link_file
echo "Possible Picture(s):" >> $link_file

if [[ -s "$pictures" ]]; then
  for item in `cat $pictures`; do
    echo "$item" >> $link_file
    wget -O ./Pictures/pic$i${item: -4} $item
    i=$[i+1]
  done
else
  echo "No possible picture(s) found" >> $link_file
fi



#Twitter Profile
echo >> $link_file
echo "Possible Twitter Profile(s):" >> $link_file

if [[ -s "$twitter_url" ]]; then
  for item in `cat $twitter_url`; do
    echo "$item" >> $link_file
  done
else
  echo "No possible twitter profile(s) found" >> $link_file
fi



#Family Members
echo >> $link_file
echo "Possible family members:" >> $link_file

if [[ -s "$family_file" ]]; then
  while read p; do
    echo $p >> $link_file
  done < $family_file
else
  echo "No possible family member(s) found" >> $link_file
fi



#IDs
echo >> $link_file
echo "Possible user ID(s):" >> $link_file

if [[ -s "$id_file" ]]; then
  for item in `cat $id_file`; do
    echo "$item" >> $link_file
  done
else
  echo "No possible user ID(s) found" >> $link_file
fi



#Birthdays
echo >> $link_file
echo "Possible Birthday(s):"

if [[ -s "$date_file" ]]; then
  for item in `cat $date_file`; do
    echo "$item" >> $link_file
  done
else
  echo "No possible birthday(s) found" >> $link_file
fi



# Removes extra file
rm -f $api_file $url_file $clean_file $twitter_file $youtube_url $pictures $family_file $id_file $date_file

clear
cat ./$link_file
