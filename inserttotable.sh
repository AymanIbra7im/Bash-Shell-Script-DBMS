#!/user/bin/bashi
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
}
inserttotable
