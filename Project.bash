#!/bin/bash

mkdir DBMS 2>> ./.error.log
echo "Welcom To Our Database Ahmed!"

#----------------------------------------------------------- Main Menu ----------------------------------------------------------------------------------

MainMenu() {	# Print Main Menu To User Once We Run The Script.
        
	
	echo " _______________________________"
        echo "|           Main Menu           |"
	echo "|_______________________________|"
	echo "|1) Create Database.            |"
	echo "|2) List Databases.             |"            
	echo "|3) Connect To Database.        |"
	echo "|4) Drop Ddatabase.             |"
	echo "|5) Exit                        |"
	echo "|_______________________________| "
	echo "Please Enter Your Choice: "
	read choice
	case $choice in
		1) createDB
			;;
		2) listDB
			;;
		3) connectDB
			;;
		4) dropDB
			;;
		5) exit
			;;
		*) echo "Invalid Choice, Please enter other choice! " ; MainMenu;	
	esac 
}

#---------------------------------------------------------------- Table Menu -----------------------------------------------------------------------------

T_menu(){                  # Print Table Menu Once We Connect To Database

	echo " _______________________________"
	echo "|          Table Menu           |"
	echo "|_______________________________|"
	echo "|1) Create Table.               |"
	echo "|2) List Tables.                |"
	echo "|3) Drop Table                  |"
	echo "|4) Insert Into Table.          |"
	echo "|5) Select From Table.          |"
	echo "|6) Delete From Table.          |"
	echo "|7) Update Table.               |"
	echo "|8) View Table.                 |"
	echo "|9) Back To Main Menu           |"
	echo "|10) Exit                       |"
	echo "|_______________________________|"

	echo "Please Enter Your Choice: "
	read choice
	case $choice in 
		1) createTb
			;;
		2) listTb
			;;
		3) dropTb
			;;
		4) insertTb
			;;
		5) selFromTb
			;;
		6) delFromTb
			;;
		7) updateTb
			;;
		8) viewTb
			;;
		9) MainMenu
			;;
		10) exit
			;;
		*) echo "Invalid Choice, Please Enter Other Choice! " ;T_menu;
	esac 

}


#------------------------------------------------------------- Create Database -------------------------------------------------------------------------------------

createDB() {

	echo "Please, Enter The Name Of DB: "
	read choice
	if [ -d "/home/ahmed/DBMS/$choice" ]; then  # check if the DB's name is exist or not
		echo "The DB's name is already exist, please choose another name."
	else
		mkdir /home/ahmed/DBMS/$choice
		if [[ $? == 0 ]]; then
		       echo "Successfully Creation"
	       else
		       echo "Failed To Create DB!!"
		fi
	fi
	
	MainMenu
}

#------------------------------------------------------------ List All Databases -----------------------------------------------------------------------------------

listDB() {

	echo -e "There Are All Databases In Our System: \c"
	ls /home/ahmed/DBMS
	MainMenu

}


#------------------------------------------------------------ Connect To Specific DataBase ----------------------------------------------------------------------------

connectDB(){

	echo "Please, Enter The name Of DB To Connect It: "
	read choice
	if [ -d "/home/ahmed/DBMS/$choice" ]; then
		cd /home/ahmed/DBMS/$choice
		if [[ $? == 0 ]]; then
			clear
			echo "Connected Successfully To $choice DB"
			T_menu
		else
			echo "Failed To Connect"

		fi
	else
		echo "Database Doesn't Exist, Try Again! "
		MainMenu
	fi

}

#-------------------------------------------------------- Drop Specific Database ----------------------------------------------------------------------------------

dropDB() {

	echo "Please, Enter DB's Name To Drop: "
	read choice
	if [ -d "/home/ahmed/DBMS/$choice" ]; then
		rm -r /home/ahmed/DBMS/$choice
		if [[ $? == 0 ]]; then
			echo "Database Dropped Successfully!"
		else
			echo "Failed To Drop Database"
		fi
	else
		echo "This Database Doesn't Exist"
	fi
	MainMenu
}


#-------------------------------------------------------------- Create Table --------------------------------------------------------------------

