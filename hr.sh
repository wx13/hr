# HR -- horizontal rule in the console.

# Returns a color based on the day of the week.
_hr_color_of_the_day() {
	local colors=('m' 'w' 'b' 'g' 'c' 'y' 'r')
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


# Expands a singl row of color.
_hr_expand_color_row() {
	local expanded_colors=""
	local num=""
	local colors=$1
	for (( i=0; i<${#colors}; i++ )); do
		local color="${colors:$i:1}"
		if [[ $color =~ [0-9] ]]; then
			num="$num$color"
		else
			if [ ! -z "$num" ]; then
				color=$(printf "%${num}s" | sed "s/ /${color}/g")
				num=""
			fi
			expanded_colors="${expanded_colors}${color}"
		fi
	done
	echo $expanded_colors
}

# Expands shorthand within the color spec.
_hr_expand_colors() {
	local expanded_colors=""
	local last_color
	for color in ${@}; do
		color=$(_hr_expand_color_row $color)
		if [[ $color =~ [0-9]+ ]]; then
			color=$(printf "%$(($color-1))s" | sed "s/ /${last_color} /g")
		fi
		expanded_colors="${expanded_colors} ${color}"
		last_color=${color}
	done
	echo $expanded_colors
}


# Prints a colorful horizontal rule.
hr() {
	# Use specified color, or color of the day.
	local colors=${@}
	if [ "${colors}" = "" ]; then
		colors=$(_hr_color_of_the_day)
	else
		colors=$(_hr_expand_colors $colors)
	fi

	# Each separate "word" is a line of color.
	for color in $colors; do
		if [ "${#color}" = 1 ]; then
			# Singular color spec. Set the color and fill out the columns.
			echo -en ${_hr_color_map[$color]}
			head -c $COLUMNS < /dev/zero | tr '\0' ' '
			echo -e "\e[0m"
		else
			# Multiple colors for this line. Iterate over columns.
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
