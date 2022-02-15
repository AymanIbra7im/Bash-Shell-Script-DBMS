#!/user/bin/bash
#########################################################
mkdir database 2> /dev/null 
cd database
#####################################################
function creattable {

echo /----------------------------------------------/

echo Enter table name "(without .csv)"

read tbname 
if [ -f "$tbname.csv" ]
then
       echo already exist 
elif [ -z "$tbname.csv" ]
then echo table name is empty 

else 
touch $tbname.csv
echo Enter the number of colums in the table 

read coloum_n
for (( i=0 ; i<$coloum_n ; i+=1 ))
do 
	echo Enter coloum $((i+1)) name 
	read cname
        coloum[$i]="${cname} ," # >>$tbname.csv
done 
echo table name is $tbname.csv
echo num of coloum = $coloum_n
echo coloum names are ${coloum[*]}
echo ${coloum[*]} >>$tbname.csv

fi
connecttoDB
}
##########################################################
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
connecttoDB
}
########################################################
function inserttotable {
echo /------------------------------------/
echo Enter table name to insert into "(without .csv)"
read tb 
if [ -f "$tb.csv" ]
then
	colom_n=`awk -F, 'END {print NF}' $tb.csv`
	echo Enter the number of rows 
	read rows_n
	for (( i=0; i<$rows_n ; i+=1 ))
	do
		for (( j=0; j<$colom_n-1 ; j+=1 ))
		do 
			if [[ j -eq 0 ]]
			then
				echo Enter primary key in the first coloum
				echo Enter data in coloum $((j+1))
				typeset -i pk
				typeset -i ch 
				while [ true ]
				do 
					read pk 
					case $pk in
						*[0-9]*)
							ch=-1   
							ch=`awk -F, '{if ($1=='$pk'){ print $1 }}' $tb.csv`
							echo $ch 
							echo $pk
							if test $ch -ne $pk 
							then 
								data[$j]="${pk} ,"
							      
							       	break
						        else echo ERROR primary key must be unique 
							fi
							;;
						*) echo ERROR Enter only numbers for primary key 
							;;
					esac
				done 
			else echo Enter data in coloum $((j+1))
			read dt 
			data[$j]="${dt} ,"
			fi
		done 
	echo ${data[*]} >> $tb.csv
	done
	if [[ $?==0 ]]
	then
	echo data added succesfully 
	else echo faild to add data
	fi
else echo there is no table called $tb
fi 
connecttoDB	
}
##################################################
function selectfromtable {
	echo *_______________________________________________________________*
	echo which table you want to select from ?"(only name without .csv)"
read tb
if [ -f "$tb.csv" ]
       then

echo which row do you want? please enter primary key of this table
read row
clear
echo your selection is:
echo *_______________________________________________________________*
awk -F, '{{if(($1=='$row')){print $0 }}}' $tb.csv
echo *_______________________________________________________________*
else 
	echo $tb not a table 2> /dev/null
fi
connecttoDB
}
###################################################
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
connecttoDB
}
####################################
function droptables {
	echo /-----------------------------------------------------/
	echo which table you want to drop?"(only name without .csv)"
read tb
if [ -f "$tb.csv" ]
       then

rm $tb.csv
else
	echo $tb not a table 2> /dev/null
fi

}
######################################################################
function createDB(){
tput bold 
printf "Would You Write The Name Of Your Database:"
tput sgr0

read dbname
echo "$dbname"
#check if DB (directory Exist or not)
#cd ./database 
# I use -w in grep to search in the exact name
if ls|grep -w "$dbname";
then
	echo the db exist
fi
if  !(ls | grep -w "$dbname");
then
	mkdir -p $dbname
	echo Done
fi
cd ..
}
####################################################################
function listDB(){
tput bold
tput setaf 4
echo "All Databases Thar Esixt: "
tput sgr0

ls ./DB
}
###################################################################
function whichdb {
	echo *_______________________________________________________________*
echo which database you want to connect to?
read 
if [ -d $REPLY ]
then cd $REPLY
	connecttoDB
else 2> /dev/null
echo not a database, please insert a valid database! 
#menu
fi
}
####################################################################
function connectDB {
	echo *_______________________________________________________________*
        echo menu:
        PS3="your choice is:"
	
select table in "Create table" "List tables"  "List specified table" "Drop tables" "Insert into table" "Select from table" "Delete from table" "back to main menu"
do
        case $table in
                "Create table") creattable 
                        ;;
                "List tables") listtables
                        ;;
		"List specified table")listtable
			;;
                "Drop tables")droptables
                        ;;
                "Insert into table")inserttotable
                        ;;
                "Select from table")selectfromtable
                        ;;
                "Delete from table")deletefromtable
                        ;;
                "back to main menu")cd ..
			menu
                        ;;
                *)echo not valid coice
                        ;;
 esac
done

}
####################################################################
##check this function ###
function connectDB1(){
#simply enter the directory (DB)
printf "Enter Batabase Name to connect:\t"
read $dbname
echo
ls
if ls|grep -w "$dbname";
then
cd ./DB/"$dbms"
touch file
fi
echo
ls
cd ..
echo
ls
}
##################################################################
function dropDB(){
#just remove the directory if exist
printf "Would You Write The Database's Name: "
read dbname
cd ./DB
rm -dr $dbname
cd ..
}
#######################################################################
echo main menu:
PS3="your choise is:"
function menu {
	clear
	echo *_______________________________________________________________*
	echo main menu:
select choice in "Create DataBase" "List DataBases" "Connect To DataBase" "Drop DataBase" "exit" 
do
	echo *_______________________________________________________________*
	case $choice in
		"Create DataBase")  createDB
			;;
		"List DataBases") listDB
			;;
		"Connect To DataBase") connectDB
			;;
		"Drop DataBase") dropDB
                        ;;
		"exit") exit
			;;
		*)echo not valid choice
			;;
	esac
	
done
}
menu