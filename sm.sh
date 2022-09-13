#/bin/bash
set -eu
cbcontentold=""
wordfilefinnish="kotus-sanalista_v1/kotus-sanalista_v1.xml"
testwordfinnish( ) {
	echo "Converted word candidates: ""$1" "$2"
	if { grep -q ">""$1" "$wordfilefinnish"; } || { grep -q ">""$2" "$wordfilefinnish"; }; then
		echo "Match found from dictionary"
		editclipboard "$1" "$2"
	else
		echo "No matching words in dictionary"
	fi
}

editclipboard( ){
	echo "Clipboard content replaced."
	echo -ne "$1" "$2"" " |xsel -b
}

while ./clipnotify; do
	cbcontent=$(xsel -b)
	if [[ "$cbcontent" != "$cbcontentold" ]]; then
		cbcontentold="$cbcontent"
		spacecount=$(echo "$cbcontent" | head -n 1 | tr -cd ' \t' | wc -c)
		if [[ $spacecount = 1 ]]; then # contains exactly one space
			firstword=$(echo "$cbcontent" | cut -d' ' -f1)
			secondword=$(echo "$cbcontent" | cut -d' ' -f2)
			secondwordthirdchar=$(echo $secondword | cut -c3)
			firstwordthirdchar=$(echo $firstword | cut -c3)
			if [[ "$secondwordthirdchar" == *[AEIOUÅÄÖaeiouåäö]* ]]; then #second word third letter vowel
				out1=$(cut -c1-2 <<< $secondword; cut -c3- <<< $firstword)
				out2=$(cut -c1-2 <<< $firstword; cut -c2 <<< $firstword; cut -c4- <<< $secondword)

			else
				if [[ "$firstwordthirdchar" == *[AEIOUÅÄÖaeiouåäö]* ]]; then #first word third letter vowel
					out1=$(cut -c1-2 <<< $secondword; cut -c2 <<< $secondword; cut -c4- <<< $firstword)
					out2=$(cut -c1-2 <<< $firstword; cut -c3- <<< $secondword)
				else #consonants third letter
					out1=$(cut -c1-2 <<< $secondword; cut -c3- <<< $firstword)
					out2=$(cut -c1-2 <<< $firstword; cut -c3- <<< $secondword)
				fi
			fi
			out1=$(echo "$out1" | tr -d $'\n') #strip away line breaks added by cut command
			out2=$(echo "$out2" | tr -d $'\n')
			testwordfinnish "$out1" "$out2"
		fi
	fi
done


