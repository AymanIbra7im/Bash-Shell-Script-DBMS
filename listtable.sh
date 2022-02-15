#!/user/bin/bash 

function listtables {
echo /--------------------------------------/
ls 
}
function listtable {
echo /-------------------------------------/
echo Enter table name to list "(without .csv)"
read tb 2> /dev/null
if [ -f "$tb.csv" ]
then
	awk -F, '{print $0}' $tb.csv
else
	echo there is no table called $tb
fi

}
listtable 
