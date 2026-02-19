#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm_setup/chadwm/bar_themes/tokyonight

cpu() {
#  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$green^ 🧠 "
  printf "^c$white^ $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')% ^d^"
}

#pkg_updates() {
#  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
#  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
#  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)
#
#  if [ -z "$updates" ]; then
#    printf "  ^c$green^    Fully Updated"
#  else
#    printf "  ^c$green^    $updates"" updates"
#  fi
#}

batt() {
#  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
#  printf "  ^c$blue^   $get_capacity"
  get_capacity="$(battery)"
  if [ 20 -gt $(cat /sys/class/power_supply/BAT0/capacity) ]; then
      printf "^c$red^  $get_capacity%"
  else
      printf "^c$green^  $get_capacity%"
  fi
}

#brightness() {
#  printf "^c$red^   "
#  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
#}

mem() {
  printf "^c$blue^  "
  printf "^c$white^ $(free -h | awk '/^Mem/ {printf $3 "/" } /^Swap/ {printf $3 }' | sed s/i//g)"
  # printf "^c$blue^ $(memoryusage)%"
}

wlan() {
  speed="$(nettraf)"
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$green^ 󰤨 ^c$white^ $speed ^d^";;
	down) printf " ^c$red^󰤭 ^d^";;
	esac
}

clock() {

    case "$(date '+%I')" in
        "00") icon="🕛" ;;
        "01") icon="🕐" ;;
        "02") icon="🕑" ;;
        "03") icon="🕒" ;;
        "04") icon="🕓" ;;
        "05") icon="🕔" ;;
        "06") icon="🕕" ;;
        "07") icon="🕖" ;;
        "08") icon="🕗" ;;
        "09") icon="🕘" ;;
        "10") icon="🕙" ;;
        "11") icon="🕚" ;;
        "12") icon="🕛" ;;
    esac
	printf "^c$blue^ $icon "
	printf "^c$white^ $(date -d "+1 minutes" '+%H:%M %d/%b')  "
}

music() {
    if [ "$(playerctl status)" = "Playing" ]; then
        printf "^c$blue^  "
        instance=$(playerctl --list-all | head -n1)
        case "$instance" in
        *firefox*) printf "^c$white^ Firefox";;
        *mpv*) 	   printf "^c$white^ MPV";;
        *mpd*) 	   printf "^c$white^ $(playerctl --player=playerctld  metadata --format '{{title}}')";;
        esac
   fi
  # printf "^c$blue^ $([ "$(playerctl status)" = "Playing" ] && playerctl --player=playerctld  metadata --format '{{title}}')"
  # printf "^c$blue^ $([ "$(rmpc status | jq -r .state)" = "Play" ] && rmpc song | jq -r '.metadata.title')"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] 
  interval=$((interval + 1))

  sleep 1 && xsetroot -name " $(batt) $(music) $(cpu) $(mem) $(wlan) $(clock)"
done
