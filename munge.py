#!/usr/bin/env python3
import argparse
__author__ = 'th3s3cr3tag3nt'

parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='''
 _ __ ___  _   _ _ __   __ _  ___   _ __  _   _
| '_ ` _ \\| | | | '_ \\ / _` |/ _ \\ | '_ \\| | | |
| | | | | | |_| | | | | (_| |  __/_| |_) | |_| |
|_| |_| |_|\\__,_|_| |_|\\__, |\\___(_)_.__/ \\__, |
                        __/ |             __/ |
                       |___/             |___/
Dirty little word munger by Th3 S3cr3t Ag3nt.
''')

parser.add_argument('word', metavar='word', nargs='?',
                    help='word to munge')
                    
parser.add_argument('-l', '--level', type=int, default=5,
                    help='munge level [0-9] (default 5)')
                    
parser.add_argument('-i', '--input', dest='input',
                    help='input file')
                    
parser.add_argument('-o', '--output', dest='output',
                    help='output file')
 
# Parse the arguments 
args = parser.parse_args()

# Limit the level
if args.level > 9:
    args.level = 9
if args.level < 0:
    args.level = 0

# create word list
wordlist = []

def munge(wrd, level):
    global wordlist
    if level > 0:
        wordlist.append(wrd)
        wordlist.append(wrd.upper())
        wordlist.append(wrd.capitalize())

    if level > 2:
        temp = wrd.capitalize()
        wordlist.append(temp.swapcase())

    # Leet speak
    if level > 4:
        wordlist.append(wrd.replace('e', '3'))
        wordlist.append(wrd.replace('a', '4'))
        wordlist.append(wrd.replace('o', '0'))
        wordlist.append(wrd.replace('i', '!'))
        wordlist.append(wrd.replace('i', '1'))
        wordlist.append(wrd.replace('l', '1'))
        wordlist.append(wrd.replace('a', '@'))
        wordlist.append(wrd.replace('s', '$'))

    # Leet speak conmbinations
    if level > 4:
        temp = wrd
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '4')
        temp = temp.replace('o', '0')
        temp = temp.replace('i', '1')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

    if level > 4:
        temp = wrd
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '@')
        temp = temp.replace('o', '0')
        temp = temp.replace('i', '1')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

    if level > 4:
        temp = wrd
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '4')
        temp = temp.replace('o', '0')
        temp = temp.replace('i', '!')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

    if level > 4:
        temp = wrd
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '4')
        temp = temp.replace('o', '0')
        temp = temp.replace('l', '1')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

	# Capitalize
    if level > 4:
        temp = wrd.capitalize()
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '4')
        temp = temp.replace('o', '0')
        temp = temp.replace('i', '1')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

    if level > 4:
        temp = wrd.capitalize()
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '@')
        temp = temp.replace('o', '0')
        temp = temp.replace('i', '1')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

    if level > 4:
        temp = wrd.capitalize()
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '4')
        temp = temp.replace('o', '0')
        temp = temp.replace('i', '!')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

    if level > 4:
        temp = wrd.capitalize()
        temp = temp.replace('e', '3')
        temp = temp.replace('a', '4')
        temp = temp.replace('o', '0')
        temp = temp.replace('l', '1')
        temp = temp.replace('s', '$')
        wordlist.append(temp)

def mungeword(wrd, level):
    global wordlist
    munge(wrd, level)

    if level > 4:
        munge(wrd + '1', level)
        munge(wrd + '123456', level)
        munge(wrd + '12', level)
        munge(wrd + '2', level)
        munge(wrd + '123', level)
        munge(wrd + '!', level)
        munge(wrd + '.', level)

    if level > 6:
        munge(wrd + '?', level)
        munge(wrd + '_', level)
        munge(wrd + '0', level)
        munge(wrd + '01', level)
        munge(wrd + '69', level)
        munge(wrd + '21', level)
        munge(wrd + '22', level)
        munge(wrd + '23', level)
        munge(wrd + '1234', level)
        munge(wrd + '8', level)
        munge(wrd + '9', level)
        munge(wrd + '10', level)
        munge(wrd + '11', level)
        munge(wrd + '13', level)
        munge(wrd + '3', level)
        munge(wrd + '4', level)
        munge(wrd + '5', level)
        munge(wrd + '6', level)
        munge(wrd + '7', level)

    if level > 7:
        munge(wrd + '07', level)
        munge(wrd + '08', level)
        munge(wrd + '09', level)
        munge(wrd + '14', level)
        munge(wrd + '15', level)
        munge(wrd + '16', level)
        munge(wrd + '17', level)
        munge(wrd + '18', level)
        munge(wrd + '19', level)
        munge(wrd + '24', level)
        munge(wrd + '77', level)
        munge(wrd + '88', level)
        munge(wrd + '99', level)
        munge(wrd + '12345', level)
        munge(wrd + '123456789', level)

    if level > 8:
        munge(wrd + '00', level)
        munge(wrd + '02', level)
        munge(wrd + '03', level)
        munge(wrd + '04', level)
        munge(wrd + '05', level)
        munge(wrd + '06', level)
        munge(wrd + '19', level)
        munge(wrd + '20', level)
        munge(wrd + '25', level)
        munge(wrd + '26', level)
        munge(wrd + '27', level)
        munge(wrd + '28', level)
        munge(wrd + '007', level)
        munge(wrd + '1234567', level)
        munge(wrd + '12345678', level)
        munge(wrd + '111111', level)
        munge(wrd + '111', level)
        munge(wrd + '777', level)
        munge(wrd + '666', level)
        munge(wrd + '101', level)
        munge(wrd + '33', level)
        munge(wrd + '44', level)
        munge(wrd + '55', level)
        munge(wrd + '66', level)
        munge(wrd + '2008', level)
        munge(wrd + '2009', level)
        munge(wrd + '2010', level)
        munge(wrd + '2011', level)
        munge(wrd + '86', level)
        munge(wrd + '87', level)
        munge(wrd + '89', level)
        munge(wrd + '90', level)
        munge(wrd + '91', level)
        munge(wrd + '92', level)
        munge(wrd + '93', level)
        munge(wrd + '94', level)
        munge(wrd + '95', level)
        munge(wrd + '98', level)

if args.word:
    wrd = args.word.lower()
    mungeword(wrd, args.level)
elif args.input:
    # Open the file with read only permit
    try:
        with open(args.input) as f:
            for wrd in f:
                mungeword(wrd.rstrip(), args.level)
            f.close()
    except IOError:
        print("Exiting\nCould not read file:", args.input)
else:
    print("Nothing to do!!\nTry -h for help.\n")

wordlist = set(wordlist)

if args.output:
    # Open the file with write permit
    try:
        with open(args.output, 'w') as f:
            for word in wordlist:
                # print(word)
                f.write(word + "\n")
            f.close()
            print("Written to:", args.output)
    except IOError:
        print("Exiting\nCould not write file:", args.output)
else:
    for word in wordlist:
        print(word)
