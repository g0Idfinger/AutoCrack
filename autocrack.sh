#!/bin/sh
# Directory where customer/project files are located
WORKDIR=/mnt/d
# Directory where your ntds.dit and SYSTEM files are located usually the name of customer/project
NTDSDIR=test
# Ensures files stay in working directory
cd $WORKDIR/$NTDSDIR
# Dumps the hashes from ntds.dit
impacket-secretsdump -system $WORKDIR/$NTDSDIR/SYSTEM  -ntds $WORKDIR/$NTDSDIR/ntds.dit LOCAL -outputfile $NTDSDIR -history
# Cracks LM passwords first
#hashcat -m 3000 -a 3 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds -1 ?a ?1?1?1?1?1?1?1 --increment
# Dumps cracked hashes to text (combines the 2 LM hashes for the full uppercase passwords
hashcat -m 3000 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds --show | sort -u | tee $NTDSDIR_pass.txt
# Coverts uppercase passwords to actually case sentivie passwords
python3 ~/AutoCrack/main.py -lp $NTDSDIR_pass.txt -nd $WORKDIR/$NTDSDIR/$NTDSDIR.ntds > $WORKDIR/$NTDSDIR/$NTDSDIR-up.txt
cat $WORKDIR/$NTDSDIR/$NTDSDIR-up.txt | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt
cat $WORKDIR/$NTDSDIR/$NTDSDIR.ntds.cleartext | cut -d : -f3 >> $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt
cat $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt | sort | uniq -u > $NTDSDIR-pass.txt
#sed -e 's/[;,()'\'']/ /g;s/ */ /g' $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt | tr '[:upper:]' '[:lower:]' >> $WORKDIR/$NTDSDIR/$NTDSDIR-passwords.txt
POTFILE2="0"
while [ "$POTFILE" != "$POTFILE2" ]; do
	POTFILE=$(wc -l < ~/.local/share/hashcat/hashcat.potfile)
	hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt -r /usr/share/hashcat/rules/combinedrules.rule --session $NTDSDIR
	POTFILE2=$(wc -l < ~/.local/share/hashcat/hashcat.potfile)
	echo $POTFILE
	echo $POTFILE2
	if [ "$POTFILE" != "$POTFILE2" ]; then
		cat ~/.local/share/hashcat/hashcat.potfile | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt
		tr '[:upper:]' '[:lower:]' < $WORKDIR/$NTDSDIR/$NTDSDIR-pass2.txt > $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt
	fi
done
hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds /mnt/d/ry2021/rockyou2021.txt -r /usr/share/hashcat/rules/combinedrules.rule --session $NTDSDIR
POTFILE="1"
POTFILE2="0"
cat ~/.local/share/hashcat/hashcat.potfile | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt
while [ "$POTFILE" != "$POTFILE2" ]; do
	POTFILE=$(wc -l < ~/.local/share/hashcat/hashcat.potfile)
	hashcat -d1 -O -w4 -m 1000 -a 0 $WORKDIR/$NTDSDIR/$NTDSDIR.ntds $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt -r /usr/share/hashcat/rules/combinedrules.rule --session $NTDSDIR
	POTFILE2=$(wc -l < ~/.local/share/hashcat/hashcat.potfile)
	echo $POTFILE
	echo $POTFILE2
	if [ "$POTFILE" != "$POTFILE2" ]; then
		cat ~/.local/share/hashcat/hashcat.potfile | cut -d : -f2 > $WORKDIR/$NTDSDIR/$NTDSDIR-pass.txt
	fi
done
