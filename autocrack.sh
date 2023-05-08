#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
dir=${PWD%}
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo ""
   echo ""
   echo "${green}Auto Crack ntds.dit files."
   echo
   echo "Syntax: ./autocrack.sh [-d <root folder>] [-w <path to wordlist>] [-p <path to potfile>] [-r <path to rule file>]"
   echo "options:"
   echo "-d     Full path to where ntds.dit and SYSTEM are located, Mandatory,"
   echo "-p     Full path to hashcat.potfile, Optional if not specified defualt path will be used"
   echo "-r     Full path to rule to be used for hashcat, Optional if not specified, CombinedRules will be used."
   echo "-w     Full path to wordlist to be used for hashcat, Mandatory.${reset}"
   echo
   #echo "or"
   #echo "./autocrack.sh -c CUSTOMERNAME -s${reset}"
}
#checks for arguments
d_used=false p_used=false r_used=false w_used=false
while getopts ":d:p:r:w:" option; do
        case $option in
                h) # display help
                        Help
                        exit;;
                d) # Full path to where ntds.dit and SYSTEM are located.
                        WORKDIR=${OPTARG};;
                p) # Full path to hashcat.potfile
                        p_used=true
                        POT=${OPTARG};;
				r) # Full path to rule to be used for hashcat
                        r_used=true
                        RULE=${OPTARG};;
				w) # Full path to rule to be used for hashcat
                        w_used=true
                        WORDLIST=${OPTARG};;
                \?) # invalid Option
                        echo "${red}Error: invalid option${reset}"
                        exit;;
        esac
done

if [ ! "$WORKDIR" ] || [ ! "$WORDLIST" ]; then
        echo "${red}Arguments -d and -w must be provided${reset}"
        Help
        exit 1
fi
if [ `whoami` = root ]; then
	echo Please do not run this script as root or using sudo
	exit
fi
if r_used=false; then
	# Enter location to your rule file
	RULE=/usr/share/hashcat/rules/combinedrules.rule
fi
if p_used=false; then
	# Location to your potfile
	POT=~/.local/share/hashcat/hashcat.potfile
fi

# Ensures files stay in working directory
cd $WORKDIR
# Dumps the hashes from ntds.dit
impacket-secretsdump -system $WORKDIR/SYSTEM  -ntds $WORKDIR/ntds.dit LOCAL -outputfile hashes -history
# Cracks LM passwords first
hashcat -m 3000 -a 3 $WORKDIR/hashes.ntds -1 ?a ?1?1?1?1?1?1?1 --increment --session LM
# Dumps cracked hashes to text (combines the 2 LM hashes for the full uppercase passwords
hashcat -m 3000 $WORKDIR/hashes.ntds --show | sort -u | tee pass.txt
# Coverts uppercase passwords to actually case sentivie passwords
python3 $dir/main.py -lp pass.txt -nd $WORKDIR/hashes.ntds > $WORKDIR/userpass.txt
# Grabs just the passwords to use as a wordlist for additional cracking
cat $WORKDIR/userpass.txt | cut -d : -f2 > $WORKDIR/passwords.txt
# Grabs cleartext passwords dumped from ntds.dit and adds to wordlist
cat $WORKDIR/hashes.ntds.cleartext | cut -d : -f3 >> $WORKDIR/passwords.txt
# Ensures wordlist has no duplicate words
cat $WORKDIR/passwords.txt | sort | uniq -u > $WORKDIR/pass.txt
# Sets var for loop
POTFILE2="0"
# Cracks passwords with generated wordlists from LM cracking and cleartext passwords.  Will keep looping
# until it no longer cracks additional passwords.
while [ "$POTFILE" != "$POTFILE2" ]; do
	# checks size of potfile to determine if new passwords were cracked
	POTFILE=$(wc -l < $POT)
	# creates new wordlist
	if [ "$POTFILE" != "$POTFILE2" ]; then
		echo "Generating Next Word list to try"
		cat $POT | cut -d : -f2 > $WORKDIR/pass2.txt
		echo "Converting wordlist to lowercase"
		tr '[:upper:]' '[:lower:]' < $WORKDIR/pass2.txt > $WORKDIR/pass3.txt
		rm $WORKDIR/pass2.txt
		echo "runing munge, this may take a while"
		python $dir/munge.py -l 9 -i $WORKDIR/pass3.txt -o $WORKDIR/pass.txt
		rm $WORKDIR/pass3.txt
	fi
	# cracks passwords using generated wordlist above and uses the combined rule.
	hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/hashes.ntds $WORKDIR/pass.txt -r $RULE --session NTLM
	# checks potfile for new lines
	POTFILE2=$(wc -l < $POT)
	echo $POTFILE
	echo $POTFILE2
done
# Cracks passwords from RockYou 2021 wordlist Edit path to your wordlist
hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/hashes.ntds $WORDLIST -r $RULE --session RockYou21
#POTFILE="1"
#POTFILE2="0"
cat $POT | cut -d : -f2 > $WORKDIR/pass.txt
while [ "$POTFILE" != "$POTFILE2" ]; do
	POTFILE=$(wc -l < $POT)


	if [ "$POTFILE" != "$POTFILE2" ]; then
		echo "Generating Next Word list to try"
		cat $POT | cut -d : -f2 > $WORKDIR/pass2.txt
		echo "Converting wordlist to lowercase"
		tr '[:upper:]' '[:lower:]' < $WORKDIR/pass2.txt > $WORKDIR/pass3.txt
		#rm $WORKDIR/pass2.txt
		echo "runing munge, this may take a while"
		python $dir/munge.py -l 9 -i $WORKDIR/pass3.txt -o $WORKDIR/pass.txt
		#rm $WORKDIR/pass3.txt
	fi
	hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/hashes.ntds $WORKDIR/pass.txt -r $RULE --session EndPhase
	POTFILE2=$(wc -l < $POT)
	echo $POTFILE
	echo $POTFILE2
done
#rm $WORKDIR/*.txt $WORKDIR/.txt
