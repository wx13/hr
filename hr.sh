# HR -- horizontal rule in the console.

# Some fun presets
_hr_flag_aut="r w r"
_hr_flag_bel="2k2y2r 2"
_hr_flag_ben="2g3yk 2g3rk"
_hr_flag_bgr="w g r"
_hr_flag_bwa="30c5k 4 30w5k 30k5k 2 30w5k 30c5k 4"
_hr_flag_che="4r2w4r2k 2r6w2r2k 4r2w4r2k"
_hr_flag_chl="2b4w2k 6r2k"
_hr_flag_col="y y b r"
_hr_flag_dnk="2r2w4r2k 8w2k 2r2w4r2k"
_hr_flag_est="b k w"
_hr_flag_fin="2b2w4b2k 8w2k 2b2w4b2k"
_hr_flag_fra="2b2w2r2k 2"
_hr_flag_irl="2g2w2y2k 2"
_hr_flag_ita="2g2w2r2k 2"
_hr_flag_jpn="8w2k 3w2r3w2k 8w2k"
_hr_flag_lva="r 2 w r 2"
_hr_flag_ltu="y g r"
_hr_flag_nor="2rwbw6r2k 2 3wb7w2k 11b2k 3wb7w2k 2rwbw6r2k 2"
_hr_flag_plw="8c2k 2c2y4c2k 8c2k"
_hr_flag_swe="2b2y4b2k 8y2k 2b2y4b2k"
_hr_flag_tha="r w b 2 w r"
_hr_flag_uae="2r5g 2r5w 2r5k"
_hr_flag_ury="4w6w2k 4w6b2k 10w2k 10b2k"
_hr_flag_usa="4b6r2k 4b6w2k 10r2k 10w2k"

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
	local colors=$1
	if [[ $colors =~ ^[0-9]+$ ]]; then
		echo $colors
		return
	fi
	local expanded_colors=""
	local num=""
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
		if [[ $color =~ ^[0-9]+$ ]]; then
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
