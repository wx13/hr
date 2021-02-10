# HR -- horizontal rule in the console.

# Returns a color based on the day of the week.
_hr_color_of_the_day() {
	colors=('m' 'w' 'b' 'g' 'c' 'y' 'r')
	echo ${colors[$(date +'%w')]}
}


# Define a convenient mapping from letter to color code.
declare -A _hr_color_map
_hr_color_map=(
	['r']="\e[41m"
	['y']="\e[43m"
	['g']="\e[42m"
	['b']="\e[44m"
	['m']="\e[45m"
	['c']="\e[46m"
	['w']="\e[47m"
	['k']="\e[40m"
)


# Prints a colorful horizontal rule.
hr() {
	colors=${@}
	if [ "${colors}" = "" ]; then
		colors=$(_hr_color_of_the_day)
	fi

	for color in $colors; do
		if [ "${#color}" = 1 ]; then
			echo -en ${_hr_color_map[$color]}
	 		head -c $COLUMNS < /dev/zero | tr '\0' ' '
	 		echo -e "\e[0m"
		else
			col=0
			while [ $col -lt $COLUMNS ]; do
				for (( i=0; i<${#color}; i++,col++ )); do
					if [ $col -ge $COLUMNS ]; then
						break
					fi
					c="${color:$i:1}"
					echo -en "${_hr_color_map[$c]} "
				done
			done
			echo -e "\e[0m"
		fi
	done
}
