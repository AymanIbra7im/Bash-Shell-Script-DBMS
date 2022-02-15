#!/user/bin/bash

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

}
creattable 
