#!/bin/bash
paral=`command -v parallel`
win=`command -v vina`
grid=`command -v autogrid4`
dock=`command -v autodock4`
MGLROOT=`command -v vina|sed s/"\/bin\/vina"//g`
mgroot=`command -v "$MGLROOT"/bin/pythonsh`
prepare_gpf=`command -v "$MGLROOT"/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py`
prepare_dpf=`command -v "$MGLROOT"/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_dpf42.py`
if [ -n "$win" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:Vina was not found\n~~~~~~~~~~~Please Install Vina~~~~~~~~~~~~~~~~~\n\n[Ensure global installation of VINA- check manually by typing vina in the terminal](preferred file location to call globally/usr/local/bin)\n"
	exit
fi
if [ -n "$mgroot" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:MGLROOT directory was not found\n~~~~~~~~~~~Please Install MGLTools and set the path to the installed directory~~~~~~~~~~~~~~~~~\n\n[Ensure global installation of MGL tools check manually by typing $MGLROOT in the terminal]\n"
	exit
fi
if [ -n "$prepare_gpf" ] && [ -n "$prepare_dpf" ]
then
	PYCONFIG=""$MGLROOT"/MGLToolsPckgs/AutoDockTools/Utilities24/"
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:preapre_gpf4.py and prepare_dpf42.py was not found inside MGLROOT directory\n~~~~~~~~~~~Please make sure the availability ofprepare_dpf42.py script in this directory "$MGLROOT"/MGLToolsPckgs/AutoDockTools/Utilities24/\n"
	exit
fi
if [ -n "$grid" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:Autogrid4 was not found\n~~~~~~~~~~~Please Install Autodock tools~~~~~~~~~~~~~~~~~\n\n[Ensure autogrid installation globally by calling it in the terminal](Preferred File location to call globally/usr/local/bin)\n"
	exit
fi
if [ -n "$dock" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:Autodock4 was not found\n~~~~~~~~~~~Please Install Autodock tools~~~~~~~~~~~~~~~~~\n\n[Ensure autodock installation globally by calling it in the terminal](File location to call globally/usr/local/bin)\n"
	exit
fi
if [ -n "$paral" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:GNU parallel was not found\n~~~~~~~~~~~Please Install GNU Parallel~~~~~~~~~~~~~~~~~\n\n[Ensure it should globally call when tried in terminal](File location to call globally/usr/local/bin)\n"
	exit
fi
clear
if [ "$#" == 0 ]
then
	echo -e "Termination! Error in starting the script\nUse -s for interactive mode or try other flags\nTry again!!"
	exit
else
	while [ "$#" -ge 1 ]
	do
		arg="$1"
		case "$arg" 
		in
			-s|--s) 
				echo -e "
           +++++++++++++++++++++++++++++++++++++++++++
          ++   ######   ######   ######   ######   ++  
         ++   #    #   #    #   #    #   #    #   ++
        ++   ######   #    #   ######   ######   ++
       ++   #        #    #   #    #   #        ++
      ++   #        ######   #    #   #        ++
     +++++++++++++++++++++++++++++++++++++++++++

POAP-Parallelized Openbabael and Autodock suite Pipeline 
POAP can be used to optimize the ligands and run virtual screnning in parallel.
Copyright (C) 2017  Samdani.A & Dr.V.Umashankar
From: Center for Bioinformatics, Vision Research Foundation, Sankara Nethralaya
and Sastra University,Thanjavur.

This program is free software and distributed under the terms of the 
GNU General Public License.

If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012

POAP - Virtual screening Module:
--------------------------------\n"
				echo -e "Enter option \n[1] To perform VS with Autodock Vina\n[2] To perform Multiple Protein docking with Autodock Vina\n[3] To perform VS with Autodock\n[4] To perform Multiple protein docking with Autodock\n[5] To perform VS with AutodockZn\n[6] To perform Multiple protein docking with AutodockZn"
		  	        iii=1
		        	while [ "$iii" -ge 0 ]
	   			do
					read -p ">>>" opt
					if [ "$opt" == 1 ] || [ "$opt" == 2 ] || [ "$opt" == 3 ] || [ "$opt" == 4 ] || [ "$opt" == 5 ] || [ "$opt" == 6 ]
					then
						break 2
					else
						echo -e "Error: Wrong input given. Please type again "
						iii=`expr "$iii" + 1`
					fi
	   			done
				skip=0
				;;
			-h|--h) 
				more <<EOF
		    +++++++++++++++++++++++++++++++++++++++++++
	           ++   ######   ######   ######   ######   ++  
                  ++   #    #   #    #   #    #   #    #   ++
	         ++   ######   #    #   ######   ######   ++
	        ++   #        #    #   #    #   #        ++
	       ++   #        ######   #    #   #        ++
	      +++++++++++++++++++++++++++++++++++++++++++
-s, -s  For Interactive mode
-h, -help  To print help file
-l, -ligand  To specify ligand directory
	For example [script -l /home/bioinfo/ligands/]
-r, -receptor  To specify receptor directory 
        For example [script -r /home/bioinfo/receptor/]
-w, -work  To specify receptor directory 
        For example [script -w /home/bioinfo/working/]
-vv, -vsvina  To perform Virtual screening using Autodock Vina
	For example [script -vv]
-mv, -mdvina  To perform Multiple protein docking using Autodock Vina
	For example [script -mv]
-va, -vsad  To perform Virtual screening using Autodock
	For example [script -va ]
-ma, -mdad  To perform Multiple protein docking using Autodock
	For example [script -ma]
-vz, -vsaz  To perform Virtual screening using AutodockZn
	For example [script -vz] 
-mz, -mdaz  To perform Multiple protein docking using AutodockZn
-x, -ex  Vina Exhaustiveness(default=8)
-t, -top  To select number of top protein-ligand complex
-at,-atom  To provide Ligand atom types for autodock and autodockZn
	Ex: -at A,OA,HD,CL,HD,NA
	If to calculate the atom types from the ligand database provide 2
	Ex: -at 2
-j, -Jobs  To specify number of jobs to run in parallel
	[Note: For vina -j represent number of CPU threads to use to run
	       single VINA job]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~End of Help File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF
				exit
				;;
			-a|-atm)
				atm="$2"
				shift
				;;
			-l|-ligand)
				lig="$2"
				if [ -d "$lig" ] 
				then
					spacecheck=`echo "$lig" | sed -n "/\s/p"`
					if [ -n "$spacecheck" ]
					then
						echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
						exit
					fi 
				else
					echo -e "Directory not found."
					exit			
				fi 
				LIGAND=`echo "$lig" | sed "s/\/$//"`
				#ligand directory check
				skip="YES"
				shift
				;;
			-w|-work)
				vin="$2"
				if [ -d "$vin" ] 
				then
					spacecheck=`echo "$vin" | sed -n "/\s/p"`
					if [ -n "$spacecheck" ]
					then
						echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
						exit
					fi 
				else
					echo -e "Directory not found." 
					exit
				fi
				skip="YES"
				VINA=`echo "$vin" | sed "s/\/$//"`
				cd "$VINA"
   				worktest=`ls`
   				if [ -n "$worktest" ]
   				then
					echo -e ""$VINA" is not an empty directory"
					exit
   				else 
					:
   				fi
				shift
				;;
			-r|-receptor)
				config="$2"
				if [ -d "$config" ] 
				then 
					spacecheck=`echo "$config" | sed -n "/\s/p"`
					if [ -n "$spacecheck" ]
					then
						echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
						exit
					fi
				else
					echo -e "Directory not found." 
					exit
				fi 
				CONFIG=`echo "$config" | sed "s/\/$//"
				skip="YES"`
				shift
				;;
			-at|-atom)
				atm="$2"
				att="YES"
				skip="YES"
				shift
				;;
			-vv|-vsvina)
				opt=1
				ozt="Virtual screening with Autodock Vina"
				skip="YES"
				;;
			-mv|-mdvina)
				opt=2
				ozt="Multiple protein virtual screening using Autodock Vina"
				skip="YES"
				;;
			-x|-ex)
				ex="$2"
				skip="YES"
				shift
				;;
			-t|-top)
				top="$2"
				skip="YES"
				shift
				;;
			-va|-vsad)
				opt=3
				ozt="Virtual screening with Autodock"
				skip="YES"
				;;
			-ma|-mdad)
				opt=4
				ozt="Multiple protein virtual screening using Autodock"
				skip="YES"
				;;
			-vz|-vsaz)
				opt=5
				ozt="Virtual screening with AutodockZn"
				skip="YES"
				;;
			-mz|-msaz)
				opt=6
				ozt="Multiple protein virtual screening using AutodockZn"
				skip="YES"
				;;
			-j|-J)
				joobs="$2"
				skip="YES"
				shift
				;;
		
    			*)
        	  	 	echo -e "Invalid selection"
		   		echo -e "Enter -s to start the script or -h or -help for help"
				exit
    				;;
		esac
		shift   # past argument or value
	done
fi
if [ "$skip" == "YES" ]
then
	if [ "$opt" == 1 ] || [ "$opt" == 2 ] ; then if [ -z "$ex" ] ; then ex=8; fi ; fi ##User can re-edit to change the exhaustiveness (ex) value
	if [ -z "$top" ] ; then top="5" ; fi ##User can re-edit to change the number of top protein-ligand complex to be generated (top) value
	if [ "$opt" == 1 ] || [ "$opt" == 2 ] ; then if [ -n "$joobs" ] ;then numcpu="$joobs"; njob=`nproc`; joobs=`echo -e "$njob\t$numcpu" | awk '{s=$1/$2} {printf "%d", s}'`; fi ; fi
	if [ -d "$LIGAND" ]
	then
		cd "$LIGAND"
		ligtotal=`ls -1U | grep "pdbqt" | tee spacecheck.txt | wc -l`
		ligform=`cat spacecheck.txt | grep "pdbqt"`
	   	if [ -n "$ligform" ]
	   	then
			: #echo -e "pdbqt file was found inside the directory\n\n"
	   	else
			rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
	   	fi 
	fi
	if [ "$opt" == 1 ] || [ "$opt" == 2 ]
	then
		if [ "$att" == "YES" ]
		then
			echo -e "Atom types option Not needed for VINA process!\nTry again removing the respective flag"
			exit
		fi
	fi
	if [ "$opt" == 3 ] || [ "$opt" == 4 ] || [ "$opt" == 5 ] || [ "$opt" == 6 ]
	then
		if [ "$att" == "YES" ]
		then
			if [ -z "$atm" ]
			then
				echo -e "atom types option Empty"
				exit
			else
				if [ "$atm" != 2 ]
				then
					AD_atm_types=`echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ"`  
					atomty=`echo "$atm" | sed "s/,/\n/g"`
					b=`echo "$atomty" | wc -l`
					c=1
					for ff in $(echo "$atomty")
					do
						if [ "$c" -le "$b" ]
						then
							check=`echo "$AD_atm_types" | grep "$ff"`
							if [ -n "$check" ]
							then
								c=`expr $c + 1`
							else
								if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
								echo -e "Unidentified atom type found!!. Please type again "
								wrongatm="YES" 
								exit
							fi
						else
							break
						fi
					done
					atomtypes=`echo "$atm"`	
					atm=1
				fi
			fi	
		fi
	fi
	if  [ -d "$CONFIG" ]
	then
		if [ "$opt" == 1 ] 
		then
			cd "$CONFIG"
			proteinname=`ls *.pdbqt 2>/dev/null`
		   	if [ -n "$proteinname" ]
		   	then
				fspace=`ls *.pdbqt | sed -n "/\s/p"` 
				if [ -n "$fspace" ]
				then 
					bspace=`ls *.pdbqt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
				fi
		   		proteinname=`ls *.pdbqt`
		   	else
				if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
				echo -e "No protein file in .pdbqt format found inside the directory. Please Check.\n"
				exit
		   	fi
		   	configtest=`ls *.txt 2>/dev/null`
		   	if [ -n "$configtest" ]
		   	then
				fspace=`ls *.txt | sed -n "/\s/p"` 
				if [ -n "$fspace" ]
				then 
					bspace=`ls *.txt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
				fi
		   		configtest=`ls *.txt`
		   	else
				if [ -d "$LIGAND" ] ; then cd "$LIGAND"; rm spacecheck.txt; fi
				echo -e "No config.txt file found inside the directory. Please Check and save as config.txt.\n"
				exit
		   	fi
		elif [ "$opt" == 2 ]
		then
			cd "$CONFIG"
	   		###Spack check####
			ls -1U >prospacecheck.ali
			spacecheck=`sed -n "/\s/p" prospacecheck.ali`
			if [ -n "$spacecheck" ]
			then
				echo -e "~~Space detected in the receptor files~~~\nSpace will be replaced by _ in the filename"
				sed -n "/\s/p" prospacecheck.ali >spacefiles.ali
				echo -n "
				#!/bin/bash
				bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
				mv \"\$1\" \"\$bspace\"" >rename.bash
				cat prospacefiles.ali | grep "pdbqt" | parallel -j 0 --no-notice --eta bash rename.bash {}
				cat prospacefiles.ali | grep "txt" | parallel -j 0 --no-notice --eta bash rename.bash {}
				rm rename.bash spacefiles.ali
			else
				:
			fi
			rm prospacecheck.ali
			cd "$CONFIG"
			ls -1 *.pdbqt >>protein_list.txt
	   		sed -i "s/.pdbqt//g" protein_list.txt
			while read -r l
			do
				reftxt=`ls "$l".txt 2>/dev/null`
				if [ -n "$reftxt" ]
				then
					:
				else
					rm protein_list.txt
					if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
					echo -e "Configuration file not found for "$l" protein in the "$CONFIG"/\n Please Check and start the process again\n\n"
					exit
				fi
			done <protein_list.txt
		elif [ "$opt" == 4 ] || [ "$opt" == 6 ] 
		then
			cd "$CONFIG"
			ls -1 >files.txt
			dirspacecheck=`cat files.txt | sed -n "/\s/p"`
			if [ -n "$dirspacecheck" ]
			then
				sed -n "/\s/p" files.txt >spacefiles.txt
				echo -n "
				#!/bin/bash
				bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
				mv \"\$1\" \"\$bspace\"" >rename.bash
				cat spacefiles.txt | parallel -j 0 --no-notice bash rename.bash {}
				rm rename.bash spacefiles.txt
			fi
			rm files.txt
			ls -1 *.pdbqt >>protein_list.txt
	   		sed -i "s/.pdbqt//g" protein_list.txt
			while read -r l
			do
				refgpf=`ls "$l".gpf 2>/dev/null` 
				refdpf=`ls "$l".dpf 2>/dev/null` 					
				if [ -n "$refgpf" ] && [ -n "$refdpf" ]
				then
					:
				else
					cd "$CONFIG"; rm protein_list.txt
					if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
					echo -e "Reference gpf and dpf files not found for "$l" protein in the "$CONFIG"/\n Please Check and start the process again\n\n"
					exit
				fi
			done <protein_list.txt
		elif [ "$opt" == 3 ] || [ "$opt" == 5 ]
		then
			cd "$CONFIG"
	   		refgpf=`ls *.gpf 2>/dev/null`
	   		refdpf=`ls *.dpf 2>/dev/null`
	   		if [ -n "$refgpf" ] && [ -n "$refdpf" ]
	   		then	
				cd "$CONFIG"
				fspace=`ls *.gpf | sed -n "/\s/p"` 
				if [ -n "$fspace" ]
				then 
					bspace=`ls *.gpf | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
				fi
	   			refgpf=`ls *.gpf`
				fspace=`ls *.dpf | sed -n "/\s/p"` 
				if [ -n "$fspace" ]
				then 
					bspace=`ls *.dpf | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
				fi
	   			refdpf=`ls *.dpf`
	   		else
				if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
				echo -e "Reference gpf abd dpf files not found in the "$CONFIG"\n Please Check and start the process again\n\n"
				exit
	   		fi
			protcheck=`ls *.pdbqt  2>/dev/null`
	   		if [ -n "$protcheck" ]
	   		then	
				fspace=`ls *.pdbqt | sed -n "/\s/p"` 
				if [ -n "$fspace" ]
				then 
					bspace=`ls *.pdbqt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
				fi
	   			proteinname=`ls *.pdbqt`
	   		else
				if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
				echo -e "Pdbqt file for protein was not found in the "$CONFIG"\n Please Check and start the process again\n\n"
				exit
	   		fi
		fi
		if [ "$opt" == 5 ] || [ "$opt" == 6 ]
		then
			cd "$CONFIG"
			gpfname=`ls prepare_gpf4zn.py 2>/dev/null`
	   		pesudozinc=`ls zinc_pseudo.py 2>/dev/null`
	   		forcefield=`ls AD4Zn.dat 2>/dev/null`
	   		if [ -n "$gpfname" ] && [ -n "$pesudozinc" ] && [ -n "$forcefield" ]
	   		then	
				:
	   		else
				rm protein_list.txt 2>/dev/null
				if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
				echo -e "Please check prepare_gpf4zn.py,zinc_pseudo.py and AD4Zn.dat file in the "$CONFIG"\n These files were not found in the specified directory\n\n"	
				exit
   			fi
		fi
	fi
	echo -e "POAP - Virtual screening Module:"
	echo -e "==============================================================================="
	if [ -d "$LIGAND" ]; then echo " Ligand directory:"$LIGAND""; else echo " Ligand directory: *Not given* ";fi
	if [ -d "$CONFIG" ]; then echo " Protein directory:"$CONFIG" "; else echo " Protein directory: *Not given* ";fi
	if [ -d "$VINA" ]; then echo " Working directory:"$VINA""; else echo " Working directory: *Not given* ";fi
	if [ -n "$ozt" ]; then echo " Virtual screening type: "$ozt"" ; else echo " Virtual screening type: *Not given*";fi
	if [ "$opt" != 3 ] || [ "$opt" != 4 ] || [ "$opt" != 5 ] || [ "$opt" != 6 ] ; then if [ "$opt" == 1 ] || [ "$opt" == 2 ] ; then if [ -n "$ex" ] ; then echo " Exhaustiveness: "$ex"" ; else echo " Exhaustivenss: *Not given*"; fi; fi; fi
	if [ -n "$joobs" ]
	then
		if [ "$opt" == 1 ] || [ "$opt" == 2 ] 
		then 
			echo -e " Number of VINA jobs to run in parallel:"$joobs""
		elif [ "$opt" == 3 ] || [ "$opt" == 4 ]
		then 
			echo -e " Number of jobs to run Autodock in parallel:"$joobs""
		elif [ "$opt" == 5 ] || [ "$opt" == 6 ] 
		then 
			echo -e " Number of jobs to run AutodockZN in parallel:"$joobs""
		else
			echo -e " Number of jobs to run in parallel:"$joobs""
		fi
	else 
		echo -e " Number of jobs to run in parallel: *Not given*"
	fi
	if [ "$opt" == 3 ] || [ "$opt" == 4 ] || [ "$opt" == 5 ] || [ "$opt" == 6 ]
	then
		if [ "$atm" == 1 ]
		then
			echo " Ligand atom type: "$atomtypes""
		elif [ "$atm" == 2 ]
		then
			echo " Ligand atom type: To be calculated from the ligand directory"
		else 	
			echo " Ligand atom type: *Not given*"
		fi	
	fi
	echo -e " Number of top complex:"$top""
	echo -e "===============================================================================\n"
	echo -e "Enter\n[1] To accept these parameters\n[2] To exit"
	i=1
	while [ "$i" -ge 0 ]
	do
		read -ep ">>>" skippara
		if [ "$skippara" == 1 ]
		then
			break
		elif [ "$skippara" == 2 ]
		then
			if [ -d "$LIGAND" ]; then cd "$LIGAND"; rm spacecheck.txt; fi
			if [ "$opt" == 2 ] || [ "$opt" == 4 ] || [ "$opt" == 6 ]
			then
				if [ -d "$CONFIG" ]; then cd "$CONFIG"; rm protein_list.txt; fi
			fi  
			exit
		else
			echo -e "Empty return. Type again"
			i=`expr $i + 1`
		fi
	done
fi
############Ligand-Preparation software check#####################
clear
if [ "$opt" == 1 ]
then
	################################################################################################################################
   	#########################	For performing VINA based VS			      ##########################################
   	################################################################################################################################
	if [ ! -d "$LIGAND" ]
	then
   		echo -e "Enter the directory where ligands have been prepared\n"
		##Spacechecking in directory name##
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" lig 
			if [ -n "$lig" ] 
			then
				spacecheck=`echo "$lig" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		LIGAND=`echo "$lig" | sed "s/\/$//"`
   		clear
   		cd "$LIGAND"
		ligtotal=`ls -1U | grep "pdbqt" | tee spacecheck.txt | wc -l`
