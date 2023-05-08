#!/bin/sh
# Directory where customer/project files are located
WORKDIR=/mnt/d
# Directory where your ntds.dit and SYSTEM files are located usually the name of customer/project
NTDSDIR=2023-4
# Enter location to your wordlist
WORDLIST=/mnt/d/ry2021/rockyou2021.txt
# Enter location to your rule file
RULE=/usr/share/hashcat/rules/combinedrules.rule
# Location to your potfile
POT=~/.local/share/hashcat/hashcat.potfile
# Ensures files stay in working directory
cd $WORKDIR/$NTDSDIR
# Dumps the hashes from ntds.dit
impacket-secretsdump -system $WORKDIR/$NTDSDIR/SYSTEM  -ntds $WORKDIR/$NTDSDIR/ntds.dit LOCAL -outputfile $NTDSDIR -history
# Cracks LM passwords first
hashcat -m 3000 -a 3 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds -1 ?a ?1?1?1?1?1?1?1 --increment
# Dumps cracked hashes to text (combines the 2 LM hashes for the full uppercase passwords
hashcat -m 3000 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds --show | sort -u | tee $NTDSDIR_pass.txt
# Coverts uppercase passwords to actually case sentivie passwords
python3 ~/AutoCrack/main.py -lp $NTDSDIR_pass.txt -nd $WORKDIR/$NTDSDIR/$NTDSDIR.ntds > $WORKDIR/$NTDSDIR/$NTDSDIR-up.txt
# Grabs just the passwords to use as a wordlist for additional cracking
cat $WORKDIR/$NTDSDIR/$NTDSDIR-up.txt | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt
# Grabs cleartext passwords dumped from ntds.dit and adds to wordlist
cat $WORKDIR/$NTDSDIR/$NTDSDIR.ntds.cleartext | cut -d : -f3 >> $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt
# Ensures wordlist has no duplicate words
cat $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt | sort | uniq -u > $NTDSDIR-pass.txt
# Sets var for loop
POTFILE2="0"
# Cracks passwords with generated wordlists from LM cracking and cleartext passwords.  Will keep looping
# until it no longer cracks additional passwords.
while [ "$POTFILE" != "$POTFILE2" ]; do
	# checks size of potfile to determine if new passwords were cracked
	POTFILE=$(wc -l < $POT)
	# cracks passwords using generated wordlist above and uses the combined rule.
	hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt -r $RULE --session $NTDSDIR
	# checks potfile for new lines
	POTFILE2=$(wc -l < $POT)
	echo $POTFILE
	echo $POTFILE2
	# creates new wordlist
	if [ "$POTFILE" != "$POTFILE2" ]; then
		cat $POT | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt
		tr '[:upper:]' '[:lower:]' < $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt >> $WORKDIR/$NTDSDIR/$NTDSDIR-pass3.txt
		rm $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt
		python munge.py -l 9 -i $WORKDIR/$NTDSDIR/NTDSDIR-pass3.txt -o $WORKDIR/$NTDSDIR/NTDSDIR-pass.txt
		rm $WORKDIR/$NTDSDIR/$NTDSDIR-pass3.txt
	fi
done
# Cracks passwords from RockYou 2021 wordlist Edit path to your wordlist
hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds $WORDLIST -r $RULE --session $NTDSDIR
POTFILE="1"
POTFILE2="0"
cat $POT | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt
while [ "$POTFILE" != "$POTFILE2" ]; do
	POTFILE=$(wc -l < $POT)
	hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt -r $RULE --session $NTDSDIR
	POTFILE2=$(wc -l < $POT)
	echo $POTFILE
	echo $POTFILE2
	if [ "$POTFILE" != "$POTFILE2" ]; then
		cat $POT | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt
		tr '[:upper:]' '[:lower:]' < $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt >> $WORKDIR/$NTDSDIR/$NTDSDIR-pass3.txt
		rm $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt
		python munge.py -l 9 -i $WORKDIR/$NTDSDIR/NTDSDIR-pass3.txt -o $WORKDIR/$NTDSDIR/NTDSDIR-pass.txt
		rm $WORKDIR/$NTDSDIR/$NTDSDIR-pass3.txt
	fi
done
rm $WORKDIR/$NTDSDIR/*.txt 
