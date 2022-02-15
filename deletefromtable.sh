#!/user/bin/bash
function deletefromtable {

echo /----------------------------------------------/
echo Enter table name "without .csv()"
read tb
if [ -f "$tb.csv" ]
then 
	echo Enter primary key of the record 
	read pk
	row=`awk -F, '{if($1=='$pk'){print NR}}' $tb.csv`
	#echo $row 
	sed -i ''$row'd' $tb.csv
	echo line $row deleted 
else
	echo there is no table called $tb 
fi
}
deletefromtable
