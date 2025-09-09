#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm_setup/chadwm/bar_themes/tokyonight

cpu() {
#  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  cpu_val=$(cpuusage)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val%"
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

net_speed() {
#  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
#  printf "  ^c$blue^   $get_capacity"
  speed="$(nettraf)"
  printf "  ^c$blue^  $speed"
}

#brightness() {
#  printf "^c$red^   "
#  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
#}

mem() {
  printf "^c$blue^^b$black^  "
#  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
  printf "^c$blue^ $(memoryusage)%"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf " ^c$blue^󰤨 ^d^";;
	down) printf " ^c$blue^󰤭 ^d^";;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] 
  interval=$((interval + 1))

  sleep 1 && xsetroot -name " $(net_speed) $(batt) $(cpu) $(mem) $(wlan) $(clock)"
done
