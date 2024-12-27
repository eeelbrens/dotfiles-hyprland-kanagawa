#!/usr/bin/env bash
IFS=$'\n\t'
while true; do
	# requires playerctl>=2.0
	playerctl --follow metadata --format \
		$'{{status}}\t{{artist}} - {{album}} - {{title}} [{{duration(position)}}-{{duration(mpris:length)}}] - {{playerName}} - {{status}}\t{{position}}\t{{mpris:length}}\t{{artist}} - {{title}}' |
	while read -r status tooltip position length line; do
		# escape [&<>] for pango formatting, json escaping
		line="${line//&/&amp;}"
		line="${line//>/&gt;}"
		line="${line//</&lt;}"
		line="${line//\"/\\\"}"
		if [[ $length =~ ^[0-9]+$ && $length > 0 ]]
		then	
			percentage="$(( (100 * position) / length ))"
		fi
		case $status in
			Paused) text='"<span foreground=\"#313244\">'"$line"'</span>"' ;;
			Playing) text='"<span foreground=\"#cdd6f4\">'"$line"'</span>"' ;;
			*) text=\"\" ;;
esac
		printf '%s\n' '{"text":'"$text"',"tooltip":"'"$tooltip"'","class":"'"$percentage"'","percentage":'"$percentage"'}'
	done
	# no current players
	sleep 15
done