createTb(){

	echo "Please Enter The Name Of The Table: "
	read Tname
	Cdb=$(pwd)
	if [ -f "$Cdb/$Tname" ]; then
		echo "Table $Tname is already exist, try again!"
		T_menu
	fi
		echo "Enter the number of fields: "
		read fNum
		fSp="|"
		rSp="\n"
		pKey=""
		count=1
		dl=":"
		data="Field"$fSp"Type"$fSp"PK"

		while [ $count -le $fNum ] 
		do
			echo -e "Please, Enter the name of field number $count "
			read fName
			echo "Choose the data type of the field: "
			echo "1) Integer."
			echo "2) String."
			read ch
			case $ch in
				1) fType="int"
					;;
				2) fType="str"
					;;
			esac
			if [[ $pKey == "" ]]; then
				echo "Choose This field as a primary key? "
				echo "1) Yes"
				echo "2) No"
				read prim
				case $prim in
				 	1) pKey="PK"; 		
				 	data+=$rSp$fName$fSp$fType$fSp$pKey;
				 		;;
				 	2) data+=$rSp$fName$fSp$fType$fSp"";
						;;
			 	esac
			else
				data+=$rSp$fName$fSp$fType$fSp""
			fi
			if [[ $count == $fNum ]]; then
				temp=$temp$fName
			else
				temp=$temp$fName$fSp

			fi
			((count++))
		done
		touch .$Tname             # Create a hidden file to put each field and data type in it
		echo -e $data >> .$Tname
		touch $Tname
		echo "-------------------------------------|"  >>$Tname
		echo -e $temp >> $Tname
		echo "-------------------------------------|"  >>$Tname
		if [[ $? == 0 ]]; then
			echo "Table Created Succesfully!"
			T_menu
		else
			echo "Failed To Create $Tname Table"
			T_menu
		fi
	T_menu
}


#------------------------------------------------------------------- View Table Content ------------------------------------------------------------------------ 

viewTb(){

        echo "Enter Table's Name To View: "
        read tName
        if [ -f $tName ]; then
                curr=$(pwd)
                cat $curr/$tName
                T_menu
        else
                echo "$tName Is Not Exist!"
                T_menu
        fi
}


#------------------------------------------------------------------- List All Tables In Specific Database --------------------------------------------------------


listTb(){

	current=$(pwd)
	ls $current
	T_menu
}


#------------------------------------------------------------------- Drop Table -----------------------------------------------------------------------------------


dropTb(){

	echo "Please, Enter the name of table to delete: "
	read dTable
	current=$(pwd)
	if [ -f "$dTable" ]; then
		rm $current/$dTable
		if [[ $? == 0 ]]; then
			echo "Table $dTable Successfully deleted!"
		else
			echo "failed to delete this table"
		fi
	else
		echo "There's not a table with this name"
	fi
	T_menu
}


#----------------------------------------------------------------- Insert Into Table ------------------------------------------------------------------------------