#		ligtotal=`expr "$ligtotal" - 1`
   		ligform=`cat spacecheck.txt | grep "pdbqt"`
   		if [ -n "$ligform" ]
   		then
			echo -e "pdbqt file was found inside the directory\n\n"
   		else
			rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
   		fi
	fi 
#   	ligtotal=`ls -1 -U | wc -l`
   	echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
	if [ ! -d "$CONFIG" ]
	then
   		echo -e "Note: Please do not enter the exhaustiveness and the protein name in the config.txt\nEnsure other parameters have been entered in the config file\n\n\n"
   		echo -e "Enter the directory containing prepared protein and configuration file\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" config 
			if [ -n "$config" ] 
			then 
				spacecheck=`echo "$config" | sed -n "/\s/p"`
			if [ -n "$spacecheck" ]
			then
				cd "$LIGAND"; rm spacecheck.txt
				echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
				exit
			fi
			break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
		CONFIG=`echo "$config" | sed "s/\/$//"`
   		clear
   		cd "$CONFIG"
		proteinname=`ls *.pdbqt  2>/dev/null`
   		if [ -n "$proteinname" ]
   		then
			fspace=`ls *.pdbqt | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.pdbqt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
   			proteinname=`ls *.pdbqt`
   		else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "No protein file in .pdbqt format found inside the directory. Please Check.\n"
			exit
   		fi
   		configtest=`ls *.txt  2>/dev/null`
   		if [ -n "$configtest" ]
   		then
			fspace=`ls *.txt | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.txt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
   			configtest=`ls *.txt`
   		else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "No config.txt file found inside the directory. Please Check and save as config.txt.\n"
			exit
   		fi
	fi
	if [ ! -d "$VINA" ]
	then
   		echo -e "Enter the working directory\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" vin 
			if [ -n "$vin" ] 
			then
				spacecheck=`echo "$vin" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
		VINA=`echo "$vin" | sed "s/\/$//"`
   		clear
   		cd "$VINA"
   		worktest=`ls`
   		if [ -n "$worktest" ]
   		then
			cd "$LIGAND"; rm spacecheck.txt
			echo -e ""$VINA" is not an empty directory"
			exit
   		else 
			:
   		fi
	fi
	if [ -z "$ex" ]
	then
   		echo -e "Enter the exhaustiveness for Autodock Vina"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -p ">>>" ex 
			if [ -n "$ex" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
	if [ -z "$joobs" ]
	then
		njob=`nproc`
		echo -e ""$njob" number of CPU processors detected in your system\n"
   		echo -e "Enter the number of CPU to be taken for running a single vina job :"
		aa=1
		while [ "$aa" -ge 0 ]
		do
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" numcpu 
				if [ -n "$numcpu" ] 
				then 
					break 
				else
					echo -e "Error: empty return. Please type again " 
					i=`expr $i + 1` 
				fi 
			done
			joobs=`echo -e "$njob\t$numcpu" | awk '{s=$1/$2} {printf "%d", s}'`
			echo -e ""$joobs" vina jobs will run in parallel\nEnter\n[1] To proceed \n[2] To change again"
			read -p ">>>" parapro
			if [ "$parapro" == 1 ]
			then
				break
			else
				echo -e "Enter the number of CPU to be taken for running a single vina job :"
				aa=`expr $aa + 1`
			fi
		done
   	clear
	fi
	if [ -z "$top" ]
	then
   		echo -e "##Enter the number of ligand complex needed to be generated after VS## \n For the top hits\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -p ">>>" top 
			if [ -n "$top" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
   	echo -e "\n-------------------------------------------------------------------------------\n---------------------------------Summary Report--------------------------------\n-------------------------------------------------------------------------------\n\n\nLigand Input Directory="$LIGAND"\nTotal number of ligands found inside the directory: "$ligtotal"\nReceptor Input Directory="$CONFIG"\nWorking directory="$VINA"\n\nPerforming VS with Autodock Vina option selected\n\nExhaustiveness kept for VS : "$ex"\nNumber of complex to be generated for top hits : "$top"\n\n" >>"$VINA"/summary.txt
   	if [ "$skip" != "YES" ]; then echo -e "Please enter return to start the virtual screening process"
   	read -p ">>>" null
   	clear
	fi
	time=`date +"%c"`; echo -e "Virtual screening screening start time: "$time"\n\n" >>"$VINA"/summary.txt
	## Space check and file renaming##
	cd "$LIGAND"
	spacecheck=`sed -n "/\s/p" spacecheck.txt`
	if [ -n "$spacecheck" ]
	then
		echo -e "~~Space detected in the ligand files~~~\nSpace will be replaced by _ in the filename"
		sed -n "/\s/p" spacecheck.txt >spacefiles.txt
		echo -n "
		#!/bin/bash
		bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
		mv \"\$1\" \"\$bspace\"" >rename.bash
		cat spacefiles.txt | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "bash rename.bash {}"
		rm rename.bash spacefiles.txt
		clear
	else
		:
	fi
	rm spacecheck.txt
	#######################################
   	cd "$VINA"
   	mkdir docked_files Results
   	cd docked_files
   	mkdir pdbqt_output pdbqt_txt
   	cp "$CONFIG"/"$proteinname" .
   	cp "$CONFIG"/"$configtest" .
	echo -n "
		#!/bin/bash
		lol=\`grep -n \"\-\-\-\-\-\+\" "$VINA"/docked_files/pdbqt_txt/\"\$1\" | cut -c1-2\`
		if [ -n \"\$lol\" ]
		then
			lol=\`expr \"\$lol\" + 1\`
			value=\`cat "$VINA"/docked_files/pdbqt_txt/\"\$1\" | sed -n \"\$lol\"p | cut -c10-20\`
		else
			value=0
		fi
		echo -e \"\${1%.txt}\t\"\$value\"\" >>"$VINA"/Results/output.txt" >feb.bash
   	cd "$LIGAND"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodock Vina  : Running...                      +"
	echo -e " + 	* Parallel Docking                : Running...                      +"
	echo -e " + 	* Results analysis                : Waiting...                      +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
	ls -1U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta " cd "$VINA"/docked_files/ ; cp "$LIGAND"/{} . ; vina --config "$configtest" --receptor "$proteinname" --ligand {} --exhaustiveness "$ex" --cpu "$numcpu" --out pdbqt_output/{} --log pdbqt_txt/{.}.txt >>"$VINA"/log_running.txt; bash feb.bash {.}.txt ; rm {}"
	clear
   	cd "$VINA"/docked_files/ ; rm "$proteinname" "$configtest" feb.bash
   	###Result Analysis###
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodock Vina  : Running...                      +"
	echo -e " + 	* Parallel Docking                : Completed                       +"
	echo -e " + 	* Results analysis                : Running...                      +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
	echo "~~~~Running Result Analysis~~~~"
   	cd "$VINA"/Results; mkdir complex
   	sort -n -k2 output.txt -o sorted.txt
   	sed -n "1,"$top"p" sorted.txt | cut -f1 | sed 's/$/.pdbqt/g' >list.txt
   	sed -n "1,"$top"p" sorted.txt >toplist.txt
   	cp list.txt "$VINA"/docked_files/pdbqt_output/; cd "$VINA"/docked_files/pdbqt_output/
   	while read -r l
   	do
		cp "$l" "$VINA"/Results/complex/ 2>/dev/null
   	done <list.txt
   	rm list.txt
   	a=0
   	###Splitting pdbqt files and removing all other files and keeping top pose ligand file alone###
   	cd "$VINA"/Results/complex/
   	for f in *.pdbqt
   	do 
		mkdir "${f%.pdbqt}"; mv "$f" ${f%.pdbqt}/; cd ${f%.pdbqt}/
		vina_split --input "$f" --ligand lig 1>/dev/null
		rm "$f"; ltest=`ls -1 lig*.pdbqt| wc -l`;if [ "$ltest" -le 9 ]; then mv lig1.pdbqt "$f"; else mv lig01.pdbqt "$f";fi; mv "$f" ../; cd .. ; rm -R ${f%.pdbqt}/
   	done
   	###converting pdbqt to pdb##
   	cd "$VINA"/Results/complex/
   	cp "$CONFIG"/*.pdbqt "$VINA"/Results/
   	for f in *.pdbqt; do cut -c-66 "$f" | sed '/ROOT/d;/ENDROOT/d;/BRANCH/d;/ENDBRANCH/d;/TORSDOF/d;s/ATOM\s\s/HETATM/g;s/<0>/LIG/g' > ${f%.pdbqt}.pdb; rm "$f"; done
   	###Removing ROOT ENDROOT BRANCH details from ligand pdb
#   	cd "$CONFIG"/ ; pro=`ls *.pdbqt`
   	cd "$VINA"/Results/; cut -c-66 "$proteinname" >${proteinname%.pdbqt}.pdb;cd complex/
   	###PDB complex generation for the best hits###
   	for f in *.pdb; do cat ../${proteinname%.pdbqt}.pdb "$f" > ${proteinname%.pdbqt}_${f%.pdb}complex.pdb; rm "$f"; done
   	cd "$VINA"/Results
   	rm ${proteinname%.pdbqt}.pdb "$proteinname"
   	cd "$VINA"/Results/
   	sed -i "1s/^/Ligand_Name \tScore\n/" sorted.txt
   	sed -i "1s/^/Ligand_Name \tScore\n/" toplist.txt 
   	cd "$VINA"/Results ; rm list.txt output.txt
	echo "The best compounds and its energy values are" >>"$VINA"/summary.txt
	cat toplist.txt >>"$VINA"/summary.txt
	cd "$VINA"; rm log_running.txt
	clear
	time=`date +"%c"`; echo -e "\n\nVirtual screening end time: "$time"\n" >>"$VINA"/summary.txt
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodock Vina  : Completed                       +"
	echo -e " + 	* Parallel Docking                : Completed                       +"
	echo -e " + 	* Results analysis                : Completed                       +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "The best compounds and its energy values are"
	cat "$VINA"/Results/toplist.txt
   	echo -e "--------------------VS have been successfully completed!!-----------------------"
   	echo -e "\nThe Results are in the directory "$VINA"/Results\n\nThe top complex file are "$VINA"/Results/complex\n\n" >>"$VINA"/summary.txt
	echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$VINA"/summary.txt
elif [ "$opt" == 2 ]
then
	############################################################################################
   	#################### Multiple Protein docking using VINA ###################################
   	############################################################################################
	if [ ! -d "$LIGAND" ]
	then
   		echo -e "Enter the directory where ligands have been prepared\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" lig 
			if [ -n "$lig" ] 
			then 
				spacecheck=`echo "$lig" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		LIGAND=`echo "$lig" | sed "s/\/$//"`
   		clear
   		cd "$LIGAND"
		ligtotal=`ls -1U | grep "pdbqt" | tee spacecheck.txt | wc -l`
		ligform=`cat spacecheck.txt | grep "pdbqt"`
   		if [ -n "$ligform" ]
   		then
			echo -e "pdbqt file was found inside the directory\n\n"
   		else
			rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
   		fi 
   		echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
	fi
	if [ ! -d "$CONFIG" ]
	then
   		echo -e "Enter the directory where protein and configuration files are saved\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" pro 
			if [ -n "$pro" ] 
			then 
				spacecheck=`echo "$pro" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then	
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		CONFIG=`echo "$pro" | sed "s/\/$//"`
		cd "$CONFIG"
	   	###Spack check####
		ls -1U >prospacecheck.ali
		spacecheck=`sed -n "/\s/p" prospacecheck.ali`
		if [ -n "$spacecheck" ]
		then
			echo -e "~~Space detected in the receptor files~~~\nSpace will be replaced by _ in the filename"
			sed -n "/\s/p" prospacecheck.ali >spacefiles.ali
			echo -n "
			#!/bin/bash
			bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
			mv \"\$1\" \"\$bspace\"" >rename.bash
			cat prospacefiles.ali | grep "pdbqt" | parallel -j 0 --no-notice --eta bash rename.bash {}
			cat prospacefiles.ali | grep "txt" | parallel -j 0 --no-notice --eta bash rename.bash {}
			rm rename.bash spacefiles.ali
		else
			:
		fi
		rm prospacecheck.ali
		cd "$CONFIG"
		ls -1 *.pdbqt >>protein_list.txt
	   	sed -i "s/.pdbqt//g" protein_list.txt
		while read -r l
		do
			reftxt=`ls "$l".txt  2>/dev/null`
			if [ -n "$reftxt" ]
			then
				:
			else
				rm protein_list.txt; cd "$LIGAND"; rm spacecheck.txt
				echo -e "Configuration file not found for "$l" protein in the "$CONFIG"/\n Please Check and start the process again\n\n"
				exit
			fi
		done <protein_list.txt
   		clear
	fi
	if [ ! -d "$VINA" ]
	then
   		echo -e "Enter the working directory\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" vin 
			if [ -n "$vin" ] 
			then
				spacecheck=`echo "$vin" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$CONFIG"; rm protein_list.txt; cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		VINA=`echo "$vin" | sed "s/\/$//"`
   		clear
   		cd "$VINA"
   		worktest=`ls`
   		if [ -n "$worktest" ]
   		then
			cd "$CONFIG"; rm protein_list.txt; cd "$LIGAND"; rm spacecheck.txt
			echo -e ""$VINA" is not an empty directory"
			exit
   		else 
			:
   		fi
	fi
	if [ -z "$ex" ]
	then
   		echo -e "Enter the exhaustiveness"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -p ">>>" ex 
			if [ -n "$ex" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
	if [ -z "$joobs" ]
	then
		njob=`nproc`
		echo -e ""$njob" number of CPU processors detected in your system\n"
   		echo -e "Enter the number of CPU to be taken for running a single vina job :"
		aa=1
		while [ "$aa" -ge 0 ]
		do  
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" numcpu 
				if [ -n "$numcpu" ] 
				then 
					break 
				else
					echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
				fi 
			done
			joobs=`echo -e "$njob\t$numcpu" | awk '{s=$1/$2} {printf "%d", s}'`
			echo -e ""$joobs" vina jobs will run in parallel\nEnter\n[1] To proceed \n[2] To change again"
			read -p ">>>" parapro
			if [ "$parapro" == 1 ]
			then
				break
			else
				aa=`expr $aa + 1`
			fi
		done
   		clear
	fi
	if [ -z "$top" ]
	then
		echo -e "##Enter the number of ligand complex needed to be generated after VS## \n For the top hits\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -p ">>>" top 
			if [ -n "$top" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
   	if [ "$skip" != "YES" ]; then echo -e "Please enter return to start the virtual screening process"
   	read -p ">>>" null
   	clear
	fi
   	cd $VINA;mkdir Combined_Results
       	echo -e "\n-------------------------------------------------------------------------------\n---------------------------------Summary Report--------------------------------\n-------------------------------------------------------------------------------\nLigand Input Directory="$LIGAND"\nReceptor Input Directory="$CONFIG"\nWorking directory="$VINA"Total number of ligands found inside the directory: "$ligtotal"\nThe number of ligand complex needed to be generated after VS:"$top"\n" >>"$VINA"/summary.txt
	## Space check and file renaming##
	cd "$LIGAND"
	spacecheck=`sed -n "/\s/p" spacecheck.txt`
	if [ -n "$spacecheck" ]
	then
		echo -e "~~Space detected in the ligand files~~~\nSpace will be replaced by _ in the filename"
		sed -n "/\s/p" spacecheck.txt >spacefiles.txt
		echo -n "
		#!/bin/bash
		bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
		mv \"\$1\" \"\$bspace\"" >rename.bash
		cat spacefiles.txt | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
		rm rename.bash spacefiles.txt
	else
		:
	fi
	rm spacecheck.txt
	#######################################		
	cd "$CONFIG"
   	while read -r l
   	do
		cd "$VINA"; mkdir "$l" ; cd "$l" ; mkdir docked_files Results; cd docked_files; mkdir pdbqt_output_"$l" pdbqt_txt_"$l"; 
		cp "$CONFIG"/"$l".pdbqt "$VINA"/"$l"/docked_files/
		cp "$CONFIG"/"$l".txt "$VINA"/"$l"/docked_files/
		echo -n "
		#!/bin/bash
		lol=\`grep -n \"\-\-\-\-\-\+\" "$VINA"/"$l"/docked_files/pdbqt_txt_"$l"/\"\$1\" | cut -c1-2\`
		if [ -n \"\$lol\" ]
		then
			lol=\`expr \"\$lol\" + 1\`
			value=\`cat "$VINA"/"$l"/docked_files/pdbqt_txt_"$l"/\"\$1\" | sed -n \"\$lol\"p | cut -c10-20\`
		else
			value=0
		fi
		echo -e \"\${1%.txt}\t\"\$value\"\" >>"$VINA"/"$l"/Results/output_"$l".txt" >"$VINA"/"$l"/docked_files/feb.bash	  		
		echo -e ""$l" file created and respective protein and configuration file moved\n\n"
		echo -e "Protein "$l" is in the "$l" directory\n" >>"$VINA"/summary.txt	
		clear
   	done <protein_list.txt
   	####Virutal screnning###
	cd "$CONFIG"
   	time=`date +"%c"`; echo -e "Virtual screening start time : "$time"\n" >>"$VINA"/summary.txt
	while read -r l
	do
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock Vina: Running...       +"
		echo -e " + 	* Parallel Docking            : Running...                          +"
		echo -e " + 	* Results analysis            : Waiting...                          +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		cd "$LIGAND"
		echo -e "~~~~~Running Autodock Vina virtual screening for "$l"~~~~~~\n\n"
		ls -1U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta " cd "$VINA"/"$l"/docked_files/ ; cp "$LIGAND"/{} . ; vina --config "$l".txt --receptor "$l".pdbqt --ligand {} --exhaustiveness "$ex" --cpu "$numcpu" --out pdbqt_output_"$l"/{} --log pdbqt_txt_"$l"/{.}.txt >>"$VINA"/log_running.txt ; bash feb.bash {.}.txt ; rm {}"	
		clear
	done <protein_list.txt
	### Combined result parsing####
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Multiple protein Virtual screening using Autodock Vina: Running...       +"
	echo -e " + 	* Parallel Docking            : Completed                           +"
	echo -e " + 	* Results analysis            : Running...                          +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
	cd "$LIGAND"; cp "$CONFIG"/protein_list.txt .
	echo -n "
	#!/bin/bash
	echo -e "\"\$1\"" >>temp_\"\$1\".txt
	while read -r l
	do
		value=\`grep \"\$1\" "$VINA"/\"\$l\"/Results/output_\"\$l\".txt | awk '{print \$2}'\` 2>/dev/null
		if [ -z \"\$value\" ]
		then
			value=0
		fi 
		sed -i \"1s/$/\t\"\$value\"/\" temp_\"\$1\".txt
	done <protein_list.txt
	avg=\`sed -n 1p temp_\"\$1\".txt | cut -f2- | awk '{ for (i=1;i<=NF;i++) {sum=sum+\$i;} avg=sum/NF;}{print avg;}'\`
	sd=\`sed -n 1p temp_\"\$1\".txt | cut -f2- | awk '{ for (i=1;i<=NF;i++) {sum=sum+\$i} avg=sum/NF} {if (NF<=30) { for (i=1;i<=NF;i++) {sa=sa+(\$i-avg)^2;} sd=sqrt(sa/(NF-1));} else {for (i=1;i<=NF;i++) {sa=sa+(\$i-avg)^2;} sd=sqrt(sa/NF);}} {print sd;}'\`	
	sed -i \"1s/$/\t\"\$avg\"\t\"\$sd\"/\" temp_\"\$1\".txt
	insert=\`sed -n 1p temp_\"\$1\".txt\`
	echo -e \"\$insert\" >>"$VINA"/Combined_Results/combined_output.txt
	rm temp_\"\$1\".txt " >mdfeb.bash
	echo -e "~~~Combined Results Parsing~~~"
	ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "bash mdfeb.bash {.}"
	avg=`cat protein_list.txt | wc -l`
	avg=`expr "$avg" + 2`
	rm mdfeb.bash protein_list.txt
	cd "$VINA"/Combined_Results/
	sort -n -k"$avg" combined_output.txt >combined_sorted.txt
	sed -i "1s/^/Ligand_Name\n/" "$VINA"/Combined_Results/combined_sorted.txt
	rm combined_output.txt
	cd "$CONFIG"
	while read -r l
	do
		sed -i "1s/$/\t"$l"/" "$VINA"/Combined_Results/combined_sorted.txt
	done <protein_list.txt
	sed -i "1s/$/\tAverage\tSD/" "$VINA"/Combined_Results/combined_sorted.txt
	echo -e "##################################################################" >>"$VINA"/summary.txt
   	echo -e "\n\n ---Each protein specific output summary---- \n\n" >>"$VINA"/summary.txt
   	###Result Analysis###
   	cd "$CONFIG"
   	while read -r l
   	do
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock Vina: Running...       +"
		echo -e " + 	* Parallel Docking            : Completed                           +"
		echo -e " + 	* Results analysis            : Running...                          +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n\n~~~Running result analysis for "$l"~~~"
		cd "$VINA"/"$l"/Results; mkdir complex
		cat output_"$l".txt | sort -n -k2 | cut -f1 | sed -n "1,"$top"p" >list_"$l".txt
		cat output_"$l".txt | sort -n -k2 | sed "1s/^/Ligand_Name\tScore\n/" >sorted_list_"$l".txt
		cat output_"$l".txt | sort -n -k2 | sed -n "1,"$top"p" | sed "1s/^/Ligand_Name\tScore\n/" >toplist_"$l".txt
		sed -i "s/$/.pdbqt/g" list_"$l".txt
		cp list_"$l".txt ../docked_files/pdbqt_output_"$l"/; cd ../docked_files/pdbqt_output_"$l"/
		while read -r zz
		do
			cp "$zz" "$VINA"/"$l"/Results/complex/
		done <list_"$l".txt
		rm list_"$l".txt
		cd ../../Results/; rm list_"$l".txt; cd complex/
		for f in *.pdbqt	##Ligand Splitting##
		do 
			mkdir "${f%.pdbqt}"; mv "$f" "${f%.pdbqt}"/; cd "${f%.pdbqt}"/
			vina_split --input "$f" --ligand lig 1>/dev/null
			rm "$f"; ltest=`ls -1 lig*.pdbqt | wc -l`;if [ "$ltest" -le 9 ]; then mv lig1.pdbqt "$f"; else mv lig01.pdbqt "$f";fi; mv "$f" ../; cd ../ ; rm -R "${f%.pdbqt}"/
		done
		###converting pdbqt to pdb##
   		cd "$VINA"/"$l"/Results/complex/
   		cp "$CONFIG"/"$l".pdbqt "$VINA"/"$l"/Results/
   		for f in *.pdbqt; do cut -c-66 "$f" | sed '/ROOT/d;/ENDROOT/d;/BRANCH/d;/ENDBRANCH/d;/TORSDOF/d;s/ATOM\s\s/HETATM/g;s/<0>/LIG/g' > ${f%.pdbqt}.pdb; rm "$f"; done
   		pro="$l".pdbqt
   		cd "$VINA"/"$l"/Results/; cut -c-66 "$pro" >${pro%.pdbqt}.pdb;cd complex/
   		###PDB complex generation for the best hits###
   		for f in *.pdb; do cat ../${pro%.pdbqt}.pdb "$f" > ${pro%.pdbqt}_${f%.pdb}complex.pdb; rm "$f"; done
   		cd "$VINA"/"$l"/Results
   		rm ${pro%.pdbqt}.pdb "$pro"
  		echo -e "\n\n\n------"$l" summary report------\n\n" >>"$VINA"/summary.txt
		cat "$VINA"/"$l"/Results/toplist_"$l".txt >>"$VINA"/summary.txt	
   	done <protein_list.txt
   	cd "$CONFIG"
   	while read -r l
   	do
		cd "$VINA"/"$l"/docked_files/; rm "$l".pdbqt "$l".txt feb.bash
		cd "$VINA"/"$l"/Results/; rm output_"$l".txt
   	done <protein_list.txt
   	cd "$CONFIG"; rm protein_list.txt
	cd "$VINA"; rm log_running.txt
   	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Multiple protein Virtual screening using Autodock Vina: Running...       +"
	echo -e " + 	* Parallel Docking            : Completed                           +"
	echo -e " + 	* Results analysis            : Completed                           +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -e "-----Multiple protein VS finished------"
	echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$VINA"/summary.txt
elif [ "$opt" == 3 ]
then
	##########################################################################################################
   	######			Virtual screening with AutoDock			     #############################
   	##########################################################################################################
	if [ ! -d "$LIGAND" ]
	then
   		##Setting path for the Ligand splitted database##
		echo -e "Enter the directory where ligands have been prepared\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" lig 
			if [ -n "$lig" ] 
			then 
				spacecheck=`echo "$lig" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		LIGAND=`echo -e "$lig" | sed "s/\/$//"`
   		clear
   		cd "$LIGAND"
		ligtotal=`ls -1U | grep "pdbqt" | tee spacecheck.txt | wc -l`
		ligform=`cat spacecheck.txt | grep "pdbqt"`
   		if [ -n "$ligform" ]
   		then
			echo -e "pdbqt file was found inside the directory\n\n"
   		else
			rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
   		fi 
   		echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
	fi
	if [ -z "$atm" ]
	then
		####################################################################################################################
		echo -e "Enter\n[1] To provide atom types for preparing map files\n[2] To calculate atom types from the ligand directory"
		ii=1 
		while [ "$ii" -ge 0 ] 
		do 	
			read -ep ">>>" atm 
			if [ "$atm" == 1 ] 
			then
				clear
				echo -e "Enter the atom types seperated by comma\n For ex: HD,Br,A,C,OA"
				i=1 
				while [ "$i" -ge 0 ] 
				do 	
					read -ep ">>>" atomty 
					echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
					atomty=`echo "$atomty" | sed "s/,/\n/g"`
					b=`echo "$atomty" | wc -l`
					c=1
					for ff in $(echo "$atomty")
					do
						if [ "$c" -le "$b" ]
						then
							check=`grep "$ff" AD_atm_types.txt`
							if [ -n "$check" ]
							then
								c=`expr $c + 1`
							else
								echo -e "Unidentified atom type found!!. Please type again "
								wrongatm="YES" 
								i=`expr $i + 1` 
								break
							fi
						else
							break
						fi
					done
					if [ "$c" -gt "$b" ]; then clear; break; fi
				done
				if [ "$wrongatm" == "YES" ]
				then
					:
				else
					break			
				fi	
				atomtypes=`echo "$atomty"`
				echo -e "Atom types given: "$atomtypes""
				rm AD_atm_types.txt
				break 
			elif [ "$atm" == 2 ]
			then
				clear
				echo -e "Atom types calculation from directory selected" 
				break
			else
				echo -e "Error: empty return. Please type again " 
				ii=`expr $ii + 1` 
			fi 
		done
	fi
	if [ ! -d "$CONFIG" ]
	then	
		#### config splitting types
	   	echo -e "Enter the directory containing prepared protein and configuration file\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" config 
			if [ -n "$config" ] 
			then 
				spacecheck=`echo "$config" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	CONFIG=`echo "$config" | sed "s/\/$//"`
	   	clear
	   	cd "$CONFIG"
	   	refgpf=`ls *.gpf  2>/dev/null`
	   	refdpf=`ls *.dpf  2>/dev/null`
	   	if [ -n "$refgpf" ] && [ -n "$refdpf" ]
	   	then	
			fspace=`ls *.gpf | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.gpf | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
	   		refgpf=`ls *.gpf`
			fspace=`ls *.dpf | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.dpf | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
	   		refdpf=`ls *.dpf`
	   	else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "Reference gpf abd dpf files not found in the "$CONFIG"\n Please Check and start the process again\n\n"
			exit
	   	fi
   		protcheck=`ls *.pdbqt 2>/dev/null`
   		if [ -n "$protcheck" ]
   		then	
			fspace=`ls *.pdbqt | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.pdbqt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
   			proteinname=`ls *.pdbqt`
   		else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "Pdbqt file for protein was not found in the "$CONFIG"\n Please Check and start the process again\n\n"
			exit
   		fi
	fi
	if [ ! -d "$VINA" ]
	then
   		echo -e "Enter the working directory\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" vin 
			if [ -n "$vin" ] 
			then 
				spacecheck=`echo "$vin" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		VINA=`echo "$vin" | sed "s/\/$//"`
   		clear
   		cd "$VINA"
   		worktest=`ls`
   		if [ -n "$worktest" ]
   		then
			cd "$LIGAND"; rm spacecheck.txt
			echo -e ""$VINA" is not an empty directory"
			exit
   		else 
			:
   		fi
	fi
	if [ -z "$joobs" ]
	then
		njob=`nproc`
		echo -e ""$njob" number of processors detected in your system\n"$njob" number of jobs can be run in parallel at a time\n\n"
   		echo -e "Enter the number of jobs to be run in parallel : [0] to run as many parallel jobs as possible"
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" joobs 
			if [ -n "$joobs" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
	if [ -z "$top" ]
	then
   		echo -e "Enter the number of top ligands for which protein-ligand complex needed to be generated\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" top 
			if [ -n "$top" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
   	if [ "$skip" != "YES" ]; then echo -e "Please enter return to start the virtual screening process"
   	read -p ">>>" null
   	clear
	fi
   	echo -e "---------------------------------------------------------------\n-----------------Virtual screening Report Summary--------------\n---------------------------------------------------------------\n\nDirectory for ligand "$LIGAND"\nDirectory for protein and configuration file "$CONFIG"\nDirectory for working "$VINA"\nNumber of top ligands to be taken "$top"\n" >>"$VINA"/summary.txt
	time=`date +"%c"`; echo -e "Virtual screening start time: "$time"\n\n\n" >>"$VINA"/summary.txt
	## Space check and file renaming##
	cd "$LIGAND"
	spacecheck=`sed -n "/\s/p" spacecheck.txt`
	if [ -n "$spacecheck" ]
	then
		echo -e "~~Space detected in the ligand files~~~\nSpace will be replaced by _ in the filename"
		sed -n "/\s/p" spacecheck.txt >spacefiles.txt
		echo -n "
		#!/bin/bash
		bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
		mv \"\$1\" \"\$bspace\"" >rename.bash
		cat spacefiles.txt | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
		rm rename.bash spacefiles.txt
	else
		:
	fi
	rm spacecheck.txt
	#######################################
	### Atom types calculation###
	if [ "$atm" == 2 ]
	then
		cd "$VINA"; mkdir unidentified_atom_types_ligands; cd "$LIGAND"; 
		echo -e "Calculating atom types from the ligand directory"
		echo -n "
		#!/bin/bash
		for ff in \$(cat \"\$1\")
		do
			check=\`grep \"\$ff\" AD_atm_types.txt\`
			if [ -n \"\$check\" ]
			then
				echo \"\$ff\" >>log.txt
			else
				mv \"\$2\" "$VINA"/unidentified_atom_types_ligands/
				break
			fi
		done" >atomtype_check.bash
		echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Virtual screening using Autodock: Running...                             +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Running...                         +"; fi
		echo -e " + 	* Grid and Map files           : Waiting...                         +"
		echo -e " + 	* Parallel Docking             : Waiting...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "sed "/REMARK/d" {} | cut -c77- | sed "/^$/d" | sed "s/\s//g" | sort -u >log_{.}.txt; bash atomtype_check.bash log_{.}.txt {}; rm log_{.}.txt"
		cat log.txt | sort -u >atmtypes.txt
		rm atomtype_check.bash AD_atm_types.txt
		unidecheck=`ls -A "$VINA"/unidentified_atom_types_ligands/`
		if [ -n "$unidecheck" ]
		then
			:
		else
			cd "$VINA"; rmdir unidentified_atom_types_ligands
		fi
		cd "$LIGAND"
		atp=0
		while read -r l
		do
			atp="$atp,"$l""	
		done <atmtypes.txt
		atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
		rm log.txt atmtypes.txt
		echo "Atom types are : "$atomtypes"" >>"$VINA"/summary.txt
		clear
	fi
   	##################################################################################################
	cd "$VINA"; mkdir Results docked_files ; cd docked_files/ ; mkdir grid dlg_files dlg_error
   	cd "$LIGAND"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + Virtual screening using Autodock: Running...                             +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Running...                         +"
	echo -e " + 	* Parallel Docking             : Waiting...                         +"
	echo -e " + 	* Results analysis             : Waiting...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -e "\n"
	echo -e "Autogrid: Grid and mapfiles generating..."
	cd "$VINA"/docked_files/grid/; 
	echo -n "
	#!/bin/bash
	dlgcheck=\`grep \"autodock4: Unsuccessful Completion\" \"\$1\"\`
	if  [ -n \"\$dlgcheck\" ]
	then
		mv \"\$1\" "$VINA"/docked_files/dlg_error/
	else 
		FEB=\`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' \"\$1\" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print \$1}'\`
		echo -e \"\${1%.dlg}\\t\"\$FEB\"\" >>"$VINA"/Results/output.txt
		mv \"\$1\" "$VINA"/docked_files/dlg_files/
	fi" >feb.bash
	cp "$CONFIG"/*.* . ; cp "$PYCONFIG"/prepare_gpf4.py . ; cp "$PYCONFIG"/prepare_dpf42.py . 
	"$MGLROOT"/bin/pythonsh prepare_gpf4.py -i "$refgpf" -r "$protcheck" -p ligand_types="$atomtypes" -o grid.gpf >>"$VINA"/grid_log.txt 
	autogrid4 -p grid.gpf -l grid.glg 2>>"$VINA"/grid_log.txt 
	glgcheck=`grep "autogrid4: Unsuccessful Completion" grid.glg`
	if [ -n "$glgcheck" ]
	then
		echo "Error occured during Grid file generation!! Process Terminated."
		exit
	fi 
	clear
	cd "$LIGAND";
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodock: Running...                             +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Running...                         +"
	echo -e " + 	* Results analysis             : Waiting...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -e "\n"
	echo -e "~~~~~Running Autodock~~~~~~\n\n"
	ls -U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "cd "$VINA"/docked_files/grid/; cp "$LIGAND"/{} . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$refdpf" -r "$protcheck" -o {.}.dpf >>"$VINA"/dpf_log.txt; sed -i "s/extended/bound/g" {.}.dpf ; echo {} >>"$VINA"/log.txt ; autodock4 -p {.}.dpf -l {.}.dlg 2>>"$VINA"/log.txt ; bash feb.bash {.}.dlg ; rm {} {.}.dpf" 
	cd "$VINA"/docked_files/grid/ ; rm feb.bash
	dlg_error_check=`ls -A "$VINA"/docked_files/dlg_error/`
	if [ -n "$dlg_error_check" ]
	then
		:
	else
		cd "$VINA"/docked_files/;rmdir dlg_error
	fi
   	clear 
   	######Result analysis####
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodock: Running...                             +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Running...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	cd "$VINA"/Results
   	sort -n -k2 output.txt -o sorted.txt
   	sed -n "1,"$top"p" sorted.txt | cut -f1 > list.txt
   	###Retreiving the top hit structures from the batch###
   	a=1
   	cd "$VINA"/Results; mkdir complex
   	while read -r l
   	do
		cp "$VINA"/docked_files/dlg_files/"$l".dlg "$VINA"/Results/complex 
   	done <list.txt
   	###PDB files from dlg####
   	cd "$CONFIG"/ ; cut -c-66 "$protcheck" >"$VINA"/Results/complex/${protcheck%.pdbqt}.pdb;cd "$VINA"/Results/complex; mkdir dlg_files pdb_files best_cluster ;
   	for f in *.dlg
   	do
		grep "^DOCKED" "$f" | cut -c9- | cut -c-66 | sed '/ROOT/d;/ENDROOT/d;/BRANCH/d;/ENDBRANCH/d;/TORSDOF/d;s/ATOM\s\s/HETATM/g;s/<0>/LIG/g'> ${f%.dlg}.pdb # all porse pdb files
 		mv ${f%.dlg}.pdb pdb_files
		sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | cut -c-66 | sed 's/ATOM\s\s/HETATM/g;s/<0>/LIG/g' >${f%.dlg}_best.pdb #Best structure from the first cluster
		cat ${protcheck%.pdbqt}.pdb ${f%.dlg}_best.pdb >best_cluster/${protcheck%.pdbqt}_complex_with_${f%.dlg}.pdb; rm ${f%.dlg}_best.pdb #complex generation
		ONE=0;ONEA=0;ONEB=0;TWO=0;THREE=0;FOUR=0;FEB=0;KI=0;RMSD=0
		ONE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Intermolecular Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		ONEA=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/vdW + Hbond + desolv Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		ONEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Electrostatic Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		TWO=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Total Internal Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		THREE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Torsional Free Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		FOUR=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Unbound System/p' | cut -d'=' -f3 | awk '{print $1}'`
		FEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		KI=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Inhibition Constant/p' | cut -d'=' -f2 | awk '{print $1$2}'`
		RMSD=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/RMSD from reference structure/p' | cut -d'=' -f2 | awk '{print $1$2}'`
		echo -e "${f%.dlg}\t"$ONE"\t"$ONEA"\t"$ONEB"\t"$TWO"\t"$THREE"\t"$FOUR"\t"$FEB"\t"$KI"\t"$RMSD"" >>"$VINA"/Results/toplist.txt 
		mv "$f" dlg_files
   	done
   	rm ${protcheck%.pdbqt}.pdb
   	######Map files Generation for the top hits####
   	cd "$VINA"/Results/
   	while read -r l
   	do
		cd "$VINA"/Results/complex/dlg_files/; 
		cp "$LIGAND"/"$l".pdbqt .
   	done <list.txt
   	cd "$VINA"/Results/complex/dlg_files/
   	#########################################
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + Virtual screening using Autodock: Running...                             +"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Running...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
   	echo -e "~~~~~~~~~~~Repreparing mapfiles for tophits~~~~~~~~"
   	ls -U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "mkdir {.} ; cd {.} ; cp ../{} . ; cp "$VINA"/docked_files/grid/*.* . ; mv ../{.}.dlg . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$refdpf" -r "$protcheck" -o {.}.dpf >>dpf_log.txt; rm dpf_log.txt ; sed -i "s/extended/bound/g" {.}.dpf ; rm prepare_gpf4.py prepare_dpf42.py"
   	clear
   	###############
   	rm *.pdbqt
   	cd "$VINA"/Results/; rm output.txt
   	sed -i "1s/^/Ligand_Name\tDocking_score\n/" sorted.txt
   	sort -n -k8 toplist.txt -o toplist.txt
   	sed -i "1s/^/Ligand_Name\tIntermolecular_Energy\t[vdW+Hbond+desolv]Energy\tElectrostatic_Energy\tTotal_Internal_Energy\tTorsional_Free Energy\tUnbound_System's_Energy\tFree Energy_of_ Binding\tKI\tRMSD\n/" toplist.txt
   	rm list.txt
   	cd "$VINA"; rm grid_log.txt dpf_log.txt log.txt; cd "$VINA/docked_files/grid/"; ls -1U | parallel -j "$joobs" "rm {}"; cd ../; rmdir grid
	echo -e "\n\nThe best compounds and its energy values are" >>"$VINA"/summary.txt
	topp=`expr "$top" + 1`; sed -n "1,"$topp"p" "$VINA"/Results/sorted.txt >>"$VINA"/summary.txt
   	time=`date +"%c"`; echo -e "\n\n\nVirtual screening End time: "$time"\n\n" >>"$VINA"/summary.txt
   	echo -e "~~~~~~~~~~~~Virtual Screening using Autodock Finished~~~~~~~~~~~~~~~~~~~~" >>"$VINA"/summary.txt
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + Virtual screening using Autodock: Completed                              +"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Completed                          +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "The best compounds and its energy values are"
	topp=`expr "$top" + 1`; sed -n "1,"$topp"p" "$VINA"/Results/sorted.txt
   	echo -e "~~~~~~~~~~~~Virtual Screening using Autodock Finished~~~~~~~~~~~~~~~~~~~~"
	echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$VINA"/summary.txt
elif [ "$opt" == 4 ]
then
	##########################################################################################################
   	######	Multiple Protein Virtual screening with AutoDock                     #############################
   	##########################################################################################################
	if [ ! -d "$LIGAND" ]
	then
   		##Setting path for the Ligand splitted database##
		echo -e "Enter the directory where ligands have been prepared\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" lig 
			if [ -n "$lig" ] 
			then 
			spacecheck=`echo "$lig" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		LIGAND=`echo -e "$lig" | sed "s/\/$//"`
   		clear
   		cd "$LIGAND"
		ligtotal=`ls -1U | grep "pdbqt" | tee spacecheck.txt | wc -l`
		ligform=`cat spacecheck.txt | grep "pdbqt"`
   		if [ -n "$ligform" ]
   		then
			echo -e "pdbqt file was found inside the directory\n\n"
   		else
			rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
   		fi
	echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
	fi 
	if [ -z "$atm" ]
	then
		####################################################################################################################
		echo -e "Enter \n[1] To provide atom types for preparing map files\n[2] To calculate atom types from the ligand directory"
		ii=1 
		while [ "$ii" -ge 0 ] 
		do 
			read -ep ">>>" atm 
			if [ "$atm" == 1 ] 
			then
				clear
				echo -e "Enter the atom types seperated by comma\n For ex: HD,Br,A,C,OA"
				i=1 
				while [ "$i" -ge 0 ] 
				do 	
					read -ep ">>>" atomty 
					echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
					atomty=`echo "$atomty" | sed "s/,/\n/g"`
					b=`echo "$atomty" | wc -l`
					c=1
					for ff in $(echo "$atomty")
					do
						if [ "$c" -le "$b" ]
						then
							check=`grep "$ff" AD_atm_types.txt`
							if [ -n "$check" ]
							then
								c=`expr $c + 1`
							else
								echo -e "Unidentified atom type found!!. Please type again "
								wrongatm="YES" 
								i=`expr $i + 1` 
								break
							fi
						else
							break
						fi
					done
					if [ "$c" -gt "$b" ]; then clear; break; fi
				done
				if [ "$wrongatm" == "YES" ]
				then
					:
				else
					break			
				fi	
				atomtypes=`echo "$atomty"`
				echo -e "Atom types given: "$atomtypes""
				rm AD_atm_types.txt
				break  
			elif [ "$atm" == 2 ]
			then
				clear
				echo -e "Atom types calculation from directory selected\n" 
				break
			else
				echo -e "Error: empty return. Please type again " 
				ii=`expr $ii + 1` 
			fi 
		done
	fi
	if [ ! -d "$CONFIG" ]
	then
		###########################################################################################
      		echo -e "Enter the directory containing prepared protein and configuration file\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" config 
			if [ -n "$config" ] 
			then 
				spacecheck=`echo "$config" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		CONFIG=`echo "$config" | sed "s/\/$//"`
   		clear
   		cd "$CONFIG"
		ls -1 >files.txt
		dirspacecheck=`cat files.txt | sed -n "/\s/p"`
		if [ -n "$dirspacecheck" ]
		then
			sed -n "/\s/p" files.txt >spacefiles.txt
			echo -n "
			#!/bin/bash
			bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
			mv \"\$1\" \"\$bspace\"" >rename.bash
			cat spacefiles.txt | parallel -j 0 --no-notice bash rename.bash {}
			rm rename.bash spacefiles.txt
		fi
		rm files.txt
		ls -1 *.pdbqt >>protein_list.txt
   		sed -i "s/.pdbqt//g" protein_list.txt
		while read -r l
		do
			refgpf=`ls "$l".gpf  2>/dev/null`
			refdpf=`ls "$l".dpf  2>/dev/null`			
			if [ -n "$refgpf" ] && [ -n "$refdpf" ]
			then
				:
			else
				cd "$CONFIG"; rm protein_list.txt; cd "$LIGAND"; rm spacecheck.txt
				echo -e "Reference gpf and dpf files not found for "$l" protein in the "$CONFIG"/\n Please Check and start the process again\n\n"
				exit
			fi
		done <protein_list.txt
	fi
	if [ ! -d "$VINA" ]
	then
		echo -e "Enter the working directory\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" vin 
			if [ -n "$vin" ] 
			then 
				spacecheck=`echo "$vin" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$CONFIG"; rm protein_list.txt; cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
					i=`expr $i + 1` 
			fi 
		done
   		VINA=`echo "$vin" | sed "s/\/$//"`
   		clear
   		cd "$VINA"
   		worktest=`ls`
   		if [ -n "$worktest" ]
   		then
			cd "$CONFIG"; rm protein_list.txt; cd "$LIGAND"; rm spacecheck.txt
			echo -e ""$VINA" is not an empty directory"
			exit
   		else 
			:
   		fi
	fi
	if [ -z "$joobs" ]
	then
		njob=`nproc`
		echo -e ""$njob" number of processors detected in your system\n"$njob" number of jobs can be run in parallel at a time\n\n"
   		echo -e "Enter the number of jobs to be run in parallel : [0] to run as many parallel jobs as possible"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" joobs 
			if [ -n "$joobs" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
	if [ -z "$top" ]
	then
   		echo -e "Enter the number of top ligands for each protein-ligand complex needed to be generated\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" top 
			if [ -n "$top" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
   	if [ "$skip" != "YES" ]; then echo -e "Please enter return to start the virtual screening process"
   	read -p ">>>" null
   	clear
	fi
   	echo -e "---------------------------------------------------------------\n-----------------Virtual screening Report Summary--------------\n---------------------------------------------------------------\n\nDirectory for ligand "$LIGAND"\nDirectory for protein and configuration file "$CONFIG"\nDirectory for working "$VINA"\nNumber of top ligands to be taken "$top"\n" >>"$VINA"/summary.txt
   	echo -e "List of proteins:" >>"$VINA"/summary.txt
	cd "$CONFIG"
	cat protein_list.txt >>"$VINA"/summary.txt
	time=`date +"%c"`; echo -e "\n\nVirtual screening Start time: "$time"" >>"$VINA"/summary.txt
	## Space check and file renaming##
	cd "$LIGAND"
	spacecheck=`sed -n "/\s/p" spacecheck.txt`
	if [ -n "$spacecheck" ]
	then
		echo -e "~~Space detected in the ligand files~~~\nSpace will be replaced by _ in the filename"
		sed -n "/\s/p" spacecheck.txt >spacefiles.txt
		echo -n "
		#!/bin/bash
		bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
		mv \"\$1\" \"\$bspace\"" >rename.bash
		cat spacefiles.txt | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
		rm rename.bash spacefiles.txt
	else
		:
	fi
	rm spacecheck.txt
	#######################################
	### Atom types calculation###
	if [ "$atm" == 2 ]
	then
		cd "$VINA"; mkdir unidentified_atom_types_ligands; cd "$LIGAND"; 
		echo -e "Calculating atom types from the ligand directory"
		echo -n "
		#!/bin/bash
		for ff in \$(cat \"\$1\")
		do
			check=\`grep \"\$ff\" AD_atm_types.txt\`
			if [ -n \"\$check\" ]
			then
				echo \"\$ff\" >>log.txt
			else
				mv \"\$2\" "$VINA"/unidentified_atom_types_ligands/
				break
			fi
		done" >atomtype_check.bash
		echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock: Running...            +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Running...                         +"; fi
		echo -e " + 	* Grid and Map files           : Waiting...                         +"
		echo -e " + 	* Parallel Docking             : Waiting...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n~~~Atom types calculation~~~~~"
		ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "sed "/REMARK/d" {} | cut -c77- | sed "/^$/d" | sed "s/\s//g" | sort -u >log_{.}.txt; bash atomtype_check.bash log_{.}.txt {}; rm log_{.}.txt"
		cat log.txt | sort -u >atmtypes.txt
		rm atomtype_check.bash AD_atm_types.txt
		unidecheck=`ls -A "$VINA"/unidentified_atom_types_ligands/`
		if [ -n "$unidecheck" ]
		then
			:
		else
			cd "$VINA"; rmdir unidentified_atom_types_ligands
		fi
		cd "$LIGAND"
		atp=0
		while read -r l
		do
			atp="$atp,"$l""	
		done <atmtypes.txt
		atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
		rm log.txt atmtypes.txt
		echo "Atom types are : "$atomtypes"" >>"$VINA"/summary.txt
	fi
   	cd "$VINA"; mkdir Combined_Results 
	cd "$CONFIG"
   	while read -r l
   	do
		cd "$VINA"/; mkdir "$l";cd "$l"/; mkdir docked_files Results ; cd docked_files/ ; mkdir grid dlg_files dlg_error
		###############################################################
		cd $LIGAND
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock: Running...            +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Running...                         +"
		echo -e " + 	* Parallel Docking             : Waiting...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		echo -e "~~~~~~~~~~~Mapfiles generation for "$l" on progress~~~~~~~~"
		cd "$VINA"/"$l"/docked_files/grid/; 
		cp "$CONFIG"/"$l".pdbqt . ; cp "$CONFIG"/"$l".gpf . ;cp "$CONFIG"/"$l".dpf . ;cp "$PYCONFIG"/prepare_gpf4.py . ; cp "$PYCONFIG"/prepare_dpf42.py .
		echo -n "
		#!/bin/bash
		dlgcheck=\`grep \"autodock4: Unsuccessful Completion\" \"\$1\"\`
		if  [ -n \"\$dlgcheck\" ]
		then
			mv \"\$1\" "$VINA"/"$l"/docked_files/dlg_error/
		else 
			FEB=\`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' \"\$1\" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print \$1}'\`
			echo -e \"\${1%.dlg}\\t\"\$FEB\"\" >>"$VINA"/"$l"/Results/output_"$l".txt
			mv \"\$1\" "$VINA"/"$l"/docked_files/dlg_files/
		fi" >feb.bash 
		"$MGLROOT"/bin/pythonsh prepare_gpf4.py -i "$l".gpf -r "$l".pdbqt -p ligand_types="$atomtypes" -o grid.gpf >>"$VINA"/grid_log.txt 
		autogrid4 -p grid.gpf -l grid.glg 2>>"$VINA"/grid_log.txt 
		glgcheck=`grep "autogrid4: Unsuccessful Completion" grid.glg`
		if [ -n "$glgcheck" ]
		then
			echo "Error occured during Grid file generation!! Process Terminated."
			exit
		fi
		clear
		cd "$LIGAND";
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock: Running...            +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Completed                          +"
		echo -e " + 	* Parallel Docking             : Running...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n~~~~Running virtual screening for "$l"~~~~"
		ls -U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "cd "$VINA"/"$l"/docked_files/grid/ ; cp "$LIGAND"/{} . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$l".dpf -r "$l".pdbqt -o {.}.dpf >>"$VINA"/dpf_log.txt; sed -i "s/extended/bound/g" {.}.dpf ; echo {} >>"$VINA"/log.txt ; autodock4 -p {.}.dpf -l {.}.dlg 2>>"$VINA"/log.txt ; bash feb.bash {.}.dlg ; rm {} {.}.dpf" 
		cd "$VINA"/"$l"/docked_files/grid/; rm feb.bash
		dlg_error_check=`ls -A "$VINA"/"$l"/docked_files/dlg_error/`
		if [ -n "$dlg_error_check" ]
		then
			:
		else
			cd "$VINA"/"$l"/docked_files/;rmdir dlg_error
		fi
   	done <protein_list.txt
	### Combined result parsing####
	cd "$LIGAND"; cp "$CONFIG"/protein_list.txt .
	echo -n "
	#!/bin/bash
	echo -e "\"\$1\"" >>temp_\"\$1\".txt
	while read -r l
	do
		value=\`grep \"\$1\" "$VINA"/\"\$l\"/Results/output_\"\$l\".txt | cut -f2\` 2>/dev/null
		if [ -z \"\$value\" ]
		then
			value=0
		fi 
		sed -i \"1s/$/\t\"\$value\"/\" temp_\"\$1\".txt
	done <protein_list.txt
	avg=\`sed -n 1p temp_\"\$1\".txt | cut -f2- | awk '{ for (i=1;i<=NF;i++) {sum=sum+\$i;} avg=sum/NF;}{print avg;}'\`
	sd=\`sed -n 1p temp_\"\$1\".txt | cut -f2- | awk '{ for (i=1;i<=NF;i++) {sum=sum+\$i} avg=sum/NF} {if (NF<=30) { for (i=1;i<=NF;i++) {sa=sa+(\$i-avg)^2;} sd=sqrt(sa/(NF-1));} else {for (i=1;i<=NF;i++) {sa=sa+(\$i-avg)^2;} sd=sqrt(sa/NF);}} {print sd;}'\`	
	sed -i \"1s/$/\t\"\$avg\"\t\"\$sd\"/\" temp_\"\$1\".txt
	insert=\`sed -n 1p temp_\"\$1\".txt\`
	echo -e \"\$insert\" >>"$VINA"/Combined_Results/combined_output.txt
	rm temp_\"\$1\".txt " >mdfeb.bash
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Multiple protein Virtual screening using Autodock: Running...            +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Running...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n~~~Combined Results Parsing~~~"
	ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "bash mdfeb.bash {.}"
	avg=`cat protein_list.txt | wc -l`
	avg=`expr "$avg" + 2`
	rm mdfeb.bash protein_list.txt
	cd "$VINA"/Combined_Results/
	sort -n -k"$avg" combined_output.txt >combined_sorted.txt
	sed -i "1s/^/Ligand_Name\n/" "$VINA"/Combined_Results/combined_sorted.txt
	rm combined_output.txt
	cd "$CONFIG"
	while read -r l
	do
		sed -i "1s/$/\t"$l"/" "$VINA"/Combined_Results/combined_sorted.txt
	done <protein_list.txt
	sed -i "1s/$/\tAverage\tSD/" "$VINA"/Combined_Results/combined_sorted.txt
   	cd $VINA; rm grid_log.txt dpf_log.txt log.txt
   	########Complex generation for individual protein top complex###############
   	cd "$CONFIG"
   	while read -r l
   	do
		clear
		######Result analysis####
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock: Running...            +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Completed                          +"
		echo -e " + 	* Parallel Docking             : Completed                          +"
		echo -e " + 	* Results analysis             : Running...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n~~~~Result analysis for "$l"~~~~"
		cd "$VINA"/"$l"/Results
		sort -n -k2 output_"$l".txt -o sorted_"$l".txt
		sed -n "1,"$top"p" sorted_"$l".txt | cut -f1 >list_"$l".txt
		###Retreiving the top hit structures from the batch###
		a=1
		cd "$VINA"/"$l"/Results; mkdir complex
		while read -r zz
		do
			cp "$VINA"/"$l"/docked_files/dlg_files/"$zz".dlg "$VINA"/"$l"/Results/complex/ 	
		done <list_"$l".txt
		###PDB files from dlg####
		cd "$CONFIG"/; cut -c-66 "$l".pdbqt >$VINA/"$l"/Results/complex/"$l".pdb;cd $VINA/"$l"/Results/complex; mkdir dlg_files pdb_files best_cluster ;
		for f in *.dlg
		do
			grep "^DOCKED" $f | cut -c9- | cut -c-66 | sed '/ROOT/d;/ENDROOT/d;/BRANCH/d;/ENDBRANCH/d;/TORSDOF/d;s/ATOM\s\s/HETATM/g;s/<0>/LIG/g'> ${f%.dlg}.pdb # all porse pdb files
			mv ${f%.dlg}.pdb pdb_files
			sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | cut -c-66 | sed 's/ATOM\s\s/HETATM/g;s/<0>/LIG/g' >${f%.dlg}_best.pdb #Best structure from the first cluster
			cat "$l".pdb ${f%.dlg}_best.pdb >best_cluster/"$l"_complex_with_${f%.dlg}.pdb; rm ${f%.dlg}_best.pdb #complex generation	
			ONE=0;ONEA=0;ONEB=0;TWO=0;THREE=0;FOUR=0;FEB=0;KI=0;RMSD=0
			ONE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Intermolecular Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			ONEA=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/vdW + Hbond + desolv Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			ONEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Electrostatic Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			TWO=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Total Internal Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			THREE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Torsional Free Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			FOUR=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Unbound System/p' | cut -d'=' -f3 | awk '{print $1}'`
			FEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			KI=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Inhibition Constant/p' | cut -d'=' -f2 | awk '{print $1$2}'`
			RMSD=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/RMSD from reference structure/p' | cut -d'=' -f2 | awk '{print $1$2}'`
			echo -e "${f%.dlg}\t$ONE\t$ONEA\t$ONEB\t$TWO\t$THREE\t$FOUR\t$FEB\t$KI\t$RMSD" >>"$VINA"/"$l"/Results/toplist_"$l".txt 
			mv $f dlg_files
		done
		rm "$l".pdb
   		######Map files Generation for the top hits####
		cd $VINA/"$l"/Results/
		while read -r zz
		do
			cd $VINA/"$l"/Results/complex/dlg_files/; 
			cp $LIGAND/"$zz".pdbqt .
   		done <list_"$l".txt
   	        cd $VINA/"$l"/Results/complex/dlg_files/
		###################################################
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using Autodock: Running...            +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Completed                          +"
		echo -e " + 	* Parallel Docking             : Completed                          +"
		echo -e " + 	* Results analysis             : Running...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		echo -e "~~~~~~~~~~~Repreparing mapfiles for "$l"~~~~~~~~"
		ls -U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "mkdir {.} ; cd {.} ; cp ../{} . ; cp "$VINA"/"$l"/docked_files/grid/*.* . ; mv ../{.}.dlg . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$l".dpf -r "$l".pdbqt -o {.}.dpf >>dpf_log.txt; rm dpf_log.txt ; sed -i "s/extended/bound/g" {.}.dpf; rm prepare_gpf4.py prepare_dpf42.py" 
		clear
   		###############
   		rm *.pdbqt
   		cd $VINA/"$l"/Results/; rm output_"$l".txt
   		sed -i "1s/^/Ligand_Name\tDocking_score\n/" sorted_"$l".txt
   		sort -n -k8 toplist_"$l".txt -o toplist_"$l".txt
   		sed -i "1s/^/Ligand_Name\tIntermolecular_Energy\t[vdW+Hbond+desolv]Energy\tElectrostatic_Energy\tTotal_Internal_Energy\tTorsional_Free_Energy\tUnbound_System's_Energy\tFree_Energy_of_Binding\tKI\tRMSD\n/" toplist_"$l".txt
   		rm list_"$l".txt	
		echo -e "\n\n\n------"$l" summary report------\n\n" >>"$VINA"/summary.txt
		topp=`expr "$top" + 1`; sed -n "1,"$topp"p" "$VINA"/"$l"/Results/sorted_"$l".txt >>"$VINA"/summary.txt	
		cd "$VINA/"$l"/docked_files/grid/"; ls -1U | parallel -j "$joobs" "rm {}"; cd ../; rmdir grid
   	done <protein_list.txt	
   	cd "$CONFIG"; rm protein_list.txt
	time=`date +"%c"`; echo -e "\n\n\nVirtual screening End time: "$time"\n\n" >>"$VINA"/summary.txt
   	echo -e "~~~~~~~~~~~~~~~~~~~~~~~Virutal screening for multiple protein Finished~~~~~~~~~~~~~~" >>"$VINA"/summary.txt
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Multiple protein Virtual screening using Autodock: Completed             +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Completed                          +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -e "~~~~~~Virutal screening for multiple protein Finished~~~~~"
	echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$VINA"/summary.txt
elif [ "$opt" == 5 ]
then
	##########################################################################################################
   	######			Virtual screening with AutoDockZn		     #############################
   	##########################################################################################################
	if [ ! -d "$LIGAND" ]
	then
   		##Setting path for the Ligand splitted database##
		echo -e "Enter the directory where ligands have been prepared\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" lig 
			if [ -n "$lig" ] 
			then
				spacecheck=`echo "$lig" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		LIGAND=`echo -e "$lig" | sed "s/\/$//"`
   		clear
   		cd "$LIGAND"
		ligtotal=`ls -1U | tee spacecheck.txt | wc -l`
		ligtotal=`expr "$ligtotal" - 1`
		ligform=`cat spacecheck.txt | grep "pdbqt"`
   		if [ -n "$ligform" ]
   		then
			echo -e "pdbqt file was found inside the directory\n\n"
   		else
			rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
   		fi 
		echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
	fi
	if [ -z "$atm" ]
	then
		####################################################################################################################
		echo -e "Enter \n[1] To provide atom types for preparing map files\n[2] To calculate atom types from the ligand directory"
		ii=1 
		while [ "$ii" -ge 0 ] 
		do 	
			read -ep ">>>" atm 
			if [ "$atm" == 1 ] 
			then
				clear
				echo -e "Enter the atom types seperated by comma\n For ex: HD,Br,A,C,OA"
				i=1 
				while [ "$i" -ge 0 ] 
				do 	
					read -ep ">>>" atomty 
					echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
					atomty=`echo "$atomty" | sed "s/,/\n/g"`
					b=`echo "$atomty" | wc -l`
					c=1
					for ff in $(echo "$atomty")
					do
						if [ "$c" -le "$b" ]
						then
							check=`grep "$ff" AD_atm_types.txt`
							if [ -n "$check" ]
							then
								c=`expr $c + 1`
							else
								echo -e "Unidentified atom type found!!. Please type again "
								wrongatm="YES" 
								i=`expr $i + 1` 
								break
							fi
						else
							break
						fi
					done
					if [ "$c" -gt "$b" ]; then clear; break; fi
				done
				if [ "$wrongatm" == "YES" ]
				then
					:
				else
					break			
				fi	
				atomtypes=`echo "$atomty"`
				echo -e "Atom types given: "$atomtypes""
				rm AD_atm_types.txt
				break 
			elif [ "$atm" == 2 ]
			then
				clear
				echo -e "Atom types calculation from directory selected" 
				break
			else
				echo -e "Error: empty return. Please type again " 
				ii=`expr $ii + 1` 
			fi 
		done
	fi
	if [ ! -d "$CONFIG" ]
	then
		##################################################################################################
	   	echo -e "Enter the directory containing prepared protein and configuration file\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" config 
			if [ -n "$config" ] 
			then
				spacecheck=`echo "$config" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	CONFIG=`echo "$config" | sed "s/\/$//"`
	   	clear
	   	cd "$CONFIG"
	   	refgpf=`ls *.gpf  2>/dev/null`
	   	refdpf=`ls *.dpf  2>/dev/null`
	   	if [ -n "$refgpf" ] && [ -n "$refdpf" ]
	   	then	
			fspace=`ls *.gpf | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.gpf | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
	   		refgpf=`ls *.gpf`
			fspace=`ls *.dpf | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.dpf | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
	   		refdpf=`ls *.dpf`
	   	else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "Reference gpf abd dpf files not found in the "$CONFIG"\n Please Check and start the process again\n\n"
			exit
	   	fi
	   	gpfname=`ls prepare_gpf4zn.py  2>/dev/null`
	   	pesudozinc=`ls zinc_pseudo.py  2>/dev/null`
	   	forcefield=`ls AD4Zn.dat`
	   	if [ -n "$gpfname" ] && [ -n "$pesudozinc" ] && [ -n "$forcefield" ]
	   	then	
			:
	   	else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "Please check prepare_gpf4zn.py,zinc_pseudo.py and AD4Zn.dat file in the "$CONFIG"\n These files were not found in the specified directory\n\n"
			exit
   		fi
   		protcheck=`ls *.pdbqt  2>/dev/null`
   		if [ -n "$protcheck" ]
   		then	
			fspace=`ls *.pdbqt | sed -n "/\s/p"` 
			if [ -n "$fspace" ]
			then 
				bspace=`ls *.pdbqt | sed "s/\s/_/g"`;  mv "$fspace" "$bspace"
			fi
   			proteinname=`ls *.pdbqt`
   		else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "Pdbqt file for protein was not found in the "$CONFIG"\n Please Check and start the process again\n\n"
			exit
   		fi
	fi
	if [ ! -d "$VINA" ]
	then
		echo -e "Enter the working directory\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" vin 
			if [ -n "$vin" ] 
			then
				spacecheck=`echo "$vin" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done	
	   	VINA=`echo "$vin" | sed "s/\/$//"`
	   	clear
	   	cd "$VINA"
	   	worktest=`ls`
	   	if [ -n "$worktest" ]
	   	then
			cd "$LIGAND"; rm spacecheck.txt
			echo -e ""$VINA" is not an empty directory"
			exit
	   	else 
			:
	   	fi
	fi
	if [ -z "$joobs" ]
	then
		njob=`nproc`
		echo -e ""$njob" number of processors detected in your system\n"$njob" number of jobs can be run in parallel at a time\n\n"
   		echo -e "Enter the number of jobs to be run in parallel : [0] to run as many parallel jobs as possible"
	   	i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" joobs 
			if [ -n "$joobs" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	clear
	fi
	if [ -z "$top" ]
	then
	   	echo -e "Enter the number of top ligands for which protein-ligand complex needed to be generated\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" top 
			if [ -n "$top" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
   	if [ "$skip" != "YES" ]; then echo -e "Please enter return to start the virtual screening process"
   	read -p ">>>" null
   	clear
	fi
   	echo -e "---------------------------------------------------------------\n-----------------Virtual screening Report Summary--------------\n---------------------------------------------------------------\nDirectory for ligand "$LIGAND"\nDirectory for protein and configuration file "$CONFIG"\nDirectory for working "$VINA"\nNumber of top ligands to be taken "$top"\n" >>"$VINA"/summary.txt
	time=`date +"%c"`; echo -e "\n\nVirtual screening start time: "$time"\n\n\n" >>"$VINA"/summary.txt
	## Space check and file renaming##
	cd "$LIGAND"
	spacecheck=`sed -n "/\s/p" spacecheck.txt`
	if [ -n "$spacecheck" ]
	then
		echo -e "~~Space detected in the ligand files~~~\nSpace will be replaced by _ in the filename"
		sed -n "/\s/p" spacecheck.txt >spacefiles.txt
		echo -n "
		#!/bin/bash
		bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
		mv \"\$1\" \"\$bspace\"" >rename.bash
		cat spacefiles.txt | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
		rm rename.bash spacefiles.txt
	else
		:
	fi
	rm spacecheck.txt
	#######################################
	### Atom types calculation###
	if [ "$atm" == 2 ]
	then
		cd "$VINA"; mkdir unidentified_atom_types_ligands; cd "$LIGAND"; 
		echo -e "Calculating atom types from the ligand directory"
		echo -n "
		#!/bin/bash
		for ff in \$(cat \"\$1\")
		do
			check=\`grep \"\$ff\" AD_atm_types.txt\`
			if [ -n \"\$check\" ]
			then
				echo \"\$ff\" >>log.txt
			else
				mv \"\$2\" "$VINA"/unidentified_atom_types_ligands/
				break
			fi
		done" >atomtype_check.bash
		echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Virtual screening using Autodockzn: Running...                           +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Running...                         +"; fi
		echo -e " + 	* Grid and Map files           : Waiting...                         +"
		echo -e " + 	* Parallel Docking             : Waiting...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "sed "/REMARK/d" {} | cut -c77- | sed "/^$/d" | sed "s/\s//g" | sort -u >log_{.}.txt; bash atomtype_check.bash log_{.}.txt {}; rm log_{.}.txt"
		cat log.txt | sort -u >atmtypes.txt
		rm atomtype_check.bash AD_atm_types.txt
		unidecheck=`ls -A "$VINA"/unidentified_atom_types_ligands/`
		if [ -n "$unidecheck" ]
		then
			:
		else
			cd "$VINA"; rmdir unidentified_atom_types_ligands
		fi
		cd "$LIGAND"
		atp=0
		while read -r l
		do
			atp="$atp,"$l""	
		done <atmtypes.txt
		atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
		rm log.txt atmtypes.txt
		echo "Atom types are : "$atomtypes"" >>"$VINA"/summary.txt
	fi
   	###Adding tetrahedral pseudo atom to the receptor#####
   	cd "$CONFIG"; mkdir import
   	echo -n "
	#!/bin/bash
	dlgcheck=\`grep \"autodock4: Unsuccessful Completion\" \"\$1\"\`
	if  [ -n \"\$dlgcheck\" ]
	then
		mv \"\$1\" "$VINA"/docked_files/dlg_error/
	else 
		FEB=\`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' \"\$1\" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print \$1}'\`
		echo -e \"\${1%.dlg}\\t\"\$FEB\"\" >>"$VINA"/Results/output.txt
		mv \"\$1\" "$VINA"/docked_files/dlg_files/
	fi" >feb.bash
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodockzn: Running...                           +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Running...                         +"
	echo -e " + 	* Parallel Docking             : Waiting...                         +"
	echo -e " + 	* Results analysis             : Waiting...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
   	"$MGLROOT"/bin/pythonsh zinc_pseudo.py -r "$protcheck" -o tz.pdbqt >>"$VINA"/grid_log.txt
   	mv tz.pdbqt ${protcheck%.pdbqt}_tz.pdbqt
   	protname=`ls *_tz.pdbqt`; cp "$PYCONFIG"/prepare_dpf42.py .
   	mv "$protname" prepare_gpf4zn.py prepare_dpf42.py "$refgpf" "$refdpf" AD4Zn.dat feb.bash import/
   	######################################################################
	cd $VINA; mkdir Results docked_files ; cd docked_files/ ; mkdir grid dlg_files dlg_error
   	cd "$LIGAND"
	echo -e "~~~~~~~~~~~Mapfiles generation on progress~~~~~~~~"
	cd "$VINA"/docked_files/grid/; 
	cp "$CONFIG"/import/*.* . ;
	"$MGLROOT"/bin/pythonsh prepare_gpf4zn.py -i "$refgpf" -r "$protname" -p ligand_types="$atomtypes" -o grid.gpf >>"$VINA"/grid_log.txt 
	autogrid4 -p grid.gpf -l grid.glg 2>>"$VINA"/grid_log.txt 
	glgcheck=`grep "autogrid4: Unsuccessful Completion" grid.glg`
	if [ -n "$glgcheck" ]
	then
		echo "Error occured during Grid file generation!! Process Terminated."
		exit
	fi
	cd "$LIGAND";
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodockzn: Running...                           +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Running...                         +"
	echo -e " + 	* Results analysis             : Waiting...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
	echo -e "~~~~~~~~~~~Running AutodockZn~~~~~~~~"
	ls -U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "cd "$VINA"/docked_files/grid/ ; cp "$LIGAND"/{} . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$refdpf" -r "$protname" -o {.}.dpf >>"$VINA"/dpf_log.txt; sed -i "s/extended/bound/g" {.}.dpf ; echo {} >>"$VINA"/log.txt ; autodock4 -p {.}.dpf -l {.}.dlg 2>>"$VINA"/log.txt ; bash feb.bash {.}.dlg ; rm {} {.}.dpf" 
	cd "$VINA"/docked_files/grid/ ; rm feb.bash
	dlg_error_check=`ls -A "$VINA"/docked_files/dlg_error/`
	if [ -n "$dlg_error_check" ]
	then
		:
	else
		cd "$VINA"/docked_files/;rmdir dlg_error
	fi
   	clear
   	######Result analysis####
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodockzn: Running...                           +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Running...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
   	cd "$VINA"/Results
   	sort -n -k2 output.txt -o sorted.txt
   	sed -n "1,"$top"p" sorted.txt | cut -f1 > list.txt
   	###Retreiving the top hit structures from the batch###
   	a=1
   	cd "$VINA"/Results; mkdir complex
   	while read -r l
   	do
		cp "$VINA"/docked_files/dlg_files/"$l".dlg "$VINA"/Results/complex 
   	done <list.txt
   	###PDB files from dlg####
   	cd "$CONFIG"/import ; cut -c-66 "$protname" >"$VINA"/Results/complex/${protname%_tz.pdbqt}.pdb;cd "$VINA"/Results/complex; mkdir dlg_files pdb_files best_cluster ;
   	for f in *.dlg
   	do
		grep "^DOCKED" "$f" | cut -c9- | cut -c-66 | sed '/ROOT/d;/ENDROOT/d;/BRANCH/d;/ENDBRANCH/d;/TORSDOF/d;s/ATOM\s\s/HETATM/g;s/<0>/LIG/g'> ${f%.dlg}.pdb # all porse pdb files
 		mv ${f%.dlg}.pdb pdb_files
		sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | cut -c-66 | sed 's/ATOM\s\s/HETATM/g;s/<0>/LIG/g' >${f%.dlg}_best.pdb #Best structure from the first cluster
		cat ${protname%_tz.pdbqt}.pdb ${f%.dlg}_best.pdb >best_cluster/${protname%_tz.pdbqt}_complex_with_${f%.dlg}.pdb; rm ${f%.dlg}_best.pdb #complex generation
		ONE=0;ONEA=0;ONEB=0;TWO=0;THREE=0;FOUR=0;FEB=0;KI=0;RMSD=0
		ONE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Intermolecular Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		ONEA=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/vdW + Hbond + desolv Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		ONEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Electrostatic Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		TWO=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Total Internal Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		THREE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Torsional Free Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		FOUR=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Unbound System/p' | cut -d'=' -f3 | awk '{print $1}'`
		FEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
		KI=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Inhibition Constant/p' | cut -d'=' -f2 | awk '{print $1$2}'`
		RMSD=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/RMSD from reference structure/p' | cut -d'=' -f2 | awk '{print $1$2}'`
		echo -e "${f%.dlg}\t"$ONE"\t"$ONEA"\t"$ONEB"\t"$TWO"\t"$THREE"\t"$FOUR"\t"$FEB"\t"$KI"\t"$RMSD"" >>"$VINA"/Results/toplist.txt 
		mv "$f" dlg_files
   	done
   	rm ${protname%_tz.pdbqt}.pdb
   	######Map files Generation for the top hits####
   	cd "$VINA"/Results/
   	while read -r l
   	do
		cd "$VINA"/Results/complex/dlg_files/; 
		cp "$LIGAND"/"$l".pdbqt .
   	done <list.txt
   	cd "$VINA"/Results/complex/dlg_files/
	#########################################
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodockzn: Running...                           +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Running...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -e "~~~~~~~~~~~Repreparing mapfiles for tophits~~~~~~~~"
   	ls -1U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "mkdir {.} ; cd {.} ; cp ../{} . ; cp "$VINA"/docked_files/grid/*.* . ; mv ../{.}.dlg . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$refdpf" -r "$protname" -o {.}.dpf >>dpf_log.txt; rm dpf_log.txt ; sed -i "s/extended/bound/g" {.}.dpf; rm prepare_dpf42.py prepare_gpf4zn.py AD4Zn.dat"
   	clear
   	###############
   	rm *.pdbqt
   	cd "$VINA"/Results/; rm output.txt
   	sed -i "1s/^/Ligand_Name\tDocking_score\n/" sorted.txt
   	sort -n -k8 toplist.txt -o toplist.txt
   	sed -i "1s/^/Ligand_Name\tIntermolecular_Energy\t[vdW+Hbond+desolv]Energy\tElectrostatic_Energy\tTotal_Internal_Energy\tTorsional_Free_Energy\tUnbound_System's_Energy\tFree_Energy_of_Binding\tKI\tRMSD\n/" toplist.txt
   	rm list.txt
   	cd "$VINA"; rm grid_log.txt dpf_log.txt log.txt; cd "$VINA/docked_files/grid/"; ls -1U | parallel -j "$joobs" "rm {}"; cd ../; rmdir grid
   	cd "$CONFIG"/import; mv *.* ../; cd ../; rmdir import ; rm feb.bash "$protname" prepare_dpf42.py
	echo -e "\n\nThe best compounds and its energy values are" >>"$VINA"/summary.txt
	topp=`expr "$top" + 1`; sed -n "1,"$topp"p" "$VINA"/Results/sorted.txt >>"$VINA"/summary.txt
   	time=`date +"%c"`; echo -e "\n\n\nVirtual screening End time: "$time"\n\n" >>"$VINA"/summary.txt
   	echo -e "~~~~~~~~~~~~Virtual Screening using Autodock Finished~~~~~~~~~~~~~~~~~~~~" >>"$VINA"/summary.txt
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Virtual screening using Autodockzn: Completed                            +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Completed                          +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "The best compounds and its energy values are"
	topp=`expr "$top" + 1`; sed -n "1,"$top"p" "$VINA"/Results/sorted.txt
   	echo -e "~~~~~~~~~~~~Virtual Screening using Autodock Finished~~~~~~~~~~~~~~~~~~~~"
	echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$VINA"/summary.txt
elif [ "$opt" == 6 ]
then
	##########################################################################################################
   	######	Multiple Protein Virtual screening with AutoDockZn              ##################################
   	##########################################################################################################
	if [ ! -d "$LIGAND" ]
	then
	   	##Setting path for the Ligand splitted database##
		echo -e "Enter the directory where ligands have been prepared\n"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" lig 
			if [ -n "$lig" ] 
			then 
				spacecheck=`echo "$lig" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	LIGAND=`echo -e "$lig" | sed "s/\/$//"`
	   	clear
	   	cd "$LIGAND"
		ligtotal=`ls -1U | tee spacecheck.txt | wc -l`
		ligtotal=`expr "$ligtotal" - 1`
		ligform=`cat spacecheck.txt | grep "pdbqt"`
	   	if [ -n "$ligform" ]
	   	then
			echo -e "pdbqt file was found inside the directory\n\n"
	   	else
			cd "$LIGAND"; rm spacecheck.txt
			echo -e "No pdbqt file found inside the directory"
			exit
	   	fi 
	   	echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
	fi
	if [ -z "$atm" ]
	then
		####################################################################################################################
		echo -e "Enter \n[1] To provide atom types for preparing map files\n[2] To calculate atom types from the ligand directory"
		ii=1 
		while [ "$ii" -ge 0 ] 
		do 	
			read -ep ">>>" atm 
			if [ "$atm" == 1 ] 
			then
				clear
				echo -e "Enter the atom types seperated by comma\n For ex: HD,Br,A,C,OA"
				i=1 
				while [ "$i" -ge 0 ] 
				do 	
					read -ep ">>>" atomty 
					echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
					atomty=`echo "$atomty" | sed "s/,/\n/g"`
					b=`echo "$atomty" | wc -l`
					c=1
					for ff in $(echo "$atomty")
					do
						if [ "$c" -ge "$b" ]
						then
							check=`grep "$ff" AD_atm_types.txt`
							if [ -n "$check" ]
							then
								c=`expr $c + 1`
							else
								echo -e "Unidentified atom type found!!. Please type again "
								wrongatm="YES" 
								i=`expr $i + 1` 
								break
							fi
						else
							break
						fi
					done
					if [ "$c" -gt "$b" ]; then clear; break; fi
				done
				if [ "$wrongatm" -ge "YES" ]
				then
					:
				else
					break			
				fi	
				atomtypes=`echo "$atomty"`
				echo -e "Atom types given: "$atomtypes""
				rm AD_atm_types.txt
				break 
			elif [ "$atm" -ge 2 ]
			then
				clear
				echo -e "Atom types calculation from directory selected" 
				break
			else
				echo -e "Error: empty return. Please type again " 
				ii=`expr $ii + 1` 
			fi 
		done
	fi
	if [ ! -d "$CONFIG" ]
	then
		echo -e "Enter the directory containing prepared protein and configuration file\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" config 
			if [ -n "$config" ] 
			then 
				spacecheck=`echo "$config" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	CONFIG=`echo "$config" | sed "s/\/$//"`
	   	clear
	   	cd "$CONFIG"
		ls -1 >files.txt
		dirspacecheck=`cat files.txt | sed -n "/\s/p"`
		if [ -n "$dirspacecheck" ]
		then
			sed -n "/\s/p" files.txt >spacefiles.txt
			echo -n "
			#!/bin/bash
			bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
			mv \"\$1\" \"\$bspace\"" >rename.bash
			cat spacefiles.txt | parallel -j 0 --no-notice bash rename.bash {}
			rm rename.bash spacefiles.txt
		fi
		rm files.txt
		ls -1 *.pdbqt >protein_list.txt
		sed -i "s/.pdbqt//g" protein_list.txt
		while read -r l
		do
			refgpf=`ls "$l".gpf 2>/dev/null`
			refdpf=`ls "$l".dpf 2>/dev/null`
			if [ -n "$refgpf" ] && [ -n "$refdpf" ]
			then
				:
			else
				cd "$LIGAND"; rm spacecheck.txt; cd "$CONFIG"; rm protein_list.txt
				echo -e "Reference gpf abd dpf files not found in the "$CONFIG"/"$l"\n Please Check and start the process again\n\n"
				exit
			
			fi
		done <protein_list.txt 
		clear
	   	gpfname=`ls prepare_gpf4zn.py  2>/dev/null`
	   	pesudozinc=`ls zinc_pseudo.py  2>/dev/null`
	   	forcefield=`ls AD4Zn.dat  2>/dev/null`
	   	if [ -n "$gpfname" ] && [ -n "$pesudozinc" ] && [ -n "$forcefield" ]
	   	then	
			:
	   	else
			cd "$LIGAND"; rm spacecheck.txt; cd "$CONFIG"; rm protein_list.txt
			echo -e "Please check prepare_gpf4zn.py, zinc_pseudo.py and AD4Zn.dat file in the "$CONFIG"\n These files were not found in the specified directory\n\n"
			exit
	   	fi
	fi
	if [ ! -d "$VINA" ]
	then
		echo -e "Enter the working directory\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 	
			read -ep ">>>" vin 
			if [ -n "$vin" ] 
			then 
				spacecheck=`echo "$vin" | sed -n "/\s/p"`
				if [ -n "$spacecheck" ]
				then
					cd "$LIGAND"; rm spacecheck.txt; cd "$CONFIG"; rm protein_list.txt
					echo -e "Space found between directory path.\nPlease remove the space in the directory path and restart the process again"
					exit
				fi
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	VINA=`echo "$vin" | sed "s/\/$//"`
	   	clear
	   	cd "$VINA"
   		worktest=`ls`
   		if [ -n "$worktest" ]
   		then
			cd "$LIGAND"; rm spacecheck.txt; cd "$CONFIG"; rm protein_list.txt
			echo -e ""$VINA" is not an empty directory"
			exit
   		else 
			:
   		fi
	fi
	if [ -z "$joobs" ]
	then
		njob=`nproc`
		echo -e ""$njob" number of processors detected in your system\n"$njob" number of jobs can be run in parallel at a time\n\n"
   		echo -e "Enter the number of jobs to be run in parallel : [0] to run as many parallel jobs as possible"
   		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" joobs 
			if [ -n "$joobs" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
   		clear
	fi
	if [ -z "$top" ]
	then
	   	echo -e "Enter the number of top ligands for each protein-ligand complex needed to be generated\n"
	   	i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" top 
			if [ -n "$top" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	   	clear
	fi
   	if [ "$skip" != "YES" ]; then echo -e "Please enter return to start the virtual screening process"
   	read -p ">>>" null
   	clear
	fi
   	echo -e "\n---------------------------------------------------------------\n-----------------Virtual screening Report Summary--------------\n---------------------------------------------------------------\nDirectory for ligand "$LIGAND"\nDirectory for protein and configuration file "$CONFIG"\nDirectory for working "$VINA"\nNumber of top ligands to be taken "$top"\n" >>"$VINA"/summary.txt
   	echo -e "List of proteins:" >>"$VINA"/summary.txt
	## Space check and file renaming##
	cd "$LIGAND"
	spacecheck=`sed -n "/\s/p" spacecheck.txt`
	if [ -n "$spacecheck" ]
	then
		echo -e "~~Space detected in the ligand files~~~\nSpace will be replaced by _ in the filename"
		sed -n "/\s/p" spacecheck.txt >spacefiles.txt
		echo -n "
		#!/bin/bash
		bspace=\`echo \"\$1\" | sed \"s/\s/_/g\"\` 
		mv \"\$1\" \"\$bspace\"" >rename.bash
		cat spacefiles.txt | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
		rm rename.bash spacefiles.txt
	else
		:
	fi
	rm spacecheck.txt
	#######################################
	### Atom types calculation###
	if [ "$atm" == 2 ]
	then
		cd "$VINA"; mkdir unidentified_atom_types_ligands; cd "$LIGAND"; 
		echo -e "Calculating atom types from the ligand directory"
		echo -n "
		#!/bin/bash
		for ff in \$(cat \"\$1\")
		do
			check=\`grep \"\$ff\" AD_atm_types.txt\`
			if [ -n \"\$check\" ]
			then
				echo \"\$ff\" >>log.txt
			else
				mv \"\$2\" "$VINA"/unidentified_atom_types_ligands/
				break
			fi
		done" >atomtype_check.bash
		echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using AutodockZn: Running...          +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Running...                         +"; fi
		echo -e " + 	* Grid and Map files           : Waiting...                         +"
		echo -e " + 	* Parallel Docking             : Waiting...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "sed "/REMARK/d" {} | cut -c77- | sed "/^$/d" | sed "s/\s//g" | sort -u >log_{.}.txt; bash atomtype_check.bash log_{.}.txt {}; rm log_{.}.txt"
		cat log.txt | sort -u >atmtypes.txt
		rm atomtype_check.bash AD_atm_types.txt
		unidecheck=`ls -A "$VINA"/unidentified_atom_types_ligands/`
		if [ -n "$unidecheck" ]
		then
			:
		else
			cd "$VINA"; rmdir unidentified_atom_types_ligands
		fi
		cd "$LIGAND"
		atp=0
		while read -r l
		do
			atp="$atp,"$l""	
		done <atmtypes.txt
		atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
		rm log.txt atmtypes.txt
		echo "Atom types are : "$atomtypes"" >>"$VINA"/summary.txt
		clear
	fi
   	cd "$VINA"; mkdir Combined_Results 
   	cd "$CONFIG" ; cat protein_list.txt >>"$VINA"/summary.txt
	mkdir import ;
	cp "$PYCONFIG"/prepare_dpf42.py .
	echo -n "
	#!/bin/bash
	l=\"\$2\"
	dlgcheck=\`grep \"autodock4: Unsuccessful Completion\" \"\$1\"\`
	if  [ -n \"\$dlgcheck\" ]
	then
		mv \"\$1\" "$VINA"/\"\$l\"/docked_files/dlg_error/
	else 
		FEB=\`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' \"\$1\" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print \$1}'\`
		echo -e \"\${1%.dlg}\\t\"\$FEB\"\" >>"$VINA"/\"\$l\"/Results/output_\"\$l\".txt
		mv \"\$1\" "$VINA"/\"\$l\"/docked_files/dlg_files/
	fi" >feb.bash 
	mv prepare_gpf4zn.py prepare_dpf42.py AD4Zn.dat feb.bash import/
   	time=`date +"%c"`; echo -e "\n\nVirtual screening Start time: "$time"" >>"$VINA"/summary.txt
   	while read -r l
   	do
		cd "$VINA"/; mkdir "$l";cd "$l"/; mkdir docked_files Results ; cd docked_files/ ; mkdir grid dlg_files dlg_error
		###Adding tetrahedral pseudo atom to the receptor#####
		cd "$CONFIG"
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using AutodockZn: Running...          +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Running...                         +"
		echo -e " + 	* Parallel Docking             : Waiting...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
   		"$MGLROOT"/bin/pythonsh zinc_pseudo.py -r "$l".pdbqt -o tz_"$l".pdbqt >>log.txt
		rm log.txt
   		mv tz_"$l".pdbqt "$l".gpf "$l".dpf import/
		###############################################################
		cd $LIGAND
		echo -e "~~~~~~~~~~~Mapfiles generation for "$l" on progress~~~~~~~~"
		cd "$VINA"/"$l"/docked_files/grid/; 
		cp "$CONFIG"/import/*.* .  
		"$MGLROOT"/bin/pythonsh prepare_gpf4zn.py -i "$l".gpf -r tz_"$l".pdbqt -p ligand_types="$atomtypes" -o grid.gpf >>"$VINA"/grid_log.txt 
		autogrid4 -p grid.gpf -l grid.glg >>"$VINA"/grid_log.txt 
		glgcheck=`grep "autogrid4: Unsuccessful Completion" grid.glg`
		if [ -n "$glgcheck" ]
		then
			echo "Error occured during Grid file generation!! Process Terminated."
			exit
		fi	
		cd "$LIGAND";
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using AutodockZn: Running...          +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Completed                          +"
		echo -e " + 	* Parallel Docking             : Running...                         +"
		echo -e " + 	* Results analysis             : Waiting...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		echo -e "~~~~~Running Autodock for "$l"~~~~~~\n\n"
		ls -1U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "cd "$VINA"/"$l"/docked_files/grid/ ; cp "$LIGAND"/{} . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$l".dpf -r tz_"$l".pdbqt -o {.}.dpf >>"$VINA"/dpf_log.txt; sed -i "s/extended/bound/g" {.}.dpf ; echo {} >>"$VINA"/log.txt ; autodock4 -p {.}.dpf -l {.}.dlg 2>>"$VINA"/log.txt ; bash feb.bash {.}.dlg "$l" ; rm {} {.}.dpf" 
		dlg_error_check=`ls -A "$VINA"/"$l"/docked_files/dlg_error/`
		if [ -n "$dlg_error_check" ]
		then
			:
		else
			cd "$VINA"/"$l"/docked_files/;rmdir dlg_error
		fi
		cd "$CONFIG"/import/ ; mv "$l".gpf "$l".dpf tz_"$l".pdbqt ../
   	done <protein_list.txt
	###################################################
	### Combined result parsing####
	cd "$LIGAND"; cp "$CONFIG"/protein_list.txt .
	echo -n "
	#!/bin/bash
	echo -e "\"\$1\"" >>temp_\"\$1\".txt
	while read -r l
	do
		value=\`grep \"\$1\" "$VINA"/\"\$l\"/Results/output_\"\$l\".txt | cut -f2\` 2>/dev/null
		if [ -z \"\$value\" ]
		then
			value=0
		fi 
		sed -i \"1s/$/\t\"\$value\"/\" temp_\"\$1\".txt
	done <protein_list.txt
	avg=\`sed -n 1p temp_\"\$1\".txt | cut -f2- | awk '{ for (i=1;i<=NF;i++) {sum=sum+\$i;} avg=sum/NF;}{print avg;}'\`
	sd=\`sed -n 1p temp_\"\$1\".txt | cut -f2- | awk '{ for (i=1;i<=NF;i++) {sum=sum+\$i} avg=sum/NF} {if (NF<=30) { for (i=1;i<=NF;i++) {sa=sa+(\$i-avg)^2;} sd=sqrt(sa/(NF-1));} else {for (i=1;i<=NF;i++) {sa=sa+(\$i-avg)^2;} sd=sqrt(sa/NF);}} {print sd;}'\`	
	sed -i \"1s/$/\t\"\$avg\"\t\"\$sd\"/\" temp_\"\$1\".txt
	insert=\`sed -n 1p temp_\"\$1\".txt\`
	echo -e \"\$insert\" >>"$VINA"/Combined_Results/combined_output.txt
	rm temp_\"\$1\".txt " >mdfeb.bash
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Multiple protein Virtual screening using AutodockZn: Running...          +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Running...                         +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n"
	echo -e "~~~Combined Results Parsing~~~"
	ls -1U | grep "pdbqt" | parallel -j "$joobs" --no-notice --eta "bash mdfeb.bash {.}"
	avg=`cat protein_list.txt | wc -l`
	avg=`expr "$avg" + 2`
	rm mdfeb.bash protein_list.txt
	cd "$VINA"/Combined_Results/
	sort -n -k"$avg" combined_output.txt >combined_sorted.txt
	sed -i "1s/^/Ligand_Name\n/" "$VINA"/Combined_Results/combined_sorted.txt
	rm combined_output.txt
	cd "$CONFIG"
	while read -r l
	do
		sed -i "1s/$/\t"$l"/" "$VINA"/Combined_Results/combined_sorted.txt
	done <protein_list.txt
	sed -i "1s/$/\tAverage\tSD/" "$VINA"/Combined_Results/combined_sorted.txt
   	cd $VINA; rm grid_log.txt dpf_log.txt log.txt
   	########Complex generation for individual protein top complex###############
   	cd "$CONFIG"
   	while read -r l
   	do
		clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Virtual screening:                                                +"
		echo -e " + -----------------------                                                  +"
		echo -e " + Multiple protein Virtual screening using AutodockZn: Running...          +"
		if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
		echo -e " + 	* Grid and Map files           : Completed                          +"
		echo -e " + 	* Parallel Docking             : Completed                          +"
		echo -e " + 	* Results analysis             : Running...                         +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n"
		cd "$CONFIG"/
		protname=`ls tz_"$l".pdbqt`
		######Result analysis####
		cd "$VINA"/"$l"/Results
		sort -n -k2 output_"$l".txt -o sorted_"$l".txt
		sed -n "1,"$top"p" sorted_"$l".txt | cut -f1 >list_"$l".txt
		###Retreiving the top hit structures from the batch###
		a=1
		cd "$VINA"/"$l"/Results; mkdir complex
		while read -r zz
		do
			cp "$VINA"/"$l"/docked_files/dlg_files/"$zz".dlg "$VINA"/"$l"/Results/complex/ 	
		done <list_"$l".txt
		###PDB files from dlg####
		cut -c-66 "$CONFIG"/tz_"$l".pdbqt >$VINA/"$l"/Results/complex/"$l".pdb;cd $VINA/"$l"/Results/complex; mkdir dlg_files pdb_files best_cluster ;
		for f in *.dlg
		do
			grep "^DOCKED" $f | cut -c9- | cut -c-66 | sed '/ROOT/d;/ENDROOT/d;/BRANCH/d;/ENDBRANCH/d;/TORSDOF/d;s/ATOM\s\s/HETATM/g;s/<0>/LIG/g'> ${f%.dlg}.pdb # all porse pdb files
			mv ${f%.dlg}.pdb pdb_files
			sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | cut -c-66 | sed 's/ATOM\s\s/HETATM/g;s/<0>/LIG/g' >${f%.dlg}_best.pdb #Best structure from the first cluster
			cat "$l".pdb ${f%.dlg}_best.pdb >best_cluster/"$l"_complex_with_${f%.dlg}.pdb; rm ${f%.dlg}_best.pdb #complex generation
			ONE=0;ONEA=0;ONEB=0;TWO=0;THREE=0;FOUR=0;FEB=0;KI=0;RMSD=0
			ONE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Intermolecular Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			ONEA=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/vdW + Hbond + desolv Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			ONEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Electrostatic Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			TWO=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Final Total Internal Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			THREE=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Torsional Free Energy/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			FOUR=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Unbound System/p' | cut -d'=' -f3 | awk '{print $1}'`
			FEB=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Free Energy of Binding/p' | cut -d'=' -f2 | cut -d'[' -f1 | awk '{print $1}'`
			KI=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/Estimated Inhibition Constant/p' | cut -d'=' -f2 | awk '{print $1$2}'`
			RMSD=`sed -n '/LOWEST ENERGY DOCKED CONFORMATION from EACH CLUSTER/,/ENDMDL/p' "$f" | sed -n '/MODEL/,/ENDMDL/p' | sed -n '/RMSD from reference structure/p' | cut -d'=' -f2 | awk '{print $1$2}'`
			echo -e "${f%.dlg}\t$ONE\t$ONEA\t$ONEB\t$TWO\t$THREE\t$FOUR\t$FEB\t$KI\t$RMSD" >>"$VINA"/"$l"/Results/toplist_"$l".txt 
			mv $f dlg_files
		done
		rm "$l".pdb
   		######Map files Generation for the top hits####
		cd $VINA/"$l"/Results/
		while read -r zz
		do
			cd $VINA/"$l"/Results/complex/dlg_files/; 
			cp $LIGAND/"$zz".pdbqt .
   		done <list_"$l".txt
                cd $VINA/"$l"/Results/complex/dlg_files/
		###################################################
		echo -e "~~~~~~~~~~~Repreparing mapfiles for tophits of "$l"~~~~~~~~"
		ls -1U | grep 'pdbqt' | parallel -j "$joobs" --no-notice --eta "mkdir {.} ; cd {.} ; cp ../{} . ; cp "$VINA"/"$l"/docked_files/grid/*.* . ; mv ../{.}.dlg . ; "$MGLROOT"/bin/pythonsh prepare_dpf42.py -l {.}.pdbqt -i "$l".dpf -r "$l".pdbqt -o {.}.dpf >>dpf_log.txt; rm dpf_log.txt prepare_gpf4zn.py prepare_dpf42.py AD4Zn.dat feb.bash ; sed -i "s/extended/bound/g" {.}.dpf" 
  		clear
   		###############
   		rm *.pdbqt
   		cd $VINA/"$l"/Results/; rm output_"$l".txt
   		sed -i "1s/^/Ligand_Name\tDocking_score\n/" sorted_"$l".txt
   		sort -n -k8 toplist_"$l".txt -o toplist_"$l".txt
   		sed -i "1s/^/Ligand_Name\tIntermolecular_Energy\t[vdW+Hbond+desolv]Energy\tElectrostatic_Energy\tTotal_Internal_Energy\tTorsional_Free_Energy\tUnbound_System's_Energy\tFree_Energy_of_Binding\tKI\tRMSD\n/" toplist_"$l".txt
   		rm list_"$l".txt	
		cd "$VINA/"$l"/docked_files/grid/"; ls -1U | parallel -j "$joobs" "rm {}"; cd ../; rmdir grid
		echo -e "\n\n\n------"$l" summary report------\n\n" >>"$VINA"/summary.txt
		topp=`expr "$top" + 1`; sed -n "1,"$topp"p" "$VINA"/"$l"/Results/sorted_"$l".txt >>"$VINA"/summary.txt	
   	done <protein_list.txt	
   	cd "$CONFIG"; 
  	cd "$CONFIG"/import/; rm prepare_dpf42.py feb.bash; mv prepare_gpf4zn.py AD4Zn.dat ../; cd ../; rmdir import; rm protein_list.txt tz_*.pdbqt
   	time=`date +"%c"`; echo -e "\nVirtual screening End time: "$time"\n\n" >>"$VINA"/summary.txt
   	echo -e "~~~~~~~~~~~~~~~~~~~~~~~Virutal screening for multiple protein Finished~~~~~~~~~~~~~~" >>"$VINA"/summary.txt
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Virtual screening:                                                +"
	echo -e " + -----------------------                                                  +"
	echo -e " + Multiple protein Virtual screening using AutodockZn: Completed           +"
	if [ "$atm" == 2 ]; then echo -e " + 	* Ligand atom types calculation: Completed                          +"; fi
	echo -e " + 	* Grid and Map files           : Completed                          +"
	echo -e " + 	* Parallel Docking             : Completed                          +"
	echo -e " + 	* Results analysis             : Completed                          +"
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -e "~~~~~~Virutal screening for multiple protein Finished~~~~~"
	echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$VINA"/summary.txt
fi
