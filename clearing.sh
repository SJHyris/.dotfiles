#Scripts used to clear and visualize the space left

# du shows disk usage
#
# this lists inside root (sorted)
# du -d1 -h / 2>/dev/null | sort -h
#
# this lists inside usr and var (sorted)
# du -d1 -h /var /usr 2>/dev/null | sort -h
#
# For /var/logs (learn to config journalctl)
#	journalctl --disk-usage
#	journalctl --vacuum-size=100M
#
# For /var/cache
#	pacman -Sc (normal clear)
#	pacman -Scc (aggressive clear)
#
# 
