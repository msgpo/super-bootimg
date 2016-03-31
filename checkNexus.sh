#!/bin/bash

regexp='https://dl.google.com/dl/android/aosp/([a-z]+)-([a-z]{3}[0-9]{2}[a-z])-factory-[0-9a-f]*.tgz'
curl -s https://developers.google.com/android/nexus/images |
	grep -F '<a href="https://dl.google.com/dl/android/aosp/'|
	grep -oE "$regexp" |
	while read url;do
		device="$( sed -E 's|'"$regexp"'|\1|g' <<<$url )"
		releaseLower="$( sed -E 's|'"$regexp"'|\2|g' <<<$url )"
		release="$( sed -E 's|'"$regexp"'|\2|g' <<<$url |tr a-z A-Z)"

		filename="known-imgs/nexus/${device}/${release}"
		[ -f $filename ] && continue
		mkdir -p $(dirname $filename)

		cat > $filename << EOF
$url
image-$device-${releaseLower}.zip
boot.img
EOF
done
