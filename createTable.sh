#!/usr/bin/bash
clear
title=$(kdialog --title "Table Name" --inputbox "What is the name of your Table?") 
if [ -z "$title" ];then 
        
    
        . ./main.sh 
fi

if [[ $title == *['!''?'@\#\$%^\&*()-+\.\/';']* ]]
then
kdialog --sorry "! @ # $ % ^ () ? + ; . - are not allowed!"
. ./main.sh 
break

fi

if [ -z "$title" ];then 
        
        . ./main.sh 
        break
fi
if [[ $title = *" "* ]]; then
kdialog --sorry "spaces are not allowed!"
. ./main.sh 
break
fi 
echo "$title" > out



for choice in $(cat out) ;do
echo "$choice"
if [ -f dbs/"$connectDbName"/$choice ];then
kdialog --sorry "Table Name Already exists"
exit
    else
    touch dbs/"$connectDbName"/$choice
fi


done

continueFlag=0 
tableName=`cat out` 
input=$(kdialog --title "Number of Table Fields" --inputbox "Please Enter the number of fields") 
if [ -z "$input" ];then 
        
        rm  dbs/"$connectDbName"/"$tableName" 
       
         . ./main.sh
         break
fi
            
type=`checkDataType int $input ` 
 while [ $type = "false" ];do
                echo "in while condition"
				input=$(kdialog --title "Number of Table Fields" --inputbox "Please Enter the number of fields")
                if [ -z "$input" ];then 
                     
                     rm  dbs/"$connectDbName"/"$tableName" 
                    . ./main.sh
                    break
                fi
				type=`checkDataType int $input`
   
                   
                
    done



 for ((i=0;i<"$input";i++)) ; do
    number=$(( $i+1 ))
    name=$(kdialog --title "Field Names" --inputbox "Please Enter the $number field name")
    isUnique=$(awk -F',' -v id="$name" '{if($1==id) print}' dbs/$connectDbName/"$tableName.types")
    echo "$isUnique"
    
    if [ -z "$name" ];then 
        
        rm  dbs/"$connectDbName"/"$tableName" 
        if [ -f dbs/"$connectDbName"/"$tableName.types"  ];then 
            rm dbs/"$connectDbName"/"$tableName.types"
        fi
         . ./main.sh
         break
    fi
    exitFlag=0
    while [ $exitFlag -eq 0 ];do

        if [ -z $isUnique ];then
    
            exitFlag=1
            
        else
      
            kdialog --sorry "Please Enter a unique Field Name"
            name=$(kdialog --title "Field Names" --inputbox "Please Enter the $number field name")
            if [ -z "$name" ];then 
               
                rm  dbs/"$connectDbName"/"$tableName" 
                if [ -f dbs/"$connectDbName"/"$tableName.types"  ];then 
                    rm dbs/"$connectDbName"/"$tableName.types"
                fi
                exit 
             
            fi
            isUnique=$(awk -F',' -v id="$name" '{if($1==id) print}' dbs/$connectDbName/"$tableName.types")
        fi
    done

   
    type=$(kdialog --title "Field Types" --inputbox "Please Enter the $number field int or str")
    
      if [ -z "$type" ];then 
      
        rm  dbs/"$connectDbName"/"$tableName" 
         if [ -f dbs/"$connectDbName"/"$tableName.types"  ];then 
            rm dbs/"$connectDbName"/"$tableName.types"
        fi 
        #exit
         . ./main.sh
         break
    fi
    case "$type" in
    "str")  echo "$name,$type" >>dbs/"$connectDbName"/"$tableName.types";;
    "int") echo "$name,$type" >>dbs/"$connectDbName"/"$tableName.types";;
      
    *) 
    kdialog --sorry "Please Enter a valid data type";
    rm dbs/"$connectDbName"/"$tableName";
    continueFlag=1; 
    break;
    ;;
    esac
    
    done
if [ $continueFlag -eq 0 ];then
    pk=$(kdialog --title "Field Names" --inputbox "Please Enter the Primary key")
  
    awk -F, '{print $1};' dbs/"$connectDbName"/"$tableName.types">>keys
    flag=1
    while [ $flag -eq 1 ] ;do
    if grep -Fxq "$pk" keys
    then
    
        key=$(awk /$pk/ dbs/"$connectDbName"/"$tableName.types") 
        sed -i "1 i\\$key" dbs/"$connectDbName"/"$tableName.types"
        line=$(awk -F',' -v pk="$pk" '{if($1==pk) print NR}' dbs/"$connectDbName"/"$tableName.types" | tail -1)
        sed -i "$line d" dbs/"$connectDbName"/"$tableName.types"  
        sed -i "1 i\pk,$pk" dbs/"$connectDbName"/"$tableName.types"
       
        
        flag=0
    else
       
        kdialog --sorry "Please Enter a valid key name"
        pk=$(kdialog --title "Field Names" --inputbox "Please Enter the Primary key")
    fi
    done
fi
if [ -f keys ];then
    rm keys
fi
