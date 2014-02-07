#!/bin/bash

api_file=test.xml
url_file=urls
clean_file=clean.xml

read -p "Enter the desired fire name: " first
read -p "Enter the desired last name: " last
read -p "Enter the desired state: " state
read -p "Enter the desired city: " city

wget -O $api_file "http://api.pipl.com/search/v3/xml/?first_name=$first&last_name=$last&state=$state&city=$city&exact_name=0&query_params_mode=and&key=samplekey"
#wget -O $api_file "http://api.pipl.com/search/v3/xml/?first_name=Alex&last_name=Akagi&state=Indiana&city=Indianapolis&exact_name=0&query_params_mode=and&key=samplekey"

sed -e 's/>/>\n/g' -e 's_</_\n</_g' $api_file >> $clean_file
awk '/url/{getline; print}' $clean_file | grep -v \<domain\> | grep -v "^$" | grep -v "peoplesmart" | grep -v "instantcheckmate" | grep -v "api.pipl" >> $url_file
