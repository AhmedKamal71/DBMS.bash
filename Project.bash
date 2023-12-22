#!/bin/bash

mkdir DBMS 2>> ./.error.log
echo "Welcom To Our Database Ahmed!"

MainMenu() { 		 # Print Main Menu To User Once We Run The Script.

	echo "1) Create Database."
	echo "2) List Databases."
	echo "3) Connect To Database."
	echo "4) Drop Ddatabase."
	echo "5) Exit"

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


T_menu(){                  # Print Table Menu Once We Connect To Database


	echo "1) Create Table."
	echo "2) List Tables."
	echo "3) Drop Table"
	echo "4) Insert Into Table."
	echo "5) Select From Table."
	echo "6) Delete From Table."
	echo "7) Update Table."
	echo "8) Back To Main Menu"
	echo "9) Exit"

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
		8) MainMenu
			;;
		9) exit
			;;
		*) echo "Invalid Choice, Please Enter Other Choice! " ;T_menu;
	esac 




}


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


listDB() {

	echo -e "There Are All Databases In Our System: \c"
	ls /home/ahmed/DBMS
	MainMenu

}



connectDB() {

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
		read choice
	fi

}






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
				echo "Is This field a primary key? "
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



		touch .$Tname
		echo -e $data >> .$Tname
		touch $Tname
		echo "-----------------------------------" >>$Tname
		echo -e $temp >> $Tname
		echo "-----------------------------------" >>$Tname
		if [[ $? == 0 ]]; then
			echo "Table Created Succesfully!"
			T_menu
		else
			echo "Failed To Create $Tname Table"
			T_menu
		fi

	T_menu
}




listTb(){


	current=$(pwd)
	ls $current
	T_menu

}





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
			
			echo "Table $tName's Fields are: $fName with $fType data type"

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
					if [[ $input =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tName`]$ ]]; then
						echo "Invalid Primary Key "
					else
						break;
					fi
					read input
				done
			fi
			if [[ $i == fNum ]]; then
				row=$row$input
			else
				row=$row$input$fSp
			fi
		done
		echo -e $row"\n" >> $tName
		echo "-----------------------------------" >> $tName
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




updateTb(){


	echo "Enter The Name OF Table To Update: "
	read tName
	if [ -f $tName ]; then
		echo "Enter The Name of The Field To Update in: "
		read old_fInput
		old_field_index=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$old_fInput'") print i}}}' $tName)
		if [[ $old_field_index == "" ]]; then
			echo "This Field Doesn't Exist"
			T_menu
		else
			echo "Enter the value you want to update: "
			read old_vInput
			oldV_field=$(awk 'BEGIN{FS="|"}{if ($'$old_field_index'=="'$old_vInput'") print $'$old_field_index'}' $tName 2>>./.error.log)
			if [[ $oldV_field == "" ]]; then
				echo "This Value Doesn't Exist!!"
				T_menu
			else
				echo "Enter The Name Of The New Value's Field: "
				read new_fInput
				new_field_index=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$new_fInput'") print i}}}' $tName)
				if [[ $new_field_index == "" ]]; then
					echo "This Field Doesn't Exist!!"
					T_menu
				else
					echo "Enter The New Value: "
					read new_vInput
					row_index=$(awk 'BEGIN{FS="|"}{if ($'$old_field_index'=="'$old_vInput'") print NR}' $tName 2>>./.error.log)
					old_value=$(awk 'BEGIN{FS="|"}{if(NR=='$row_index'){for(i=1;i<=NF;i++){if(i=='$new_field_index') print $i}}}' $tName 2>>./.error.log)									   echo $old_value
					sed -i ''$row_index's/'$old_value'/'$new_vInput'/g' $tName 2>>./.error.log
					echo "Value Updated Successfully!"
					T_menu
				fi
			fi
		fi
	else
		echo "This Table Doesn't Exist!!"
	fi

}



MainMenu





























