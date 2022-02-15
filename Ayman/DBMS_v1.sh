#!/user/bin/bash

function createtable {
	echo enter the table name
        
read tbname 
if [ -f "tbname.csv" ]
then
	echo already exist 
#if [ -z "$tbname.csv" ]
then
#	echo table name cant be null ;

  else 
       	touch $tbname.csv
	echo how many colums you want to add
	read colum_no

	for (( i=0 ; i<$colum_no ; i+=1 ))
	do
        	echo Enter  metaData of colum $((i+1))
       		 read val
       		# metadata[$i]= "${val} ,"
	done
echo creat table with  name : $tbname.csv

	
fi
}
function listtables  {

ls
}
function listtable {
	
	echo which table you want to list? " (name without .csv)"
read tb 2> /dev/null
if [ -f "$tb.csv" ]
       then
awk -F,  '{print $0}' $tb.csv
else 
	echo $tb is not a table 
fi

}
function menue {
clear 
echo chose from options "creat table" "list tables" "exit"
case $choice in
	"creat table") createtable
		;;
	"list tables") listtable 
esac 
}
 menue
