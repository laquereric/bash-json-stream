INNER_DATA=$(cat <<EOF
name	BASENAME-Server
database	BASENAME-Database
EOF
)
line_1="name\tBASENAME-Server"
#echo `echo $line_1 | cut -f 2`
echo -e $line_1 |tr '\t' ' ' |cut -d' ' -f2