insertTb(){

	echo "Enter the name of table to insert in: "
	read tName
	if [ -f $tName ]; then
		echo "Welcome to $tName table!"
		fSp="|"
		rSp="\n"
		fNum=$(wc -l < .$tName)
		for (( i=2; i<= $fNum; i++)); do
			fName=$(cut -d '|' -f1 < .$tName | sed -n "${i}p")
			fType=$(cut -d '|' -f2 < .$tName | sed -n "${i}p")
			pKey=$(cut -d '|' -f3 < .$tName | sed -n "${i}p")
			
			echo "Enter $fName with |$fType| data type: "
			read input
			
			if [[ $fType == "int" ]]; then
				while ! [[ $input =~ ^[0-9]*$ ]]; do
					echo "Data Type Doesn't Match This input"
					read input
				done

			elif [[ $fType == "str" ]]; then
				while ! [[ $input =~ ^[a-zA-Z]+$ ]]; do
					echo "Invalid Data Type"
					read input
				done
			fi

			if [[ $pKey == "PK" ]]; then
				while [[ true ]]; do
					if [[ $input =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tName`]$ ]]; then      # Check For Existing PK
						echo "Invalid Primary Key "
					else
						break;
					fi
					read input
				done
			fi
			if [[ $i == $fNum ]]; then
				row=$row$input$rSp
			else
				row=$row$input$fSp
			fi
		done
		echo -e $row"\c" >> $tName
		echo "-------------------------------------|"  >> $tName
		if [[ $? == 0 ]]; then
			echo "Data Inserted Successfully"
		else
			echo "error inserting"
		fi
	else
		echo "Sory, Table $tName isn't exist !!"
	fi
	row=""               
	T_menu
}


#------------------------------------------------------------------------------ Update Table ----------------------------------------------------------------


updateTb(){

  echo -e "Enter The Name Of The Table To Update In:  "
  read tName
  if [ -f $tName ]; then
  	echo "Enter the name of the PK field: "
  	read key_field
  	fid=$(awk 'BEGIN{FS="|"}{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$key_field'") print i}}}' $tName)     # Get The PK Field's Index
  	if [[ $fid == "" ]]; then
    		echo "This $key_field'name doesn't exist, please enter an other name"
    		T_menu
  	else
    		echo "Enter The Value To Use As A Key To Update With: "
    		read val
    		res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tName 2>>./.error.log)       # Get The Primary Key
    		if [[ $res == "" ]]; then
      			echo "Value Not Found!"
			T_menu
    		else
      			echo "Enter The Field To Update In: "
      			read target_field
      			setFid=$(awk 'BEGIN{FS="|"}{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$target_field'") print i}}}' $tName)    # Get The Index Of Field We Want To Update In
      			if [[ $setFid == "" ]]; then
        			echo "$target_field's Name Not Found!!"
        			T_menu
      			else
        			echo "Enter The new Value: "
        			read newValue
        			NR=$(awk 'BEGIN{FS="|"}{if ($'$fid' == "'$val'") print NR}' $tName 2>>./.error.log)               # Get Number Of The Row In Which The Old Value
        			oldValue=$(awk 'BEGIN{FS="|"}{if(NR=='$NR'){for(i=1;i<=NF;i++){if(i=='$setFid') print $i}}}' $tName 2>>./.error.log)   # Get The Old Value
        			sed -i ''$NR's/'$oldValue'/'$newValue'/g' $tName 2>>./.error.log        # Replce Old Value With New Value
				if [[ $? == 0 ]]; then
        				echo "Row Updated Successfully"
        				T_menu
				fi
			fi

		fi
	fi

else
	echo "No Such A Table With $tName'name"
  fi
}


#------------------------------------------------------------------------ Delete From Table -------------------------------------------------------------------


delFromTb() {
  echo "Enter Table Name To Delete From It: "
  read tName
  if [ -f $tName ]; then
  	echo "Enter The Key Field To Use With Deleting: "
	read key_field
  	f_index=$(awk 'BEGIN{FS="|"}{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$key_field'") print i}}}' $tName)
  	if [[ $f_index == "" ]]; then
    		echo "Not Found"
		T_menu
  	else
    		echo "Enter Value To Delete Its Row: "
    		read val
    		res=$(awk 'BEGIN{FS="|"}{if ($'$f_index'=="'$val'") print $'$f_index'}' $tName 2>>./.error.log)
    		if [[ $res == "" ]]; then
			echo "Value Not Found"
      			T_menu
    		else
      			NR=$(awk 'BEGIN{FS="|"}{if ($'$f_index'=="'$val'") print NR}' $tName 2>>./.error.log)
      			sed -i ''$NR'd' $tName 2>>./.error.log
			if [[ $? == 0 ]]; then
      				echo "Row Deleted Successfully"
				T_menu
			else
				echo "Failed To Delete!"
				T_menu
			fi   
		fi
	fi
 else
	echo "No Such A Table With This Name!"
	T_menu
 fi
}


#--------------------------------------------------------------------- Select From Table -----------------------------------------------------------------------



selFromTb(){

  echo "Enter Table Name To Select From It: "
  read tName
  if [ -f $tName ]; then
        echo "Enter The Key Field To Use With Selecting: "
        read key_field
        f_index=$(awk 'BEGIN{FS="|"}{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$key_field'") print i}}}' $tName)     # Get The Index Of The Key Field To Use It In Selecting Row
        if [[ $f_index == "" ]]; then
                echo "Not Found"
                T_menu
        else
                echo "Enter Value To Select Its Row: "
                read val
                res=$(awk 'BEGIN{FS="|"}{if ($'$f_index'=="'$val'") print $'$f_index'}' $tName 2>>./.error.log)    # Check if the value in the selected field
                if [[ $res == "" ]]; then
                        echo "Value Not Found"
                        T_menu
                else
                        NR=$(awk 'BEGIN{FS="|"}{if ($'$f_index'=="'$val'") print NR}' $tName 2>>./.error.log)       # Get Row Number Of The Key Value
                        awk -F'|' -v nr="$NR" 'NR == nr {print}' "$tName" 2>>./.error.log                           # Print The Whole Row
                        if [[ $? == 0 ]]; then
                                echo "Row Selected Successfully"
                                T_menu
                        else
                                echo "Failed To Select!"
                                T_menu
                        fi   
                fi
        fi
 else
        echo "No Such A Table With This Name!"
        T_menu
 fi
}


MainMenu  
