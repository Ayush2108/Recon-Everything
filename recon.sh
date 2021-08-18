#!/bin/bash


echo "############################################################################"
echo "#                                                                          #"
echo "#                          Recon Tool                                      #"
echo "#                                    -Ayush                                #"
echo "############################################################################"


echo -n "Enter Your Domain: "
read domain

mkdir $domain
cd $domain


echo "#################  Your Scan is starting....  ###################"
echo "###############  I hope you installed all the tools that are required for this Recon  ###############"

echo "Gathering urls with sublist3r......"

sublist3r -d $domain -o sublist3r_url.txt

echo "###############  The output of sublist3r is saved in sublist3r_url.txt file  #################"

echo "Gathering urls with subfinder......"
subfinder -d $domain -o subfinder_url.txt

echo "#################  The output of subfinder is saved in subfinder_url.txt file  #################"


echo "Gathering urls with amass"
amass -enum -d $domain -o amass_url.txt

echo "################  The output of amass is saved in amass_url.txt file  #################"

echo "Sorting the domains..."
sort sublist3r_url.txt subfinder_url.txt amass_url.txt | uniq -u >> final_domains.txt

echo "###############  All domains from three files are saved in final_domains.txt  ###############"

echo "Resolving domins with httpx...."
cat final_domains.txt | httpx -threads=200 | tee -a resolved_domains.txt


echo "###################  Resolved domains are saved in resolved_domains.txt ####################"

echo "Taking Screenshot of domains with aquatone........(Chrome or chromium browsers is required for this tool)"

mkdir screenshots
cd screenshots

cat resolved_domains.txt | aquatone

cd ..

echo "###############   The screenshots are saved in screenshot folder with html report  #################"


echo "Gathering parameters and files with Waybackurl"
cat resolved_domains | waybackurls | tee -a waybackurls.txt

echo "The output of Waybackurl is saved in waybackurl.txt"

echo "Checking xss with gf tool ........."
cat waybackurls.txt | gf xss | tee -a gf_xss.txt

echo "Checking ssrf with gf tool......."
cat waybackurls.txt | gf ssrf | tee -a gf_ssrf.txt


echo "Checking sqli  with gf tool........"
cat waybackurls.txt | gf sqli | tee -a gf_sqli.txt


echo "Checking RCE with gf tool.........."
cat waybackurls.txt | gf rce | tee -a gf_rce.txt


echo "Checking for Subdomain takeover with subzy tool........"
subzy --target=resolved_domains.txt | tee -a subzy.txt




echo "############################################################################"
echo "#                                                                          #"
echo "#                        Your scan is completed                            #"
echo "#                                                                          #"
echo "#                           Happy Hunting :)                               #"
echo "#                                                                          #"
echo "############################################################################"




























