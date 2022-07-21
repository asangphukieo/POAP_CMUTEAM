#!/bin/bash
###########################################################
#	variables and there options
#	three=1		#To convert 2D ---> 3D
#	three=2 	#To skipt 2D ---> 3D conversion
#	cnf=0 		# To skip conformer generation
#       cnf=1 		#Conformer generation using Genetic Algorithm
#       cnf=2 		#Conformer generation using Random Rotor
#       cnf=3 		#Conformer generation using Weighted Rotor
#       cnf=4 		#Conformer generation using Obconformer
#       cnf=5 		#Conformer generation using Confab
#	cnfmin="YES" 	#To perform minimization
#	kfinal=1 	#Final output format sdf
#	kfinal=2 	#Final output format mol2
#	kfinal=3 	#final output format pdbqt
#	pypdbqt="YES" 	#pdbqt conversion using prepare_ligand4.py
#	obpdbqt="YES" 	#pdbqt conversion using obabel
babell=`command -v obabel`
obconf=`command -v obconformer`
paral=`command -v parallel`
mgroot=`command -v pythonsh`
prepare_lig=`command -v prepare_ligand4.py`
confabcheck=`obabel -L confab`
if [ -n "$babell" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:obabel was not found\n~~~~~~~~~~~Please Install Openbabel~~~~~~~~~~~~~~~~~\n\n[Ensure it should globally call when tried in terminal](File location to call globally/usr/local/bin)\n"
	exit
fi
if [ -n "$mgroot" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:MGLROOT directory was not found\n~~~~~~~~~~~Please Install MGLTools and set the path to the installed directory~~~~~~~~~~~~~~~~~\n\n[Ensure it should globally call when tried in terminal]\n"
	exit
fi
if [ -n "$prepare_lig" ]
then
	CONFIG=""$MGLROOT"/MGLToolsPckgs/AutoDockTools/Utilities24/"
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:preapre_ligand4.py was not found inside MGLROOT directory\n~~~~~~~~~~~Please make sure the availability of tat script in this directory "$MGLROOT"/MGLToolsPckgs/AutoDockTools/Utilities24/\n"
	exit
fi
if [ -n "$paral" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:GNU parallel was not found\n~~~~~~~~~~~Please Install GNU Parallel~~~~~~~~~~~~~~~~~\n\n[Ensure it should globally call when tried in terminal](File location to call globally/usr/local/bin)\n"
	exit
fi
if [ -n "$obconf" ]
then
	:
else
	echo -e "~~~~~~Error~~~~~~~~~\n\nNote:Obconformer was not found\n~~~~~~~~~~~Please Install Openbabel~~~~~~~~~~~~~~~~~\n\n[Ensure it should globally call when tried in terminal](File location to call globally/usr/local/bin)\n"
	exit
fi


echo 'YYY'
oconfab=`obabel -L confab | grep "\-\-confab"`
if [ -n "$oconfab" ]
then
	confab="YES"
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
			-s|--s) echo -e "
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

POAP - Ligand Preparation Module:
--------------------------------\n" 
				;;
			-h|--h) more <<EOF
           +++++++++++++++++++++++++++++++++++++++++++
          ++   ######   ######   ######   ######   ++  
         ++   #    #   #    #   #    #   #    #   ++
        ++   ######   #    #   ######   ######   ++
       ++   #        #    #   #    #   #        ++
      ++   #        ######   #    #   #        ++
     +++++++++++++++++++++++++++++++++++++++++++
~~~~~~~~~~~~ Help File ~~~~~~~~~~~~
-s, -s	to run in Interactive mode
-h, -help  To print help file
-l, -ligand  To specify ligand directory 
	For example [ script -l /home/bioinfo/ligands/ ]
-ff, -forcefield  To select forcefield.
	The available forcefields are:
	UFF
	GAFF
	Ghemical
	MMFF94
	MMFF94s
	For example [ script -l /home/bioinfo/ligands/ -ff MMFF94]
-t, -T  To specify 3D conversion process and speed
	Available speed:
	Fastest
	Fast
	med or medium
	slow
	slowest
	For example [ script -l /home/bioinfo/ligands/ -t med ]
	
-c, -C  [ -c <algorithm> <number of conformers> <best(or)all> ]
	To specify the conformer algorithm and number of conformers to be 
	generated and to specify whether to proceed best structure alone or to 
	retain all the conformers structure generated(this is valid for only
	Genetic Algorithm, Random rotor and Weighted Rotor based conformational
	search)
	Available conformer search:
	Genetic algorithm (GA)
	Random Rotor Search (RA)
	Weighted Rotor Search (WR)
	Obconformer(OB)
	Confab(CF)
	For example [ script -l /home/bioinfo/ligands/ -c WR 50 best ]
-m, -M  [ -m <Minimization algorithm> <Number of steps> ]
	To specify the minimization algorithm and number of steps 
	cg - conjugate gradient
	sd - steepest descent algorithm
	Other cut off values are default
	For example [ script -l /home/bioinfo/ligands/ -m cg 5000 ]
-pdbqt, -PDBQT [ -pdbqt <py/ob> ]
	To specify direct pdbqt conversion
	py - conversion using prepare_ligand4.py script
	ob - conversion using openbabel
	For example [ script -l /home/bioinfo/ligands/ -pdbqt py ]
-o, -O  [ -o <sdf/mol2/pdbqt> ]
	For example [ script -o sdf ]
	For pdbqt conversion specify py/ob followed by format to use 
	prepare_ligand4.py or obabel to perform pdbqt conversion
	-o pdbqt <py/ob>
	For example [ script -l /home/bioinfo/igands/ -o pdbqt py ]
-tcms, -TCMS  To perform 3D conversion, conformational search, minimization 
	and final out in sdf file format
	T- 3D conversion with medium speed
	C- conformer generation using weighted rotor of 50 conformers retaining 
	   the best structure alone
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	S- Final output in sdf file format
	For example [ script -l /home/bioinfo/ligands/ -tcms ]
-tcmm, -TCMM  To perform 3D conversion, conformational search, minimization and 
	final out in mol2 file format
	T- 3D conversion with medium speed
	C- conformer generation using weighted rotor of 50 conformers retaining 
	   the best structure alone
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	M- Final output in mol2 file format
	For example [ script -l /home/bioinfo/ligands/ -tcmm ]
-tcmp, -TCMP  To perform 3D conversion, conformational search, minimization and 
	final out in pdbqt file format
	T- 3D conversion with medium speed
	C- conformer generation using weighted rotor of 50 conformers retaining 
	   the best structure alone
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	P- Final output in pdbqt file format using prepare_ligand4.py script
	For example [ script -l /home/bioinfo/ligands/ -tcmp ]
-cms, -CMS  To perform conformational search, minimization and final out in sdf 
	file format
	C- conformer generation using weighted rotor of 50 conformers retaining 
	   the best structure alone
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	S- Final output in sdf file format
	For example [ script -l /home/bioinfo/ligands/ -cms ]
-cmm, -CMM  To perform conformational search, minimization and final out in mol2 
	file format
	C- conformer generation using weighted rotor of 50 conformers retaining 
	   the best structure alone
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	M- Final output in mol2 file format
	For example [ script -l /home/bioinfo/ligands/ -cmm ]
-cmp, -CMP  To perform conformational search, minimization and final out in pdbqt 
	file format
	C- conformer generation using weighted rotor of 50 conformers retaining 
	   the best structure alone
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	P- Final output in pdbqt file format using prepare_ligand4.py script
	For example [ script -l /home/bioinfo/ligands/ -cmp ]
-ms, -MS  To perform minimization and final out in sdf file format
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	S- Final output in sdf file format
	For example [ script -l /home/bioinfo/ligands/ -ms ]
-mm, -MM  To perform minimization and final out in mol2 file format
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	M- Final output in mol2 file format
	For example [ script -l /home/bioinfo/ligands/ -mm ]
-mp, -MP  To perform minimization and final out in pdbqt file format
	M- Minimisation using conjugate gradient with 2500 steps and other 
	   default values.
	P- Final output in pdbqt file format using prepare_ligand4.py script
	For example [ script -l /home/bioinfo/ligands/ -mp ]
-j, -Jobs  To specify number of jobs to run in parallel
	[ -j 8 ] To run 8 jobs in parallel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~End of Help File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF
				exit
				;;
			-l|-ligand)
				lig="$2"
				if [ -n "$lig" ] 
				then
					spacecheck=`echo "$lig" | sed -n "/\s/p"`
					if [ -n "$spacecheck" ]
					then
						echo -e "Space found between directory path.\nPlease remove the space in the directory naming and restart the process again"
						exit
					fi  
				else
					echo -e "Error: empty return. Please type again"
					exit 
				fi
				LIGAND=`echo -e "$lig" | sed "s/\/$//"`
				skip="YES"
				clear
				shift
				;;
			-ff|-forcefield)
				f="$2"
				if [ "$f" == "Gaff" ] || [ "$f" == "GAFF" ] || [ "$f" == "gaff" ]   
				then 
					forcefield="Gaff"				 
				elif [ "$f" == "Ghemical" ] || [ "$f" == "GHEMICAL" ] || [ "$f" == "ghemical" ]
				then
					forcefield="Ghemical"
				elif [ "$f" == "MMFF94" ] || [ "$f" == "mmff94" ]  
				then 
					forcefield="MMFF94"				
				elif [ "$f" == "MMFF94s" ] || [ "$f" == "mmff94s" ]  
				then
					forcefield="MMFF94s"				
				elif [ "$f" == "UFF" ] || [ "$f" == "uff" ]  
				then
					forcefield="UFF"
				else 
					echo -e "Error: Invalid selection. Please type again " 
					exit
				fi
				skip="YES"
				shift
				;;
	   		-tcms|-TCMS)
				option="tcms"
				three=1
				cnf=3		#Conformation Default kept modify to keep other conformation method as default
				nconf=50
				bestconf="YES"
				cnfmin="YES"
				kfinal=1
				skip="YES"
				;;
	   		-tcmm|-TCMM)
				option="tcmm"
				three=1
				cnf=3		#Conformation Default kept modify to keep other conformation method as default
				nconf=50
				bestconf="YES"
				cnfmin="YES"
				kfinal=2
				skip="YES"
				;;
			-tcmp|-TCMP)
				option="tcmp"
				three=1
				cnf=3		#Conformation Default kept modify to keep other conformation method as default
				nconf=50
				bestconf="YES"
				cnfmin="YES"
				kfinal=3
				pypdbqt="YES"	#Pdbqt output Default kept modify to obpdbqt="YES" for converting pdbqt using obabel 
				skip="YES"
				;;
			-tms|-TMS)
				cnf=0
				option="tms"
				three=1
				cnfmin="YES"
				kfinal=1
				skip="YES"
				;;
	   		-tmm|-TMM)
				cnf=0
				option="tmm"
				three=1
				cnfmin="YES"
				kfinal=2
				skip="YES"
				;;
			-tmp|-TMP)
				cnf=0
				option="tmp"
				three=1
				cnfmin="YES"
				kfinal=3
				pypdbqt="YES"	#Pdbqt output Default kept modify to obpdbqt="YES" for converting pdbqt using obabel 
				skip="YES"
				;;
		   	-cms|-CMS)
				option="cms"
				three=2
				cnf=3		#Conformation Default kept modify to keep other conformation method as default
				nconf=50
				bestconf="YES"
				cnfmin="YES"
				kfinal=1
				skip="YES"
				;;
		   	-cmm|-CMM)
				option="cmm"
				three=2
				cnf=3		#Conformation Default kept modify to keep other conformation method as default
				nconf=50
				bestconf="YES"
				cnfmin="YES"
				kfinal=2
				skip="YES"
				;;
			-cmp|-CMP)
				option="cmp"
				three=2
				cnf=3		#Conformation Default kept modify to keep other conformation method as default
				nconf=50
				bestconf="YES"
				bestconf="YES"
				cnfmin="YES"
				kfinal=3
				pypdbqt="YES"	#Pdbqt output Default kept modify to obpdbqt="YES" for converting pdbqt using obabel 
				skip="YES"
				;;
		   	-ms|-MS)
				three=2
				cnf=0
				option="ms"
				cnfmin="YES"
				kfinal=1
				skip="YES"
				;;
		   	-mm|-MM)
				three=2
				cnf=0
				option="mm"
				cnfmin="YES"
				kfinal=2
				skip="YES"
				;;
			-mp|-MP)
				three=2
				cnf=0
				option="mp"
				cnfmin="YES"
				kfinal=3
				pypdbqt="YES"	#Pdbqt output Default kept modify to obpdbqt="YES" for converting pdbqt using obabel 
				skip="YES"
				;;
			-t|-T)	three=1
				dirthree="YES"
				genopt="$2"
				if [ "$genopt" == "FASTEST" ] || [ "$genopt" == "fastest" ]
				then 
					threed="fastest"				
				elif [ "$genopt" == "FAST" ] || [ "$genopt" == "fast" ]
				then
					threed="fast"
		        	elif [ "$genopt" == "MED" ] || [ "$genopt" == "med" ] || [ "$genopt" == "MEDIUM" ] || [ "$genopt" == "medium" ]
				then 
					threed="med"				
				elif [ "$genopt" == "SLOW" ] || [ "$genopt" == "slow" ]
				then
					threed="slow"				
				elif [ "$genopt" == "SLOWEST" ] || [ "$genopt" == "slowest" ]
				then
					threed="slowest"
				else 
					echo -e "Error: Invalid selection. Please type again " 
					exit
				fi	
				skip="YES"	
				shift
				;;
			-c|-C)  dirconformer="YES"
				#three=2
				con="$2" 
				skip="YES"
				if [[ "$3"  =~ ^[0-9]+$ ]]
				then
					nconf="$3"
				else
					echo "Error:Wrong input given at number of conformers"
					exit
				fi
				if [ "$con" == "GA" ] || [ "$con" == "ga" ]
				then
					cnf=1
					wrc="$4"
					cnfmin="YES"
					if [ "$wrc" == "all" ] || [ "$wrc" == "All" ] || [ "$wrc" == "ALL" ]
					then 
						wrc=1; #writeconf="--writeconformers"
					elif [ "$wrc" == "best" ] || [ "$wrc" == "Best" ] || [ "$wrc" == "BEST" ]
					then
						bestconf="YES"
					else
						echo -e "Error: Unidentified conformer input type! Try again!" 
						exit
					fi 
					shift 3
				elif [ "$con" == "RANDOM" ] || [ "$con" == "random" ] || [ "$con" == "RA" ] || [ "$con" == "ra" ]
				then
					cnf=2
					wrc="$4"
					cnfmin="YES"
					if [ "$wrc" == "all" ] || [ "$wrc" == "All" ] || [ "$wrc" == "ALL" ]
					then 
						wrc=1; #writeconf="--writeconformers"
					elif [ "$wrc" == "best" ] || [ "$wrc" == "Best" ] || [ "$wrc" == "BEST" ]
					then
						bestconf="YES"
					else
						echo -e "Error: Unidentified conformer input type! Try again!" 
						exit
					fi 
					shift 3
				elif [ "$con" == "WEIGHT" ] || [ "$con" == "weight" ] || [ "$con" == "WR" ] || [ "$con" == "wr" ]
				then
					cnf=3
					wrc="$4"
					cnfmin="YES"
					if [ "$wrc" == "all" ] || [ "$wrc" == "All" ] || [ "$wrc" == "ALL" ]
					then 
						wrc=1; #writeconf="--writeconformers"
					elif [ "$wrc" == "best" ] || [ "$wrc" == "Best" ] || [ "$wrc" == "BEST" ]
					then
						bestconf="YES"
					else
						echo -e "Error: Unidentified conformer input type! Try again!" 
						exit
					fi 
					shift 3
				elif [ "$con" == "OBCONFORMER" ] || [ "$con" == "obconformer" ] || [ "$con" == "ob" ] || [ "$con" == "OB" ]
				then
					cnf=4
					shift 2
				elif [ "$con" == "CONFAB" ] || [ "$con" == "confab" ] || [ "$con" == "cf" ] || [ "$con" == "CF" ]
				then
					cnf=5
					cnfmin="YES"
					shift 2
				else
					echo -e "Error: Invalid selection. Please type again " 
					exit
				fi	
				;;
			-m|-M)  
				dirminim="YES"
				#cnf=0
				cnfmin="YES"
				alg="$2"
				if [ "$alg" == "cg" ] || [ "$alg" == "CG" ]
				then
					minimalg="--cg" 
				elif [ "$alg" == "sd" ] || [ "$alg" == "-SD" ]
				then
					minimalg="--sd"
				else
					echo "Unidentified minimization algorithm type mentioed! Try again"
					exit
				fi
				if [[ "$3"  =~ ^[0-9]+$ ]]
				then
					steps="$3"
				else
					echo "Error: Wrong input in number of steps given"
					exit
				fi
				skip="YES"
				shift 2
				;;
			-pdbqt|-PDBQT)
				dirpdbqt="YES"
				pcheck="$2"
				finalformat="pdbqt"
				kfinal=3
				if [ "$pcheck" == "py" ] || [ "$pcheck" == "PY" ]	
				then
					pypdbqt="YES"
				elif [ "$pcheck" == "ob" ] || [ "$pcheck" == "OB" ]
				then
					obpdbqt="YES"
				else
					echo "Error: pdbqt output mentioned wrongly!"
					exit
				fi
				skip="YES"
				shift
				;;
			-o|-O)
				out="$2"
				if [ "$out" == "SDF" ] || [ "$out" == "sdf" ]
				then
					kfinal=1
					shift
				elif [ "$out" == "MOL2" ] || [ "$out" == "mol2" ]
				then
					kfinal=2 
					shift
				elif [ "$out" == "PDBQT" ] || [ "$out" == "pdbqt" ]
				then
					kfinal=3
					pcheck="$3"
					if [ "$pcheck" == "py" ] || [ "$pcheck" == "PY" ]	
					then
						pypdbqt="YES"
					elif [ "$pcheck" == "ob" ] || [ "$pcheck" == "OB" ]
					then
						obpdbqt="YES"
					else
						echo "Error: pdbqt output mentioned wrongly!"
						exit
					fi
					shift 2
				else
					echo "Unidentified ouput format!\nTry again."
					exit
				fi
				skip="YES"
				;;
		    -j|-J)
				if [[ "$2"  =~ ^[0-9]+$ ]]
				then
					joobs="$2"
				else
					echo "Error: Wrong input in number of jobs given"
					exit
				fi
				skip="YES"
				shift
				;;
		    *)
		            echo "Unidentified Command line argument Found!\nTry again."
			    exit
		    ;;
		esac
		shift   # past argument or value
	done
fi
if [ "$skip" == "YES" ]
then
	if [ -d "$LIGAND" ]
	then
		cd "$LIGAND"
		rm summary.txt 2>/dev/null
		a=1
		for f in *.*
		do
			echo "$f" >>ligand.txt
			if [ "$a" == 5 ]
			then
				break
			fi
			a=`expr "$a" + 1`
		done
		a=0
		for f in sdf mdl sd mol2 ml2 sy2 pdb smi mol
		do
			ligform=`grep "$f" ligand.txt`
			if [ -n "$ligform" ]
			then
				format="$f"
				OUT="YES"
				break
			fi 
		done
		if [ "$OUT" != "YES" ]
		then
			echo -e "No specific file format found inside the "$LIGAND" directory"
			rm ligand.txt
			exit
		fi
		rm ligand.txt
		if [ "$format" == "smi" ]
		then
			formatsmi="YES"
			if [ -z "$three" ]
			then
				three=2
				threed="med"
			fi
		fi
		ligtotal=`ls -1U | grep "$format" | tee spacecheck.txt | wc -l`
	fi
	if [ "$dirconformer" == "YES" ]
	then
		if [ -z	"$three" ]; then three=2; fi
		#if [ -z "$cnfmin" ]; then cnfmin="YES"; fi
	fi
	if [ "$dirminim" == "YES" ]
	then
		if [ -z	"$three" ]; then three=2; fi
		if [ -z "$cnf" ]; then cnf=0; fi
	fi
	if [ -n "$three" ] 
	then
		if [ -z "$threed" ]
		then
			threed="med"	#Default value-For shortcut: User can re-edit this default speed- slowest,slow,medium (or) med,fastest,fast
		fi
	fi
	if [ "$cnf" == 1 ]
	then
		score="rmsd" #Default value-For shortcut: User can re-edit this default for GA scoring parameter rmsd (or) energy 
	fi
	if [ "$cnf" == 4 ]
	then
		obconfmin="2500" #Default value-For shortcut: User can re-edit this default obminimze minimization steps
		if [ -z "$cnfmin" ] ; then obout="YES"; fi
	#	cnfmin="YES"
	elif [ "$cnf" == 5 ]
	then
		if [ "$nconf" == 0 ]
		then
			nconf="100000"
		fi
		confabrmsd="0.5" #Default value confab rmsd cut-off
		confabenergy="50.0" #Deafault value confab energy cut-off
	fi 
	if [ -z "$minimalg" ]
	then
		minimalg="--cg" #Default minimization algorithm can modify to "--sd" for steepest descent algorithm
	fi	
	if [ -z "$steps" ]
	then
		steps="2500"	#Default minimization kept
	fi
	if [ "$cnfmin" == "YES" ]
	then
		convergence="1e-6" #Default minimization covergence kept
		vanderw="6.0"	   #Default minimization vander waals cut-off kept
		electro="10.0"	   #Default minimization electrostatic cut-off kept
		nonbp="10"	   #Default minimization non-bonded pairs kept
		hydro="1"	   #Default minimization Hydrogen addition during minimization kept
	fi
	if [ "$kfinal" == 1 ]
	then
		finalformat="sdf"
	elif [ "$kfinal" == 2 ]
	then
		finalformat="mol2"
	elif [ "$kfinal" == 3 ]
	then
		finalformat="pdbqt"
	fi
#	if [ "$option" == "tcms" ] || [ "$option" == "tcmm" ] || [ "$option" == "tcmp" ] || [ "$option" == "cms" ] || [ "$option" == "cmm" ]|| [ "$option" == "cmp" ] || [ "$option" == "tms" ] || [ "$option" == "tmm" ] || [ "$option" == "tmp" ] || [ "$option" == "ms" ] || [ "$option" == "mm" ] || [ "$option" == "mp" ]
#	then
		if [ -z "$forcefield" ]
		then
			forcefield="MMFF94"	#Default forcefield for shortcut if not specified
		fi
#	fi
fi
if [ "$skip" == "YES" ]
then
	echo -e "POAP - Ligand Preparation Module:"
	echo -e "================================================================================"
	if [ -d "$LIGAND" ]; then echo " Ligand directory: "$LIGAND""; else echo " Ligand directory: *Not specified*"; fi
	if [ -d "$LIGAND" ]; then echo " Input Ligands file format: "$format""; fi
	if [ -n "$three" ] && [ "$three" != 2 ] ; then echo " 2D --> 3D conversion: "$threed"";fi
	if [ -n "$cnf" ]; then if [ "$cnf" == 1 ]; then echo -e " Conformer generation: Genetic Algortithm\n Number of conformers: "$nconf""; elif [ "$cnf" == 2 ]; then echo -e " Conformer generation: Random rotor\n Number of conformers: "$nconf""; elif [ "$cnf" == 3 ]; then echo -e " Conformer generation: Weighted rotor\n Number of conformers: "$nconf""; elif [ "$cnf" == 4 ]; then echo -e " Conformer generation: Obconformer\n Number of conformers: "$nconf""; elif [ "$cnf" == 5 ]; then echo -e " Conformer generation: confab\n Number of conformers: "$nconf""; elif [ "$cnf" != 0 ]; then echo -e " Conformer generation: *Not specified*"; fi; fi
	if [ "$obout" != "YES" ]; then if [ "$cnfmin" = "YES" ]; then echo -e " Minimization:\n\tMinimization algorithm="$minimalg"\n\tSteps="$steps"\n\tconvergence criteria="$convergence"\n\tVDW cut-off distance="$vanderw"\n\tElectrostatic cut-off distance="$electro"\n\tfrequency to update the non-bonded pairs="$nonbp"\n\tHydrogen addition=YES\n"; elif [ "$dirpdbqt" != "YES" ]; then echo "Minimization: *Not specified*"; fi; fi    
	if [ "$kfinal" == 1 ]
	then 
		echo " Final output format: "$finalformat"" 
	elif [ "$kfinal" == 2 ] 
	then 
		echo " Final output format: "$finalformat"" 
	elif [ "$kfinal" == 3 ] 
	then 
		echo -e " Final output format: "$finalformat""
		if [ "$pypdbqt" = "YES" ] 
		then 
			echo " PDBQT conversion: prepare_ligand4.py script" 
		elif [ "$obpdbqt" = "YES" ] 
		then 
			echo " PDBQT conversion: obabel"
		fi
	else
		echo " Final output format: *Not specified*" 
	fi 
	if [ -n "$joobs" ]
	then
		echo -e " Number of jobs to run in parallel:"$joobs""
	else 
		echo -e " Number of jobs to run in parallel: *Not given*"
	fi
	if [ "$dirpdbqt" == "YES" ]
	then 
		if [ "$pypdbqt" = "YES" ] 
		then 
			echo " Direct PDBQT conversion: prepare_ligand4.py script" 
		elif [ "$obpdbqt" = "YES" ] 
		then 
			echo " Direct PDBQT conversion: obabel"
		fi
	fi
echo -e "================================================================================\n"
	echo -e "Enter\n[1] To accept these parameters\n[2] To exit"
	i=1
	while [ "$i" -ge 0 ]
	do
		read -ep ">>>" skippara
		if [ "$skippara" == 1 ]
		then
			clear
			break
		elif [ "$skippara" == 2 ]
		then
			cd "$LIGAND"; rm spacecheck.txt 2>/dev/null
			clear
			exit
		else
			echo -e "Empty return. Type again"
			i=`expr $i + 1`
		fi
	done
fi
############Ligand-Preparation software check#####################
if [ ! -d "$LIGAND" ]
then
	##Setting path for the Ligand splitted database##
	echo -e "Please provide directory path containing ligands which are to be prepared\n"
	i=1 
	while [ "$i" -ge 0 ] 
	do 
		read -ep ">>>" lig 
		if [ -n "$lig" ] 
		then
			spacecheck=`echo "$lig" | sed -n "/\s/p"`
			if [ -n "$spacecheck" ]
			then
				echo -e "Space found between directory path.\nPlease remove the space in the directory naming and restart the process again"
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
	rm summary.txt 2>/dev/null
	a=1
	for f in *.*
	do
		echo "$f" >>ligand.txt
		if [ "$a" == 5 ]
		then
			break
		fi
		a=`expr "$a" + 1`
	done
	a=0
	for f in sdf mdl sd mol2 ml2 sy2 pdb smi mol
	do
		ligform=`grep "$f" ligand.txt`
		if [ -n "$ligform" ]
		then
			format="$f"
			OUT="YES"
			break
		fi 
	done
	if [ "$OUT" != "YES" ]
	then
		echo -e "No specific file format found inside the "$LIGAND" directory"
		rm ligand.txt
		exit
	fi
	rm ligand.txt
	if [ "$format" == "smi" ]
	then
		formatsmi="YES"
	fi
	ligtotal=`ls -1U | grep "$format" | tee spacecheck.txt | wc -l`
	echo -e ""$format" file detected inside the ligand directory\n"
	echo -e "Total number of ligands found inside the directory: "$ligtotal"\n\n"
fi
if [ -z "$joobs" ]
then
	njob=`nproc`
	echo -e ""$njob" number of processors detected in your system\n"$njob" number of jobs can be run in parallel at a time\n\n"
	echo -e "Enter the number of jobs to be run in parallel \n Maximum 252 jobs can be run in parallel\nEnter the number of jobs less than 252"
	i=1 
	while [ "$i" -ge 0 ] 
	do 
		read -p ">>>" joobs 
		if [ -n "$joobs" ] && [[ "$joobs"  =~ ^[0-9]+$ ]]
		then 
			break 
		else
			echo -e "Error: empty return. Please type again " 
			i=`expr $i + 1` 
		fi 
	done
	clear
fi
echo -e "\n--------------------------------------------------------------------------------\n--------------------Ligand Preparation Summary Report---------------------------\n--------------------------------------------------------------------------------\nLigand input directory is "$LIGAND"\nInput format: "$format"\nTotal number of ligands found inside the directory: "$ligtotal"\n\n" >>"$LIGAND"/summary.txt
############################################################################################################
###################################        Direct PDBQT Conversion                ##########################
############################################################################################################
if [ "$dirpdbqt" == "YES" ]
then
	if [ "$format" == "smi" ]
	then
		echo -e "Smiles file format found inside the directory. \nWhich needed to be prepared for pdbqt conversion."
	fi
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
		mv \"\$1\" \"\$bspace\"" >name.bash
		cat spacefiles.txt | grep "$format" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
		rm rename.bash spacefiles.txt
	else
		:
	fi
	rm spacecheck.txt
	#######################################
	if [ "$format" == "mol2" ] || [ "$format" == "pdb" ]
	then
		formatpdbqt="YES"
	fi
	#ligand splitting or direct processing
	cd "$LIGAND"; mkdir unprepared pddbqt pddbqt_error; cd pddbqt_error; mkdir pdbqt_in pdbqt_out; cd ../
	a=0
	for f in *."$format"
	do
		if [ "$a" -ge 2 ]
		then
			echo "More than one ligands are present in the directory. So ligand splitting won't be carried out"
			break
		fi
		a=`expr "$a" + 1`
	done
	if [ "$a" == 1 ]
	then
		if [ "$format" == "mol2" ] || [ "$format" == "ml2" ] || [ "$format" == "sy2" ]
		then
			clear
			echo -e "The second line of the each compound starting will be kept as ligand name while splitting"
			echo -e "Enter [1] Yes [2] No"
			read -p ">>>" compname
			clear
			case "$compname"
			in
				1)	ligsplit="YES"
					clear
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - PDBQT Conversion                                                  +"
					echo -e " + -----------------------                                                  +"
					echo -e " +                                                                          +"
					echo -e " + Ligand splitting:                                      Running...        +"
					if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Waiting...        +" ; fi
					echo -e " + mol2 conversion:                                       Waiting...        +" 
					echo -e " + PDBQT conversion:                                      Waiting...        +"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						obabel "$f" -O lig."$format" -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					time=`date +"%c"`;echo -e "Ligand splitting end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~~~Ligand splitting finished~~~~~\n"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt`
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
					clear
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - PDBQT Conversion                                                  +"
					echo -e " + -----------------------                                                  +"
					echo -e " +                                                                          +"
					echo -e " + Ligand splitting:                                      Completed         +"
					if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Running...        +" ; fi
					echo -e " + mol2 conversion:                                       Waiting...        +" 
					echo -e " + PDBQT conversion:                                      Waiting...        +"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~Ligand Renaming on progress~~~"
					time=`date +"%c"`;echo -e "Ligand Renaming start time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -n "
					#!/bin/bash
					format=\""$format"\"
					ligname=\`sed -n \"2p\" \"\$1\"\`
					ligname=\`echo \"\$ligname\" | sed \"s/ /_/g\"\`
					if [ -n \"\$ligname\" ]
					then
						mv \"\$1\" \"\$ligname\".\"\$format\"
					fi">rename.bash
					ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice bash rename.bash {}
					rm rename.bash
#					a=1
#					for f in *."$format"
#					do
#						ligname=`sed -n "2p" "$f"`
#						ligname=`echo "$ligname" | sed "s/ /_/g"`
#						if [ -n "$ligname" ]
#						then
#							mv "$f" "$ligname"."$format"
#						else
#							mv "$f" lig"$a"."$format"	#If empty found then lig1,lig2,lig3 etc., will be renamed.
#							a=`expr $a + 1`
#						fi
#					done
					time=`date +"%c"`;echo -e "Ligand Renaming end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "\n\n~~Ligand Renaming finished~~~"
					clear
				;;
				2)	echo -e "Kindly provide prefix keyword for the ligand splitting\neg:ligand so that ligand1.sdf,ligand2.sdf,.. will be splitted\n"
					read -p ">>>" ligformat
					clear
					echo -e ""$ligformat" prefix is given to the ligand name" >>"$LIGAND"/summary.txt
					ligsplit="YES"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - PDBQT Conversion                                                  +"
					echo -e " + -----------------------                                                  +"
					echo -e " +                                                                          +"
					echo -e " + Ligand splitting:                                      Running...        +"
					echo -e " + mol2 conversion:                                       Waiting...        +" 
					echo -e " + PDBQT conversion:                                      Waiting...        +"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						obabel "$f" -O "$ligformat"."$format" -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					time=`date +"%c"`;echo -e "Ligand splitting end time:"$time"\n" >>"$LIGAND"/summary.txt
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt `
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
					clear
				;;
				*)	echo -e "Invalid selection\n Entered option for is wrong\n"; exit
				;;
			esac
		elif [ "$format" == "mol" ] || [ "$format" == "mdl" ] || [ "$format" == "sdf" ] || [ "$format" == "sd" ]
		then
			echo -e "The First line of the each compound starting will be kept as ligand name while splitting"
			echo -e "Enter [1] Yes [2] No"
			read -p ">>>" compname
			clear
			case "$compname"
			in
				1)	ligsplit="YES"
					clear
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - PDBQT Conversion                                                  +"
					echo -e " + -----------------------                                                  +"
					echo -e " +                                                                          +"
					echo -e " + Ligand splitting:                                      Running...        +"
					if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Waiting...        +"  ; fi
					echo -e " + mol2 conversion:                                       Waiting...        +" 
					echo -e " + PDBQT conversion:                                      Waiting...        +"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						obabel "$f" -O lig."$format" -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					time=`date +"%c"`;echo -e "Ligand splitting end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~~Processing Ligand splitting~~~\n"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt `
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
					clear
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - PDBQT Conversion                                                  +"
					echo -e " + -----------------------                                                  +"
					echo -e " +                                                                          +"
					echo -e " + Ligand splitting:                                      Completed         +"
					if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Running...        +" ; fi
					echo -e " + mol2 conversion:                                       Waiting...        +" 
					echo -e " + PDBQT conversion:                                      Waiting...        +"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~Ligand Renaming on progress~~~"
					time=`date +"%c"`;echo -e "Ligand renaming start time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -n "
					#!/bin/bash
					format=\""$format"\"
					ligname=\`sed -n \"1p\" \"\$1\"\`
					ligname=\`echo \"\$ligname\" | sed \"s/ /_/g\"\`
					if [ -n \"\$ligname\" ]
					then
						mv \"\$1\" \"\$ligname\".\"\$format\"
					fi">rename.bash
					ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice bash rename.bash {}
					rm rename.bash
#					a=1
#					for f in *."$format"
#					do
#						ligname=`sed -n "1p" "$f"`
#						ligname=`echo "$ligname" | sed "s/ /_/g"`
#						if [ -n "$ligname" ]
#						then
#							mv "$f" "$ligname"."$format"
#						else
#							mv "$f" lig"$a"."$format"		#If empty found then lig1,lig2,lig3 etc., will be renamed.
#							a=`expr $a + 1`
#						fi
#					done
					time=`date +"%c"`;echo -e "Ligand renaming end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~Ligand Renaming finished~~"
					clear
				;;
				2)	echo -e "Kindly provide prefix keyword for the ligand splitting\neg:ligand so that ligand1.sdf,ligand2.sdf,.. will be splitted\n"
					read -p ">>>" ligformat
					clear
					ligsplit="YES"
					echo -e ""$ligformat" prefix is given to the ligand name" >>"$LIGAND"/summary.txt
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - PDBQT Conversion                                                  +"
					echo -e " + -----------------------                                                  +"
					echo -e " +                                                                          +"
					echo -e " + Ligand splitting:                                      Running...        +"
					echo -e " + mol2 conversion:                                       Waiting...        +" 
					echo -e " + PDBQT conversion:                                      Waiting...        +"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						obabel "$f" -O "$ligformat"."$format" -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~Ligand splitting finished~~~"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt`
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
				;;
				*)	echo -e "Invalid selection\n Entered option for is wrong\n"; exit
				;;
			esac
		fi
	fi
	if [ "$format" != "pdb" ] && [ "$format" != "mol2" ]
	then
		ligother="YES"; clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - PDBQT Conversion                                                  +"
		echo -e " + -----------------------                                                  +"
		echo -e " +                                                                          +"
		if [ "$ligsplit" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +"; fi
		if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
		if [ "$formatpdbqt" != "YES" ]; then echo -e " + mol2 conversion:                                       Running...        +" ; fi
		echo -e " + PDBQT conversion:                                      Waiting...        +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n\n~~~~~~~~~~~converting to pdbqt~~~~~~~\n\n"
		time=`date +"%c"`;echo -e "PDBQT Preparation start time:"$time"\n" >>"$LIGAND"/summary.txt
		if [ "$obpdbqt" == "YES" ]
		then
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			pdbqt_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
			if [ -s \"\$3\" ]
			then
				if [ -n \"\$pdbqt_error\" ]
				then
					cp \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in	
					mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out
					if [ \"\$ligsplit\" == \"YES\" ]
					then
						rm \"\$2\"	
					else
						mv \"\$2\" unprepared/
					fi
				else
					if [ \"\$ligsplit\" == \"YES\" ]
					then
						rm \"\$2\"	
					else
						mv \"\$2\" unprepared/
					fi
					sed \"/REMARK/d\" \"\$3\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${3%.pdbqt}_atm.txt
					for ff in \$(cat log_\${3%.pdbqt}_atm.txt)
					do
						check=\`grep \"\$ff\" AD_atm_types.txt\`
						if [ -n \"\$check\" ]
						then
							echo \"\$ff\" >>log_atom_type.txt
						else
							mv \"\$3\" "$LIGAND"/unidentified_atom_types_ligands/
							rm log_\${3%.pdbqt}_atm.txt
							exit
						fi
					done
					mv \"\$3\" "$LIGAND"/pddbqt/ 
					rm log_\${3%.pdbqt}_atm.txt
				fi
			else
				cp \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in	
				mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$2\"	
				else
					mv \"\$2\" unprepared/
				fi
			fi">filedel.bash
			echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
			mkdir unidentified_atom_types_ligands
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O {.}.pdbqt -r 2>>log_{.}.txt; bash filedel.bash log_{.}.txt {} {.}.pdbqt; rm log_{.}.txt"
			rm filedel.bash
			cat log_atom_type.txt | sort -u >atmtypes.txt
			pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
			if [ -n "$pdbqt_err" ]
			then
				pdbqterror="YES"
				echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
				cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
			else
				cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
			fi
			mv pddbqt pdbqt
			unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
			if [ -n "$unidecheck" ]
			then
				:
			else
				cd "$LIGAND"; rmdir unidentified_atom_types_ligands
			fi
			cd "$LIGAND"
			atp=0
			while read -r l
			do
				atp="$atp,"$l""	
			done <atmtypes.txt
			atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
			rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
			echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
		elif [ "$pypdbqt" == "YES" ]
		then
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			pdbqt_error=\`grep -n \"Sorry\\, there are no Gasteiger parameters\" \"\$1\"\`
			pdbqt_warn_error=\`grep -n \"WARNING:\" \"\$1\"\`
			traceback_error=\`grep \"Traceback\" \"\$1\"\`
			if [ -s \"\$3\" ]
			then
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$4\"	
				else
					mv \"\$4\" unprepared/
				fi
				if [ -n \"\$pdbqt_error\" ] || [ -n \"\$pdbqt_warn_error\" ] || [ -n \"\$tracebackerror\" ]
				then
					mv \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in	
					mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out
				else
					sed \"/REMARK/d\" \"\$3\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${3%.pdbqt}_atm.txt
					for ff in \$(cat log_\${3%.pdbqt}_atm.txt)
					do
						check=\`grep \"\$ff\" AD_atm_types.txt\`
						if [ -n \"\$check\" ]
							then
							echo \"\$ff\" >>log_atom_type.txt
						else
							mv \"\$3\" "$LIGAND"/unidentified_atom_types_ligands/
							rm \"\$2\"
							rm log_\${3%.pdbqt}_atm.txt
							exit
						fi
					done
					mv \"\$3\" "$LIGAND"/pddbqt/ 
					rm \"\$2\"	
					rm log_\${3%.pdbqt}_atm.txt
				fi
			else
				cp \"\$4\" "$LIGAND"/pddbqt_error/pdbqt_in	
				mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out 2>/dev/null
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$4\"	
				else
					mv \"\$4\" unprepared/
				fi
				rm \"\$2\"
			fi" >pddbqt_error_check.bash
			echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
			cp "$CONFIG"/prepare_ligand4.py "$LIGAND"/
			mkdir unidentified_atom_types_ligands
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O {.}.mol2 -r 2>>log_conv_{.}.txt; "$MGLROOT"/bin/pythonsh prepare_ligand4.py -l {.}.mol2 &>>{.}_log.txt ; bash pddbqt_error_check.bash {.}_log.txt {.}.mol2 {.}.pdbqt {} ; rm {.}_log.txt log_conv_{.}.txt"
			rm pddbqt_error_check.bash prepare_ligand4.py
			cat log_atom_type.txt | sort -u >atmtypes.txt
			pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
			if [ -n "$pdbqt_err" ]
			then
				pdbqterror="YES"
				echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
				cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
			else
				cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
			fi
			mv pddbqt pdbqt
			unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
			if [ -n "$unidecheck" ]
			then
				:
			else
				cd "$LIGAND"; rmdir unidentified_atom_types_ligands
			fi
			cd "$LIGAND"
			atp=0
			while read -r l
			do
				atp="$atp,"$l""	
			done <atmtypes.txt
			atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
			rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
			echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
		fi
		time=`date +"%c"`;echo -e "PDBQT Preparation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$LIGAND"/summary.txt
	fi	 
	if [ "$format" == "pdb" ] || [ "$format" == "mol2" ]
	then
	        cd "$LIGAND"; clear
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - PDBQT Conversion                                                  +"
		echo -e " + -----------------------                                                  +"
		echo -e " +                                                                          +"
		if [ "$ligsplit" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +"; fi
		if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
		echo -e " + PDBQT conversion:                                      Running...        +"
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
		time=`date +"%c"`;echo -e "PDBQT Preparation start time:"$time"\n" >>"$LIGAND"/summary.txt
		if [ "$pypdbqt" == "YES" ]
		then
			cp "$CONFIG"/prepare_ligand4.py "$LIGAND"/	##Copying scripts to the pdb directory##
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			pdbqt_error=\`grep -n \"Sorry\\, there are no Gasteiger parameters\" \"\$1\"\`
			pdbqt_warn_error=\`grep -n \"WARNING:\" \"\$1\"\`
			traceback_error=\`grep \"Traceback\" \"\$1\"\`
			if [ -n \"\$pdbqt_error\" ] || [ -n \"\$pdbqt_warn_error\" ] || [ -n \"\$tracebackerror\" ]
			then
				cp \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in	
				mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out
				if [ \"\$ligsplit\" == \"YES\" ] 
				then
					rm \"\$2\"	
				else
					mv \"\$2\" "$LIGAND"/unprepared/
				fi 
			else
				if [ \"\$ligsplit\" == \"YES\" ] 
				then
					rm \"\$2\"	
				else
					mv \"\$2\" "$LIGAND"/unprepared/
				fi 
				sed \"/REMARK/d\" \"\$3\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${3%.pdbqt}_atm.txt
				for ff in \$(cat log_\${3%.pdbqt}_atm.txt)
				do
					check=\`grep \"\$ff\" AD_atm_types.txt\`
					if [ -n \"\$check\" ]
					then
						echo \"\$ff\" >>log_atom_type.txt
					else
						mv \"\$3\" "$LIGAND"/unidentified_atom_types_ligands/
						rm log_\${3%.pdbqt}_atm.txt
						exit
					fi
				done
				mv \"\$3\" "$LIGAND"/pddbqt/ 
				rm log_\${3%.pdbqt}_atm.txt
			fi" >pddbqt_error_check.bash
			echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
			mkdir unidentified_atom_types_ligands
			ls -1U | grep "$format" | parallel -j "$joobs" --eta --no-notice ""$MGLROOT"/bin/pythonsh prepare_ligand4.py -l {} &>>{.}_log.txt ; bash pddbqt_error_check.bash {.}_log.txt {} {.}.pdbqt ; rm {.}_log.txt"
			rm prepare_ligand4.py pddbqt_error_check.bash
			cat log_atom_type.txt | sort -u >atmtypes.txt
			pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
			if [ -n "$pdbqt_err" ]
			then
				pdbqterror="YES"
				echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
				cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
			else
				cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
			fi
			cd "$LIGAND"; mv pddbqt/ pdbqt/
			unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
			if [ -n "$unidecheck" ]
			then
				:
			else
				cd "$LIGAND"; rmdir unidentified_atom_types_ligands
			fi
			cd "$LIGAND"
			atp=0
			while read -r l
			do
				atp="$atp,"$l""	
			done <atmtypes.txt
			atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
			rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
			echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
			clear
		elif [ "$obpdbqt" == "YES" ]
		then
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			pdbqt_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
			if [ -s \"\$3\" ]
			then			
				if [ -n \"\$pdbqt_error\" ]
				then
					cp \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in	
					mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out
					if [ \"\$ligsplit\" == \"YES\" ]
					then
						rm \"\$2\"	
					else
						mv \"\$2\" unprepared/
					fi
				else
					if [ \"\$ligsplit\" == \"YES\" ]
					then
						rm \"\$2\"	
					else
						mv \"\$2\" unprepared/
					fi
					sed \"/REMARK/d\" \"\$3\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${3%.pdbqt}_atm.txt
					for ff in \$(cat log_\${3%.pdbqt}_atm.txt)
					do
						check=\`grep \"\$ff\" AD_atm_types.txt\`
						if [ -n \"\$check\" ]
						then
							echo \"\$ff\" >>log_atom_type.txt
						else
							mv \"\$3\" "$LIGAND"/unidentified_atom_types_ligands/
							rm log_\${3%.pdbqt}_atm.txt
							exit
						fi
					done
					mv \"\$3\" "$LIGAND"/pddbqt/ 
					rm log_\${3%.pdbqt}_atm.txt
				fi
			else
				cp \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in	
				mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out			
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$2\"	
				else
					mv \"\$2\" unprepared/
				fi
			fi">filedel.bash
			echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
			mkdir unidentified_atom_types_ligands
			ls -1U | grep "$format" | parallel -j "$joobs" --eta --no-notice "obabel {} -O {.}.pdbqt -r &>>log_{.}.txt; bash filedel.bash log_{.}.txt {} {.}.pdbqt; rm log_{.}.txt"
			pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
			if [ -n "$pdbqt_err" ]
			then
				pdbqterror="YES"
				echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
				cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
			else
				cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
			fi
			rm filedel.bash; mv pddbqt pdbqt
			cat log_atom_type.txt | sort -u >atmtypes.txt
			unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
			if [ -n "$unidecheck" ]
			then
				:
			else
				cd "$LIGAND"; rmdir unidentified_atom_types_ligands
			fi
			cd "$LIGAND"
			atp=0
			while read -r l
			do
				atp="$atp,"$l""	
			done <atmtypes.txt
			atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
			rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
			echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
		fi
		time=`date +"%c"`;echo -e "PDBQT Preparation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
		###################################################		
		echo -e "\n\n---------------PDBQT conversion finished----------\n\n" >>"$LIGAND"/summary.txt
echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$LIGAND"/summary.txt
	fi
	clear
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - PDBQT Conversion                                                  +"
	echo -e " + -----------------------                                                  +"
	echo -e " +                                                                          +"
	if [ "$ligsplit" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +"; fi
	if [ "$compname" == 1 ]; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
	if [ "$formatpdbqt" != "YES" ]; then echo -e " + mol2 conversion:                                       Completed         +" ; fi
	if [ "$pdbqterror" != "YES" ] ; then echo -e " + PDBQT conversion:                                      Completed         +" ; fi
	if [ "$pdbqterror" == "YES" ] ; then echo -e " + PDBQT conversion:                                      Completed(!)      +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	exit
fi
################################################################################################################
#########################################        Direct PDBQT END                  ############################# 
################################################################################################################

################################################################################################################
###################################            Ligand preparation                  #############################
################################################################################################################
if [ -z "$forcefield" ]
then
	echo -e " Enter the forcefield for performing ligand optimization:\n[1] Gaff      Gaff force field.\n[2] Ghemical  Ghemical force field.\n[3] MMFF94    MMFF94 force field.\n[4] MMFF94s   MMFF94s force field.\n[5] UFF       Universal Force Field.\n"
	echo -e "Enter the forcefield option number\n" ##Forcefield selection##
	i=1 
	while [ "$i" -ge 0 ] 
	do 
		read -p ">>>" f 
		if [ "$f" == 1 ]  
		then 
			forcefield="Gaff"				
			break 
		elif [ "$f" == 2 ]
		then
			forcefield="Ghemical"
	       	        break
		elif [ "$f" == 3 ]  
		then 
			forcefield="MMFF94"				
			break 
		elif [ "$f" == 4 ]
		then
			forcefield="MMFF94s"				
			break 
		elif [ "$f" == 5 ]
		then
			forcefield="UFF"
			break
		else 
			echo -e "Error: Invalid selection. Please type again " 
			i=`expr $i + 1` 
		fi 
	done
	clear
fi
###Generating summary Report###
if [ "$format" == "smi" ]
then
	if [ -z "$threed" ]
	then
		echo -e "++++++++++++++++++++++++++++\n+ 2D ---> 3D Co-ordinates  +\n++++++++++++++++++++++++++++\n\n3D co-ordinates will be generated for the smi files\n\n"
		echo -e "3D co-ordinate generation = YES" >>"$LIGAND"/summary.txt
		echo -e "Enter the desired speed for 3D-co-ordinate generation\n[1] fastest\n[2] fast\n[3] med or medium\n[4] slow or better\n[5] slowest or best"	
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" genopt 
			if [ "$genopt" == 1 ]  
			then 
				threed="fastest"				
				break 
			elif [ "$genopt" == 2 ]
			then
				threed="fast"
        	                break
			elif [ "$genopt" == 3 ]  
			then 
				threed="med"				
				break 
			elif [ "$genopt" == 4 ]
			then
				threed="slow"				
				break 
			elif [ "$genopt" == 5 ]
			then
				threed="slowest"
				break
			else 
				echo -e "Error: Invalid selection. Please type again " 
				i=`expr $i + 1` 
			fi
		done
		clear
		echo -e "The speed for 3D co-ordinates generation : "$threed"\n\n">>"$LIGAND"/summary.txt
	fi
else
	if [ -z "$three" ]
	then
		####3D Co-ordinate generation####
		echo -e "++++++++++++++++++++++++++++\n+ 2D ---> 3D Co-ordinates  +\n++++++++++++++++++++++++++++\n\nDo you want to generate 3D conformation if your input is in 2D co-ordinates?\n[1] yes\n[2] no \n"
		ii=1 
		while [ "$ii" -ge 0 ] 
		do 
			read -p ">>>" three 
			if [ "$three" == 1 ]  
			then 
				echo -e "3D co-ordinate generation = YES" >>"$LIGAND"/summary.txt
				echo -e "++++++++++++++++++++++++++++\n+ 2D ---> 3D Co-ordinates  +\n++++++++++++++++++++++++++++\n\nEnter the desired speed for 3D-co-ordinate generation\n[1] fastest\n[2] fast\n[3] med or medium\n[4] slow or better\n[5] slowest or best"
				i=1 
				while [ "$i" -ge 0 ] 
				do 
					read -p ">>>" genopt 
					if [ "$genopt" == 1 ]  
					then 
						threed="fastest"				
						break 
					elif [ "$genopt" == 2 ]
					then
						threed="fast"
        	               		        break
					elif [ "$genopt" == 3 ]  
					then 
						threed="med"				
						break 
					elif [ "$genopt" == 4 ]
					then
						threed="slow"				
						break 
					elif [ "$genopt" == 5 ]
					then
						threed="slowest"
						break
					else 
						echo -e "Error: Invalid selection. Please type again " 
						i=`expr $i + 1` 
					fi 
				done
				clear	
				echo -e "The speed for 3D co-ordinates generation : "$threed"\n\n">>"$LIGAND"/summary.txt
				break 
			elif [ "$three" == 2 ]
			then
				echo -e "3D co-ordinate generation = NO \n\n" >>"$LIGAND"/summary.txt
        			break
			else 
				echo -e "Error: Invalid selection. Please type again " 
				ii=`expr $ii + 1` 
			fi 
		done
		clear
	fi
fi
###Selecting the process###
if [ -z "$cnf" ]
then
	echo -e "~~~Conformers Generation~~~\nEnter 0 to skip conformer generation\n\nEnter an option\n\t[1] To generate ligand conformations using GA (Genetic Algorithm)\n\t[2] To generate ligand conformations using Random rotor search method\n\t[3] To generate ligand conformations using Weighted rotor search method\n\t[4] To generate best conformer using obconformer"
	if [ "$confab" == "YES" ]
	then
		echo -e "\t[5] To generate conformer using confab"
	fi
	ii=1 
	while [ "$ii" -ge 0 ] 
	do 
		read -p ">>>" cnf
	 	if [ "$cnf" == 1 ]  
		then 
			clear
			echo -e "Enter the number of conformation to be generated using GA for each ligand\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" nconf 
				if [ -n "$nconf" ] && [[ "$nconf"  =~ ^[0-9]+$ ]]
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			echo -e "Enter the score parameter for conformer generation: [1] RMSD [2] energy\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" sco 
				if [ "$sco" == 1 ]  
				then 
					score="rmsd"				
					break 
				elif [ "$sco" == 2 ]
				then
					 score="energy"
	       			         break
				else 
					echo -e "Error: Invalid selection. Please type again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			echo -e "Do you want to retain all the conformers generated?\n[1] To retain all the conformers\n[2] To select the best structure alone\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" wrc 
				if [ "$wrc" == 1 ] 
				then 
					#writeconf="--writeconformers"
					break 
				elif [ "$wrc" == 2 ]
				then
					bestconf="YES"
					break
				else
						echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			cnfmin="YES"				
			break 
		elif [ "$cnf" == 2 ]  
		then 
			clear
			echo -e "Enter the number of conformation to be generated using random search method\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" nconf 
				if [ -n "$nconf" ] && [[ "$nconf"  =~ ^[0-9]+$ ]]
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear			
			echo -e "Do you want to retain all the conformers generated?\n[1] To retain all the conformers\n[2] To select the best structure alone\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" wrc 
				if [ "$wrc" == 1 ] 
				then 
					#writeconf="--writeconformers"
					break 
				elif [ "$wrc" == 2 ]
				then
					bestconf="YES"
					break
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			cnfmin="YES"
			break 
		elif [ "$cnf" == 3 ]  
		then 
			clear
			echo -e "Enter the number of conformation to be generated using weighted rotor search method\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" nconf 
				if [ -n "$nconf" ] && [[ "$nconf"  =~ ^[0-9]+$ ]]
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			echo -e "Do you want to retain all the conformers generated?\n[1] To retain all the conformers\n[2] To select the best structure alone\n"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" wrc 
				if [ "$wrc" == 1 ] 
				then 
					#writeconf="--writeconformers"
					break 
				elif [ "$wrc" == 2 ]
				then	
					bestconf="YES"
					break
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			cnfmin="YES"
			break 
		elif [ "$cnf" == 4 ]
		then
			clear
			obout="YES"
			echo -e "Enter the number of conformation to generate and passing on the best conformer using obconformer\n"
			echo -e "Ex:To Generate the best conformer (out of 250) enter 250"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" nconf
				if [ -n "$nconf" ] && [[ "$nconf"  =~ ^[0-9]+$ ]]
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			echo -e "Enter the number geometric optimization step to carry out using MMFF94"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" obconfmin
				if [ -n "$obconfmin" ] && [[ "$obconfmin"  =~ ^[0-9]+$ ]]
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			echo -e "Enter [1] To proceed minimization \n[2] Not to proceed minimization"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" obtomin
				if [ "$obtomin" == 1 ] 
				then 
					cnfmin="YES"
					break
				elif [ "$obtomin" == 2 ]
				then
					obout="YES"
					break
				else	
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
	                break
		elif [ "$cnf" == 5 ]
		then
			clear
			echo -e "Enter the number of conformation to be generated using confab\n Enter [0] to set default 100000"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" nconf
				if [ -n "$nconf" ] && [[ "$nconf"  =~ ^[0-9]+$ ]]
				then 
					if [ "$nconf" == 0 ]
					then
						nconf="100000"
					fi
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			echo -e "Enter the rmsd cut off Enter [0] To set default value 0.5"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" confabrm
				if [ -n "$confabrm" ] 
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			if [ "$confabrm" == 0 ]
			then
				confabrmsd="0.5"
			else
				confabrmsd="$confabrm"
			fi
			clear
			echo -e "Enter the energy cut off Enter [0] To set default 50.0[expressed in kcal/mol]"
			i=1 
			while [ "$i" -ge 0 ] 
			do 
				read -p ">>>" confabene
				if [ -n "$confabene" ] 
				then 
					break 
				else
					echo -e "Error: empty return. Please Enter value again " 
					i=`expr $i + 1` 
				fi 
			done
			clear
			if [ "$confabene" == 0 ]
			then
				confabenergy="50.0"
			else
				confabenergy="$confabene"
			fi
			cnfmin="YES"
	                break
		elif [ "$cnf" == 0 ]
		then
			clear
			cnfmin="YES"
			echo -e "Selected option to perform: Only minimization \n" >>"$LIGAND"/summary.txt
	                break
		else 
			echo -e "Error: Invalid selection. Please type again " 
			ii=`expr $ii + 1` 
		fi
	done
	clear
fi
case "$cnf"
in
	1) echo -e "Selected option to perform: Ligand conformation Generation using Genetic Algorithm(GA) \nNumber of conformations selected = "$nconf"\nThe scoring paramter for conformer generation: "$score"\n\n" >>"$LIGAND"/summary.txt
	;;
	2) echo -e "Selected option to perform: Ligand conformation Generation using Random rotor search method \nNumber of conformations selected = "$nconf"\n\n" >>"$LIGAND"/summary.txt
	;;
	3) echo -e "Selected option to perform: Ligand conformation Generation using Weighted rotor search method \nNumber of conformations selected = "$nconf"\n\n" >>"$LIGAND"/summary.txt
	;;
	4)echo -e "Selected option to perform: Ligand conformation Generation using Obconfomer method \nNumber of conformations selected = "$nconf"\nNumber of minimization  steps = "$obconfmin"\n" >>"$LIGAND"/summary.txt
	;;
	5)echo -e "Selected option to perform: Ligand conformation using confab\nNumber of conformation to be generated: "$nconf"\nRMSD cut off : "$confabrmsd"\nEnergy cut off: "$confabenergy"\n\n" >>"$LIGAND"/summary.txt
	;;
esac
####Ligand Minimization###
if [ -z "$minimalg" ] && [ -z "$steps" ] && [ -z "$convergence" ] && [ -z "$vanderw" ] && [ -z "$electro" ] && [ -z "$nonbp" ] && [ -z "$hydro" ]
then
	if [ "$cnfmin" == "YES" ]
	then
		echo "~~~~Minimization~~~~"
		echo -e "Enter [1] for conjugate or [2] for steepest descent algorithm\n" ###Selecting minimisation algorithm##
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" alg 
			if [ "$alg" == 1 ]  
			then 
				minimalg="--cg"				
				break 
			elif [ "$alg" == 2 ]
			then
				minimalg="--sd"
		                break
			else 
				echo -e "Error: Invalid selection. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
		clear
		echo -e "Enter the number of minimization steps to perform\n" ###Selecting number of steps###
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" steps
			if [ -n "$steps" ] && [[ "$steps"  =~ ^[0-9]+$ ]]
			then 
				break 
			else
				echo -e "Error: empty return. Please Enter value again " 
				i=`expr $i + 1` 
			fi 
		done
		clear
		echo -e "Enter the convergence criteria: Enter [0] to set default 1e-6\n"  ###Setting convergence criteria###
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" con
			if [ -n "$con" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please Enter value again " 
				i=`expr $i + 1` 
			fi 
		done
		clear
		if [ "$con" == 0 ]
		then
			convergence="1e-6"
		else
			convergence="$con"
		fi
		echo -e "Enter the VDW cut-off distance : Enter [0] to set default 6.0\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" vw
			if [ -n "$vw" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please Enter value again " 
				i=`expr $i + 1` 
			fi 
		done
		clear
		if [ "$vw" == 0 ]
		then
			vanderw="6.0"
		else
			vanderw="$vw"
		fi
		echo -e "Enter the Electrostatic cut-off distance: Enter [0] to set default 10.0\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" elc
			if [ -n "$elc" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please Enter value again " 
				i=`expr $i + 1` 
			fi 
		done
		clear
		if [ "$elc" == 0 ]
		then
			electro="10.0"
		else
			electro="$elc"
		fi
		echo -e "Enter the frequency to update the non-bonded pairs: Enter [0] to set default 10\n"
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" nop
			if [ -n "$nop" ] 
			then 
				break 
			else
				echo -e "Error: empty return. Please Enter value again " 
				i=`expr $i + 1` 
			fi 
		done
		clear
		if [ "$nop" == 0 ]
		then
			nonbp="10"
		else
			nonbp="$nop"
		fi
		echo -e "Enter [1] To add hydrogens [0] not to add hydrogens\n" ###For adding hydrogens###
		i=1 
		while [ "$i" -ge 0 ] 
		do 
			read -p ">>>" hydro 
			if [ "$hydro" == 1 ] || [ "$hydro" == 0 ]
			then
		                break
			else 
				echo -e "Error: Invalid selection. Please type again " 
				i=`expr $i + 1` 
			fi 
		done
	clear
	fi
fi
if [ "$hydro" == 1 ]  
then 
	re="YES"				
elif [ "$hydro" == 0 ]
then
	re="NO"
fi
if [ "$cnfmin" == "YES" ]
then
	echo -e "
Options for minimization:
1.Forcefield="$forcefield"
2.minimization method="$minimalg"
3.Number of step="$steps"
4.Convergenece criteria="$convergence"
5.VDW cut-off distance="$vanderw"
6.Electrostatic cut off distance="$electro"
7.frequency to update the non-bonded pairs="$nonbp" 
8.Hydrogens addition="$re" \n\n" >>"$LIGAND"/summary.txt
fi
if [ -z "$kfinal" ]
then
	echo -e "Enter an option for output file format\n[1] sdf\n[2]mol2\n[3]pdbqt\n"
	ii=1 
	while [ "$ii" -ge 0 ] 
	do 
		read -p ">>>" kfinal 
		if [ "$kfinal" == 1 ]
		then
			finalformat="sdf"
			break
		elif [ "$kfinal" == 2 ]
		then
			finalformat="mol2"
			break
		elif [ "$kfinal" == 3 ]
		then
			clear
			echo -e "Enter \n[1] To convert PDBQT used prepare_ligand4.py script\n[2] To convert PDBQT using openbabel\n\n"
			opo=1
			while [ "$opo" -ge 0 ]
			do
				read -p ">>>" pout
				if [ "$pout" == 1 ]
				then
					pypdbqt="YES"
					break 2
				elif [ "$pout" == 2 ]
				then
					obpdbqt="YES"
					break 2			
				else
					echo -e "Error: Unrecognised input. Please type again "
					opo=`expr $opo + 1`
				fi
			done
		else 
			echo -e "Error: Invalid selection. Please type again " 
			ii=`expr $ii + 1` 
		fi 
	done
	clear
fi
if [ "$formatsmi" == "YES" ]
then
	three=2
fi
cd "$LIGAND"
a=0
for f in *."$format"
do
	if [ "$a" -ge 2 ]
	then
		break
	fi
	a=`expr "$a" + 1`
done
if [ "$a" == 1 ]
then
	if [ "$format" == "mol2" ] || [ "$format" == "ml2" ] || [ "$format" == "sy2" ]
	then
		echo -e "The second line of the each compound starting will be kept as ligand name while splitting"
		echo -e "Enter [1] Yes [2] No"
		qqq=1
		while [ "$qqq" -ge 0 ]
		do
			read -p ">>>" compname
			if [ "$compname" == 1 ]
			then
				clear
				break 
			elif [ "$compname" == 2 ]
			then
				echo -e "Kindly provide prefix keyword for the ligand splitting\neg:ligand so that ligand1.mol2,ligand2.mol2,.. will be splitted\n"
				read -p ">>>" ligformat
				clear
				break 			
			else
				echo -e "Error: Unrecognised input. Please type again "
				qqq=`expr $qqq + 1`
			fi
		done
		clear
	elif [ "$format" == "mol" ] || [ "$format" == "mdl" ] || [ "$format" == "sdf" ] || [ "$format" == "sd" ]
	then
		echo -e "The First line of the each compound starting will be kept as ligand name while splitting"
		echo -e "Enter [1] Yes [2] No"
		qqq=1
		while [ "$qqq" -ge 0 ]
		do
			read -p ">>>" compname
			if [ "$compname" == 1 ]
			then
				clear
				break 
			elif [ "$compname" == 2 ]
			then
				echo -e "Kindly provide prefix keyword for the ligand splitting\neg:ligand so that ligand1.sdf,ligand2.sdf,.. will be splitted\n"
				read -p ">>>" ligformat
				clear
				break 			
			else
				echo -e "Error: Unrecognised input. Please type again "
				qqq=`expr $qqq + 1`
			fi
		done
		clear
	fi
fi
if [ "$skip" != "YES" ]; then echo -e "----Press Return to start the Ligand preparation-----\n"
read -p ">>>" null
clear
fi
time=`date +"%c"`;echo -e "Ligand preparation start time:"$time"\n" >>"$LIGAND"/summary.txt
mkdir unprepared minimized
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
	cat spacefiles.txt | grep "$format" | parallel -j "$joobs" --no-notice --eta bash rename.bash {}
	rm rename.bash spacefiles.txt
else
	:
fi
rm spacecheck.txt
#######################################
cd "$LIGAND"
a=0
for f in *."$format"
do
	if [ "$a" -ge 2 ]
	then
		echo "More than one ligands are present in the directory. So ligand splitting won't be carried out"
		break
	fi
	a=`expr "$a" + 1`
done
if [ "$a" -gt 1 ]
then
	if [ "$format" == "sd" ] || [ "$format" == "mdl" ] || [ "$format" == "ml2" ] || [ "$format" == "sy2" ] || [ "$format" == "mol" ] || [ "$format" == "pdb" ]
	then
		otherconv="YES"
		mkdir conv_error; cd conv_error; mkdir conv_in conv_out; cd ../
		echo -n "
		#!/bin/bash
		conv_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
		if [ -s \"\$3\" ]
		then
			if [ -n \"\$threed_error\" ]
			then
				cp \"\$2\" "$LIGAND"/conv_error/conv_in/
				mv \"\$2\" "$LIGAND"/unprepared/
				mv \"\$3\" "$LIGAND"/conv_error/conv_out/
			else
				mv \"\$2\" "$LIGAND"/unprepared/
			fi
		else	
			cp \"\$2\" "$LIGAND"/conv_error/conv_in/
			mv \"\$2\" "$LIGAND"/unprepared/
			mv \"\$3\" "$LIGAND"/conv_error/conv_out/	
		fi" >error_check.bash
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Ligand Preparation                                                +"
		echo -e " + -------------------------                                                +"
		echo -e " +                                                                          +"
		if [ "$otherconv" == "YES" ] ; then echo -e " + Ligands format conversion: 				  Running...        +"; fi
		if [ "$formatsmi" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Running...        +" ; fi
		if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
		if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
		if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
		if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
		if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
		if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
		if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
		if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
		if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		ls -1U | grep "$format" | parallel -j "$joobs" --no-notice --eta "obabel {} -O {.}.sdf &>log_{.}.txt; bash error_check.bash log_{.}.txt {} {.}.sdf; rm log_{.}.txt"
		conv_err=`ls -A conv_error/conv_in`
		if [ -n "$conv_err" ]
		then
			conversionerror="YES"
			echo -e "Fewligands were found error during format conversion" >>"$LIGAND"/summary.txt
		else
			cd "$LIGAND"/conv_error/; rmdir conv_in conv_out; cd ../; rmdir conv_error
		fi
		rm error_check.bash
		format="sdf"
		ligsplit="YES"
		clear
	fi
fi
if [ "$a" -gt 1 ] && [ "$formatsmi" == "YES" ]
then
	ligsplit="YES"
	mkdir 3D_smmi_error ; cd 3D_smmi_error; mkdir 3D_in 3D_out; cd ../
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Ligand Preparation                                                +"
	echo -e " + -------------------------                                                +"
	echo -e " +                                                                          +"
	if [ "$formatsmi" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Running...        +" ; fi
	if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
	if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
	if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
	if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
	if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
	if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
	if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
	if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
	if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n\n~~~~Processing the 3D co-ordinates generation~~~~"
	echo -n "
	#!/bin/bash
	ligsplit=\""$ligsplit"\"
	threed_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
	if [ -s \"\$3\" ]
	then
		if [ -n \"\$threed_error\" ]
		then
			cp \"\$2\" "$LIGAND"/3D_smmi_error/3D_in/
			mv \"\$2\" "$LIGAND"/unprepared/
			mv \"\$3\" "$LIGAND"/3D_smmi_error/3D_out/
		else
			mv \"\$2\" "$LIGAND"/unprepared/
		fi
	else
		cp \"\$2\" "$LIGAND"/3D_smmi_error/3D_in/
		mv \"\$2\" "$LIGAND"/unprepared/
		mv \"\$3\" "$LIGAND"/3D_smmi_error/3D_out/	
	fi" >threed_error_check.bash
	time=`date +"%c"`;echo -e "3D Co-ordinates Generation start time:"$time"\n" >>"$LIGAND"/summary.txt
	ls -1U | grep "smi" | parallel -j "$joobs" --eta --timeout 180 --no-notice "obabel {} --gen3D "$threed" --ff "$forcefield" -r -O {.}.sdf 2>>{.}_smi_log.txt ; bash threed_error_check.bash {.}_smi_log.txt {} {.}.sdf ; rm {.}_smi_log.txt" 
	killcheck=`ls -1U | grep "A_"`
	if [ -n "$killcheck" ]
	then
		echo "$killcheck" | sed "s/A_//g"  | parallel -j "$joobs" --no-notice "bash threed_error_check.bash {.}_smi_log.txt {} {.}.sdf ; rm {.}_smi_log.txt"
	fi
	time=`date +"%c"`;echo -e "3D Co-ordinates Generation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	echo -e "~~~~3D Co-ordinates generation finished~~~~\n\n"
	rm threed_error_check.bash
	threed_conv_err=`ls -A 3D_smmi_error/3D_in`
	if [ -n "$threed_conv_err" ]
	then
		threederror="YES"
		echo -e "Fewligands were found error during 3D conversion" >>"$LIGAND"/summary.txt
	else
		cd "$LIGAND"/3D_smmi_error/; rmdir 3D_in 3D_out; cd ../; rmdir 3D_smmi_error
	fi
	format="sdf"
	time=`date +"%c"`;echo -e "3D Co-ordinates Generation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	echo -e "~~~~3D Co-ordinates generation finished~~~~\n\n"
	clear
fi
if [ "$a" == 1 ]
then
	if [ "$formatsmi" == "YES" ]
	then
		filesplit="YES"
		smisplit="YES"
		ligsplit="YES"
		mkdir 3D_smmi_error; cd 3D_smmi_error/; mkdir 3D_in 3D_out ; cd ../
		aname=`ls *.smi`
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Ligand Preparation                                                +"
		echo -e " + -------------------------                                                +"
		echo -e " +                                                                          +"
		if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Running...        +" ; fi
		if [ "$formatsmi" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Waiting...        +" ; fi 
		if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
		if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
		if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
		if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
		if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
		if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
		if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
		if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
		if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n\n~~~Splitting the smi files~~~"
		time=`date +"%c"`;echo -e "Smiles ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
		while read -r l
		do
			name=`echo "$l" | awk '{print $2}'| sed "s/\s//g"`
			echo "$l" >"$name".smi
		done <"$aname"
		time=`date +"%c"`;echo -e "Smiles ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
		echo -e "~~~Smi file splitting finished~~~"
		clear
		mv "$aname" unprepared/
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Ligand Preparation                                                +"
		echo -e " + -------------------------                                                +"
		echo -e " +                                                                          +"
		if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Running...        +" ; fi
		if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
		if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
		if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
		if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
		if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
		if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
		if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
		if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
		if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n\n~~~~Processing the 3D co-ordinates generation~~~~"
		echo -n "
		#!/bin/bash
		ligsplit=\""$ligsplit"\"
		threed_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
		if [ -s \"\$3\" ]
		then
			if [ -n \"\$threed_error\" ]
			then
				mv \"\$2\" "$LIGAND"/3D_smmi_error/3D_in/
				mv \"\$3\" "$LIGAND"/3D_smmi_error/3D_out/
			else
				rm \"\$2\" 
			fi
		else
			mv \"\$2\" "$LIGAND"/3D_smmi_error/3D_in/
			mv \"\$3\" "$LIGAND"/3D_smmi_error/3D_out/	
		fi" >threed_error_check.bash
		time=`date +"%c"`;echo -e "3D Co-ordinates Generation start time:"$time"\n" >>"$LIGAND"/summary.txt
		ls -1U | grep "smi" | parallel -j "$joobs" --eta --timeout 180 --no-notice "obabel {} -O {.}.sdf --gen3D "$threed" -r --ff "$forcefield" 2>>{.}_smi_log.txt ; bash threed_error_check.bash {.}_smi_log.txt {} {.}.sdf ; rm {.}_smi_log.txt" 
		killcheck=`ls -1U | grep "A_"`
		if [ -n "$killcheck" ]
		then
			echo "$killcheck" | sed "s/A_//g"  | parallel -j "$joobs" --no-notice "bash threed_error_check.bash {.}_smi_log.txt {} {.}.sdf ; rm {.}_smi_log.txt"
		fi
		time=`date +"%c"`;echo -e "3D Co-ordinates Generation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
		echo -e "~~~~3D Co-ordinates generation finished~~~~\n\n"
		rm threed_error_check.bash
		threed_conv_err=`ls -A 3D_smmi_error/3D_in`
		if [ -n "$threed_conv_err" ]
		then
			threederror="YES"
			echo -e "Fewligands were found error during 3D conversion" >>"$LIGAND"/summary.txt
		else
			cd "$LIGAND"/3D_smmi_error/; rmdir 3D_in 3D_out; cd ../; rmdir 3D_smmi_error
		fi
		format="sdf"
		clear
	else
		ligsplits="YES"
		if [ "$format" == "mol2" ] || [ "$format" == "ml2" ] || [ "$format" == "sy2" ]
		then
			clear
#			echo -e "The second line of the each compound starting will be kept as ligand name while splitting"
#			echo -e "Enter [1] Yes [2] No"
#			read -p ">>>" compname
			clear
			case "$compname"
			in
				1)	ligsplit="YES"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - Ligand Preparation                                                +"
					echo -e " + -------------------------                                                +"
					echo -e " +                                                                          +"
					if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Running...        +" ; fi
					if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Waiting...        +" ; fi
					if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Waiting...        +" ; fi
					if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
					if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
					if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
					if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
					if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
					if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
					if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
					if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
					if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						#obabel "$f" -O lig."$format" -r -m 2>>split_log.txt
						obabel "$f" -O lig.mol2 -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					format="mol2"
					time=`date +"%c"`;echo -e "Ligand splitting end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~~~Ligand splitting finished~~~~~\n"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt `
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - Ligand Preparation                                                +"
					echo -e " + -------------------------                                                +"
					echo -e " +                                                                          +"
					if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
					if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Running...        +" ; fi
					if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Waiting...        +" ; fi
					if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
					if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
					if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
					if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
					if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
					if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +" ; fi
					if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
					if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
					if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~Ligand Renaming on progress~~~"
					time=`date +"%c"`;echo -e "Ligand Renaming start time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -n "
					#!/bin/bash
					format=\""$format"\"
					ligname=\`sed -n \"2p\" \"\$1\"\`
					ligname=\`echo \"\$ligname\" | sed \"s/ /_/g\"\`
					if [ -n \"\$ligname\" ]
					then
						mv \"\$1\" \"\$ligname\".\"\$format\"
					fi">rename.bash
					ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice bash rename.bash {}
					rm rename.bash
#					a=1
#					for f in *."$format"
#					do
#						ligname=`sed -n "2p" "$f"`
#						ligname=`echo "$ligname" | sed "s/ /_/g"`
#						if [ -n "$ligname" ]
#						then
#							mv "$f" "$ligname"."$format"
#						else
#							mv "$f" lig"$a"."$format"	#If empty found then lig1,lig2,lig3 etc., will be renamed.
#							a=`expr $a + 1`
#						fi
#					done
					time=`date +"%c"`;echo -e "Ligand Renaming end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "\n\n~~Ligand Renaming finished~~~"
					clear
				;;
				2)	
#					echo -e "Kindly provide prefix keyword for the ligand splitting\neg:ligand so that ligand1.mol2,ligand2.mol2,.. will be splitted\n"
#					read -p ">>>" ligformat
#					clear
					echo -e ""$ligformat" prefix is given to the ligand name" >>"$LIGAND"/summary.txt
					ligsplit="YES"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - Ligand Preparation                                                +"
					echo -e " + -------------------------                                                +"
					echo -e " +                                                                          +"
					if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Running...        +" ; fi
					if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Waiting...        +" ; fi
					if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Waiting...        +" ; fi
					if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
					if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
					if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
					if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
					if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
					if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
					if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
					if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
					if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						#obabel "$f" -O "$ligformat"."$format" -r -m 2>>split_log.txt
						obabel "$f" -O "$ligformat".mol2 -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					format="mol2"
					time=`date +"%c"`;echo -e "Ligand splitting end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~~~Ligand splitting finished~~~~~\n"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt `
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
				;;
				*)	echo -e "Invalid selection\n Entered option for is wrong\n"; exit
				;;
			esac
		elif [ "$format" == "mol" ] || [ "$format" == "mdl" ] || [ "$format" == "sdf" ] || [ "$format" == "sd" ]
		then
#			echo -e "The First line of the each compound starting will be kept as ligand name while splitting"
#			echo -e "Enter [1] Yes [2] No"
#			read -p ">>>" compname
			clear
			case "$compname"
			in
				1)	ligsplit="YES"
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - Ligand Preparation                                                +"
					echo -e " + -------------------------                                                +"
					echo -e " +                                                                          +"
					if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Running...        +" ; fi
					if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Waiting...        +" ; fi
					if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Waiting...        +" ; fi
					if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
					if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
					if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
					if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
					if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
					if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +" ; fi
					if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
					if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
					if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						#obabel "$f" -O lig."$format" -r -m 2>>split_log.txt
						obabel "$f" -O lig.sdf -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					format="sdf"
					time=`date +"%c"`;echo -e "Ligand splitting end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~~~Ligand splitting finished~~~~~\n"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt `
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - Ligand Preparation                                                +"
					echo -e " + -------------------------                                                +"
					echo -e " +                                                                          +"
					if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
					if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Running...        +" ; fi
					if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Waiting...        +" ; fi
					if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
					if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
					if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
					if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
					if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
					if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +" ; fi
					if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
					if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
					if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~Ligand Renaming on progress~~~"
					time=`date +"%c"`;echo -e "Ligand renaming start time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -n "
					#!/bin/bash
					format=\""$format"\"
					ligname=\`sed -n \"1p\" \"\$1\"\`
					ligname=\`echo \"\$ligname\" | sed \"s/ /_/g\"\`
					if [ -n \"\$ligname\" ]
					then
						mv \"\$1\" \"\$ligname\".\"\$format\"
					fi">rename.bash
					ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "bash rename.bash {}"
					rm rename.bash
#					a=1
#					for f in *."$format"
#					do
#						ligname=`sed -n "1p" "$f"`
#						ligname=`echo "$ligname" | sed "s/ /_/g"`
#						if [ -n "$ligname" ]
#						then
#							mv "$f" "$ligname"."$format"
#						else
#							mv "$f" lig"$a"."$format"		#If empty found then lig1,lig2,lig3 etc., will be renamed.
#							a=`expr $a + 1`
#						fi
#					done
					time=`date +"%c"`;echo -e "Ligand renaming end time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~Ligand Renaming finished~~"
					clear
				;;
				2)	
#					echo -e "Kindly provide prefix keyword for the ligand splitting\neg:ligand so that ligand1.sdf,ligand2.sdf,.. will be splitted\n"
#					read -p ">>>" ligformat
#					clear
					ligsplit="YES"
					echo -e ""$ligformat" prefix is given to the ligand name" >>"$LIGAND"/summary.txt
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e " + POAP - Ligand Preparation                                                +"
					echo -e " + -------------------------                                                +"
					echo -e " +                                                                          +"
					if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Running...        +" ; fi
					if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Waiting...        +" ; fi
					if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Waiting...        +" ; fi
					if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
					if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
					if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
					if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
					if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
					if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
					if [ "$k" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
					if [ "$k" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
					if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
					echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					echo -e "\n\n~~~Processing Ligand splitting~~~\n"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					for f in *."$format"
					do
						#obabel "$f" -O "$ligformat"."$format" -r -m 2>>split_log.txt
						obabel "$f" -O "$ligformat".sdf -r -m 2>>split_log.txt
						mv "$f" unprepared/
					done
					format="sdf"
					time=`date +"%c"`;echo -e "Ligand splitting start time:"$time"\n" >>"$LIGAND"/summary.txt
					echo -e "~~Ligand splitting finished~~~"
					clear
					###Error Identification####
					##################################################################
					error_split=`grep -n "\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=" split_log.txt`
					if [ -n "$error_split" ]
					then
						echo "~~Process Terminated~~\nError occured during ligand splitting\n\nPlease proceed with the ligands splitting individually"
						exit
					fi
					##################################################################
					rm split_log.txt
				;;
				*)	echo -e "Invalid selection\n Entered option for is wrong\n"; exit
				;;
			esac
		fi
	fi
fi

cd "$LIGAND"
if [ "$three" == 1 ]
then
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Ligand Preparation                                                +"
	echo -e " + -------------------------                                                +"
	echo -e " +                                                                          +"
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
	if [ "$formatsmi" == "YES" ] && [ "$smisplit" = "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
	if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
	if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
	if [ "$three" == 1 ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Running...        +" ; fi
	if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Waiting...        +" ; fi
	if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Waiting...        +"; fi
	if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Waiting...        +"; fi
	if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Waiting...        +" ; fi
	if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Waiting...        +" ; fi
	if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
	if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
	if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
	if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	mkdir 3D_error; cd 3D_error; mkdir 3D_out 2D_in; cd ../
	echo -n "
	#!/bin/bash
	ligsplit=\""$ligsplit"\"
	threed_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
	if [ -s \"\$3\" ]
	then
		if [ -n \"\$threed_error\" ]
		then
			cp \"\$2\" "$LIGAND"/3D_error/2D_in/
			if [ \"\$ligsplit\" == \"YES\" ]
			then
				rm \"\$2\"
			else
				mv \"\$2\" "$LIGAND"/unprepared/
			fi
			mv \"\$3\" \"\$2\"
			mv \"\$2\" "$LIGAND"/3D_error/3D_out/
		else
			if [ \"\$ligsplit\" == \"YES\" ]
			then
				rm \"\$2\"
			else
				mv \"\$2\" "$LIGAND"/unprepared/
			fi
			mv \"\$3\" \"\$2\" 
		fi
	else
		cp \"\$2\" "$LIGAND"/3D_error/2D_in/
		if [ \"\$ligsplit\" == \"YES\" ]
		then
			rm \"\$2\"
		else
			mv \"\$2\" "$LIGAND"/unprepared/
		fi
		mv \"\$3\" \"\$2\"
		mv \"\$2\" "$LIGAND"/3D_error/3D_out/	
	fi" >threed_error_check.bash
	time=`date +"%c"`;echo -e "3D Co-ordinates Generation start time:"$time"\n" >>"$LIGAND"/summary.txt
	echo -e "\n\n~~~~Processing the 3D co-ordinates generation~~~~"
	ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --timeout 180 --no-notice "obabel {} -O A_{} --gen3D "$threed" -r --ff "$forcefield" 2>>{.}_3d_log.txt ; bash threed_error_check.bash {.}_3d_log.txt {} A_{} ; rm {.}_3d_log.txt"
	killcheck=`ls -1U | grep "A_"`
	if [ -n "$killcheck" ]
	then
		echo "$killcheck" | sed "s/A_//g"  | parallel -j "$joobs" --no-notice "bash threed_error_check.bash {.}_3d_log.txt {} A_{} ; rm {.}_3d_log.txt"
	fi
	time=`date +"%c"`;echo -e "3D Co-ordinates Generation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	rm threed_error_check.bash
	echo -e "~~~~3D Co-ordinates generation finished~~~~\n\n"
	threed_conv_err=`ls -A 3D_error/2D_in/`
	if [ -n "$threed_conv_err" ]
	then
		threederror="YES"
		echo -e "Fewligands were found error during 3D conversion" >>"$LIGAND"/summary.txt
	else
		cd 3D_error; rmdir 2D_in 3D_out ; cd ../; rmdir 3D_error
	fi
	ligsplit="YES"
	clear
fi
if [ "$cnf" == 1 ] || [ "$cnf" == 2 ] || [ "$cnf" == 3 ] 
then
	####Running Conformer Generation###
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Ligand Preparation                                                +"
	echo -e " + -------------------------                                                +"
	echo -e " +                                                                          +"
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
	if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
	if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
	if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
	if [ "$cnf" == 1 ] ; then echo -e " + Ligand conformer generation using GA:                  Running...        +" ; fi
	if [ "$cnf" == 2 ] ; then echo -e " + Ligand conformer generation using Random search:       Running...        +" ; fi
	if [ "$cnf" == 3 ] ; then echo -e " + Ligand conformer generation using Weighted search:     Running...        +"; fi
	echo -e " + Ligand minimization:                                   Waiting...        +"
	if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
	if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
	if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	mkdir conformer_error ; cd conformer_error; mkdir cnf_in cnf_out; cd ../
	time=`date +"%c"`;echo -e "Ligand Conformation Generation start time:"$time"\n" >>"$LIGAND"/summary.txt
	echo -n "
	#!/bin/bash
	ligsplit=\""$ligsplit"\"
	cnf_error=\`grep -n \"\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\\=\" \"\$1\"\`
	wrc="$wrc"
	if [ -s \"\$3\" ]
	then
		if [ -n \"\$cnf_error\" ]
		then
			if [ \"\$wrc\" == 1 ]
			then
				cp \"\$2\" "$LIGAND"/conformer_error/cnf_in/
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$2\"
				else
					mv \"\$2\" "$LIGAND"/unprepared/
				fi
				mv \"\$3\" \"\$2\" 
				mv \"\$2\" "$LIGAND"/conformer_error/cnf_out/ 
				rm \"\${2%."$format"}_conf*."$format"\"  2>/dev/null
			else
				cp \"\$2\" "$LIGAND"/conformer_error/cnf_in/
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$2\"
				else
					mv \"\$2\" "$LIGAND"/unprepared/
				fi
				mv \"\$3\" \"\$2\"
				mv \"\$2\" "$LIGAND"/conformer_error/cnf_out/
			fi
		else
			if [ \"\$ligsplit\" == \"YES\" ]
			then
				rm \"\$2\"
			else
				mv \"\$2\" "$LIGAND"/unprepared/
			fi
			if [ \"\$wrc\" == 1 ]
			then
				rm \"\$3\"
			else
				mv \"\$3\" \"\$2\"
			fi 
		fi
	else
		cp \"\$2\" "$LIGAND"/conformer_error/cnf_in/
		if [ \"\$ligsplit\" == \"YES\" ]
		then
			rm \"\$2\"
		else
			mv \"\$2\" "$LIGAND"/unprepared/
		fi
		mv \"\$3\" \"\$2\"
		mv \"\$2\" "$LIGAND"/conformer_error/cnf_out/
	fi" >cnf_error_check.bash
	if [ "$cnf" == 1 ]
	then
		echo -e "\n\n~~~Processing the Ligand conformer generation using GA~~~"
		if [ "$wrc" == 1 ]
		then
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O ga_conf_{} --ff "$forcefield" -r --conformer --nconf "$nconf" --score "$score" --writeconformers &>>conformer_gen_log_{.}.txt ; obabel ga_conf_{} -O {.}_conf."$format" -m &>>conformer_gen_log_{.}.txt ; bash cnf_error_check.bash conformer_gen_log_{.}.txt {} ga_conf_{}; rm conformer_gen_log_{.}.txt"
		else
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O ga_conf_{} --ff "$forcefield" -r --conformer --nconf "$nconf" --score "$score" &>>conformer_gen_log_{.}.txt; bash cnf_error_check.bash conformer_gen_log_{.}.txt {} ga_conf_{}; rm conformer_gen_log_{.}.txt"
		fi
	elif [ "$cnf" == 2 ]
	then
		echo -e "\n\n~~~Processing the Ligand conformer generation using Random search~~~"
		if [ "$wrc" == 1 ]
		then
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O ra_conf_{} --ff "$forcefield" -r --conformer --nconf "$nconf" --random --writeconformers &>>conformer_gen_log_{.}.txt ; obabel ra_conf_{} -O {.}_conf."$format" -m &>>conformer_gen_log_{.}.txt ; bash cnf_error_check.bash conformer_gen_log_{.}.txt {} ra_conf_{}; rm conformer_gen_log_{.}.txt"
		else
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O ra_conf_{} --ff "$forcefield" -r --conformer --nconf "$nconf" --random &>>conformer_gen_log_{.}.txt ; bash cnf_error_check.bash conformer_gen_log_{.}.txt {} ra_conf_{}; rm conformer_gen_log_{.}.txt"
		fi
	elif [ "$cnf" == 3 ]
	then
		echo -e "\n\n~~~Processing the Ligand conformer generation using Wieghted Rotor search~~~"
		if [ "$wrc" == 1 ]
		then
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O wa_conf_{} --ff "$forcefield" -r --conformer --nconf "$nconf" --weighted --writeconformers &>>conformer_gen_log_{.}.txt ; obabel wa_conf_{} -O {.}_conf."$format" -m &>>conformer_gen_log_{.}.txt ; bash cnf_error_check.bash conformer_gen_log_{.}.txt {} wa_conf_{}; rm conformer_gen_log_{.}.txt"
		else
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O wa_conf_{} --ff "$forcefield" -r --conformer --nconf "$nconf" --weighted &>>conformer_gen_log_{.}.txt; bash cnf_error_check.bash conformer_gen_log_{.}.txt {} wa_conf_{}; rm conformer_gen_log_{.}.txt"
		fi
	fi
	time=`date +"%c"`;echo -e "Ligand Conformation Generation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	cnf_err=`ls -A conformer_error/cnf_in/`
	if [ -n "$cnf_err" ]
	then
		cnferror="YES"
		echo -e "Fewligands were found error during 3D conversion" >>"$LIGAND"/summary.txt
	else
		cd conformer_error; rmdir cnf_in cnf_out ; cd ../; rmdir conformer_error
	fi
	echo -e "~~~Ligand conformer generation using GA finished~~~\n\n"
	rm cnf_error_check.bash
	ligsplit="YES"
	clear
elif [ "$cnf" == 4 ]
then
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Ligand Preparation                                                +"
	echo -e " + -------------------------                                                +"
	echo -e " +                                                                          +"
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
	if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
	if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
	if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
	if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Running...        +" ; fi
	if [ "$cnfmin" == "YES" ] ; then echo -e " + Ligand minimization:                                   Waiting...        +"; fi
	if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
	if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Running...        +" ; fi
	if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Running...        +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	time=`date +"%c"`;echo -e "Conformers generation using obconformer start time:"$time"\n" >>"$LIGAND"/summary.txt
	mkdir conformer_error ; cd conformer_error; mkdir cnf_in cnf_out; cd ../
	echo -e "\n\n~~~Processing the Ligand conformer generation using obconformer~~~"
	if [ "$obout" == "YES" ]
	then
		if [ "$finalformat" == "mol2" ] && [ "$format" == "mol2" ]
		then
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			finalformat=\""$finalformat"\"
			if [ -s \"\$2\" ]
			then
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\" 
				cat \"\$1\" >>combined_files.\"\$finalformat\"
				rm \"\$1\"
			else
				cp \"\$1\" "$LIGAND"/conformer_error/cnf_in/ 
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\"
				mv \"\$1\" "$LIGAND"/conformer_error/cnf_out/
			fi">filedel.bash
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obconformer "$nconf" "$obconfmin" {} >A_{} 2>>ob_log_{.}.txt ; bash filedel.bash {} A_{}; rm ob_log_{.}.txt"
#			mkdir "$finalformat"		
#			mv combined_files."$finalformat" "$finalformat"/
			rm filedel.bash
		elif [ "$finalformat" == "sdf" ] && [ "$format" == "sdf" ]
		then
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			finalformat=\""$finalformat"\"
			if [ -s \"\$2\" ]
			then
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\" 
				cat \"\$1\" >>combined_files.\"\$finalformat\"
				rm \"\$1\"
			else
				cp \"\$1\" "$LIGAND"/conformer_error/cnf_in/ 
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\"
				mv \"\$1\" "$LIGAND"/conformer_error/cnf_out/
			fi">filedel.bash
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obconformer "$nconf" "$obconfmin" {} >A_{} 2>>ob_log_{.}.txt ; bash filedel.bash {} A_{}; rm ob_log_{.}.txt"
#			mkdir "$finalformat"		
#			mv combined_files."$finalformat" "$finalformat"/
			rm filedel.bash
		elif [ "$pypdbqt" == "YES" ]
		then
			finalformat="mol2"
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			format=\""$format"\"
			finalformat=\""$finalformat"\"
			if [ -s \"\$2\" ]
			then
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\" 
				obabel \"\$1\" -r -O A_\${1%.\"\$format\"}.\"\$finalformat\" &>>log_\${1%.\"\$format\"}.txt 
				rm log_\${1%.\"\$format\"}.txt \"\$1\" 
				mv  A_\${1%.\"\$format\"}.\"\$finalformat\" \${1%.\"\$format\"}.\"\$finalformat\"
			else
				cp \"\$1\" "$LIGAND"/conformer_error/cnf_in/ 
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\"
				mv \"\$1\" "$LIGAND"/conformer_error/cnf_out/
			fi">filedel.bash
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obconformer "$nconf" "$obconfmin" {} >A_{} 2>>ob_log_{.}.txt ; bash filedel.bash {} A_{}; rm ob_log_{.}.txt"
			rm filedel.bash
		elif [ "$obpdbqt" == "YES" ]
		then
			finalformat="pdbqt"
			mkdir pddbqt pddbqt_error; cd pddbqt_error/; mkdir pdbqt_in pdbqt_out; cd ../
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			format=\""$format"\"
			finalformat=\""$finalformat"\"
			if [ -s \"\$1\" ]
			then
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"					
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\" 
				obabel \"\$1\" -r -O \${1%.\"\$format\"}.\"\$finalformat\" &>>log_\${1%.\"\$format\"}.txt 
				rm log_\${1%.\"\$format\"}.txt 
				#mv  A_\${1%.\"\$format\"}.\"\$finalformat\" \"\$1\"
				if [ -s \${1%.\"\$format\"}.\"\$finalformat\" ]
				then
					sed \"/REMARK/d\" \${1%.\"\$format\"}.\"\$finalformat\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${1%.\"\$format\"}_atm.txt
					for ff in \$(cat log_\${1%.\"\$format\"}_atm.txt)
					do
						check=\`grep \"\$ff\" AD_atm_types.txt\`
						if [ -n \"\$check\" ]
						then
							echo \"\$ff\" >>log_atom_type.txt
						else
							mv \${1%.\"\$format\"}.\"\$finalformat\" "$LIGAND"/unidentified_atom_types_ligands/
							rm log_\${1%.\"\$format\"}_atm.txt \"\$1\" 
							exit
						fi
					done
					mv \${1%.\"\$format\"}.\"\$finalformat\" pddbqt/ 
					rm log_\${1%.\"\$format\"}_atm.txt \"\$1\" 
				else
					cp \"\$1\" pddbqt_error/pdbqt_in/
					if [ \"\$ligsplit\" == \"YES\" ]
					then
						rm \"\$1\"					
					else
						mv \"\$1\" unprepared/
					fi
					mv \${1%.\"\$format\"}.\"\$finalformat\" pddbqt_error/pdbqt_out/
				fi
			else
				cp \"\$1\" "$LIGAND"/conformer_error/cnf_in/ 
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"					
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\"
				mv \"\$1\" "$LIGAND"/conformer_error/cnf_out/
			fi">filedel.bash
			echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
			mkdir unidentified_atom_types_ligands
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obconformer "$nconf" "$obconfmin" {} >A_{} 2>>ob_log_{.}.txt ; bash filedel.bash {} A_{}; rm ob_log_{.}.txt;"
			mv pddbqt pdbqt
			rm filedel.bash
			pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
			if [ -n "$pdbqt_err" ]
			then
				pdbqterror="YES"
				echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
				cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
			else
				cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
			fi
			cat log_atom_type.txt | sort -u >atmtypes.txt
			unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
			if [ -n "$unidecheck" ]
			then
				:
			else
				cd "$LIGAND"; rmdir unidentified_atom_types_ligands
			fi
			cd "$LIGAND"
			atp=0
			while read -r l
			do
				atp="$atp,"$l""	
			done <atmtypes.txt
			atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
			rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
			echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
		else
			echo -n "
			#!/bin/bash
			ligsplit=\""$ligsplit"\"
			finalformat=\""$finalformat"\"
			format=\""$format"\"
			if [ -s \"\$2\" ]
			then
				if [ \"\$ligsplit\" == \"YES\" ]
				then
					rm \"\$1\"
				else
					mv \"\$1\" unprepared/
				fi
				mv \"\$2\" \"\$1\" 
				obabel \"\$1\" -r -O \${1%.\"$format\"}.\"$finalformat\" &>>log_\${1%.\"$format\"}.txt
				cat \${1%.\"$format\"}.\"$finalformat\" >>combined_files.\"\$finalformat\"
				rm log_\${1%.\"$format\"}.txt \${1%.\"$format\"}.\"$finalformat\" \"\$1\"
			else
				mv \"\$1\" "$LIGAND"/conformer_error/cnf_in/ 
				mv \"\$2\" \"\$1\"
				mv \"\$1\" "$LIGAND"/conformer_error/cnf_out/
			fi">filedel.bash
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obconformer "$nconf" "$obconfmin" {} >A_{} 2>>ob_log_{.}.txt ; bash filedel.bash {} A_{}; rm ob_log_{.}.txt"
			rm filedel.bash
#			mkdir "$finalformat"		
#			mv combined_files."$finalformat" "$finalformat"/
		fi
	else
		echo -n "
		#!/bin/bash
		ligsplit=\""$ligsplit"\"
		if [ -s \"\$2\" ]
		then
			if [ \"\$ligsplit\" == \"YES\" ]
			then
				rm \"\$1\"
			else
				mv \"\$1\" unprepared/
			fi
			mv \"\$2\" \"\$1\"
		else
			cp \"\$1\" "$LIGAND"/conformer_error/cnf_in/ 
			if [ \"\$ligsplit\" == \"YES\" ]
			then
				rm \"\$1\"
			else
				mv \"\$1\" unprepared/
			fi
			mv \"\$2\" \"\$1\"
			mv \"\$1\" "$LIGAND"/conformer_error/cnf_out/
		fi">filedel.bash
		ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obconformer "$nconf" "$obconfmin" {} >A_{} 2>>ob_log_{.}.txt ; bash filedel.bash {} A_{};rm ob_log_{.}.txt"
		rm filedel.bash
	fi
	cnf_err=`ls -A conformer_error/cnf_in/`
	if [ -n "$cnf_err" ]
	then
		cnferror="YES"
		echo -e "Fewligands were found error during 3D conversion" >>"$LIGAND"/summary.txt
	else
		cd conformer_error; rmdir cnf_in cnf_out ; cd ../; rmdir conformer_error
	fi
	time=`date +"%c"`;echo -e "Conformers generation using obconformer end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	echo -e "~~~Ligand conformer generation using obconformer finished~~~\n\n"
	ligsplit="YES"
	clear
	if [ "$obout" == "YES" ] && [ "$pypdbqt" == "YES" ]
	then
		cp "$CONFIG"/prepare_ligand4.py "$LIGAND"/	##Copying scripts to the pdb directory##
	        cd "$LIGAND"; mkdir pddbqt pddbqt_error; cd pddbqt_error/; mkdir pdbqt_in pdbqt_out; cd ../
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Ligand Preparation                                                +"
		echo -e " + -------------------------                                                +"
		echo -e " +                                                                          +"
		if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
		if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
		if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
		if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
		if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
		if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
		if [ "$three" == 1 ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
		if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Completed         +" ; fi
		if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Running...        +" ; fi
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "\n\n~~~Processing the Ligand PDBQT conversion~~~"
		echo -n "
		#!/bin/bash
		pdbqt_error=\`grep -n \"Sorry\\, there are no Gasteiger parameters\" \"\$1\"\`
		pdbqt_warn_error=\`grep -n \"WARNING:\" \"\$1\"\`
		traceback_error=\`grep \"Traceback\" \"\$1\"\`
		if [ -n \"\$pdbqt_error\" ] || [ -n \"\$pdbqt_warn_error\" ] || [ -n \"\$tracebackerror\" ]
		then
			mv \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in/ 2>/dev/null
			mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out/ 2>/dev/null
		else
			sed \"/REMARK/d\" \"\$3\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${3%.pdbqt}_atm.txt
			for ff in \$(cat log_\${3%.pdbqt}_atm.txt)
			do
				check=\`grep \"\$ff\" AD_atm_types.txt\`
				if [ -n \"\$check\" ]
				then
					echo \"\$ff\" >>log_atom_type.txt
				else
					mv \"\$3\" "$LIGAND"/unidentified_atom_types_ligands/
					rm log_\${3%.pdbqt}_atm.txt
					rm \"\$2\"
					exit
				fi
			done
			mv \"\$3\" "$LIGAND"/pddbqt/ 2>/dev/null
			rm log_\${3%.pdbqt}_atm.txt
			rm \"\$2\"
		fi" >pddbqt_error_check.bash
		echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
		mkdir unidentified_atom_types_ligands
		time=`date +"%c"`;echo -e "PDBQT Preparation start time:"$time"\n" >>"$LIGAND"/summary.txt
		ls -1U | grep "mol2" | parallel -j "$joobs" --eta --no-notice ""$MGLROOT"/bin/pythonsh prepare_ligand4.py -l {} &>>{.}_log.txt ; bash pddbqt_error_check.bash {.}_log.txt {} {.}.pdbqt ; rm {.}_log.txt"
		time=`date +"%c"`;echo -e "PDBQT Preparation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
		rm prepare_ligand4.py pddbqt_error_check.bash
		pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
		if [ -n "$pdbqt_err" ]
		then
			pdbqterror="YES"
			echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
			cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
		else
			cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
		fi
		
		cd "$LIGAND"; mv pddbqt/ pdbqt/
		cat log_atom_type.txt | sort -u >atmtypes.txt
		unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
		if [ -n "$unidecheck" ]
		then
			:
		else
			cd "$LIGAND"; rmdir unidentified_atom_types_ligands
		fi
		cd "$LIGAND"
		atp=0
		while read -r l
		do
			atp="$atp,"$l""	
		done <atmtypes.txt
		atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
		rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
		echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
		clear
	fi
elif [ "$confab" == "YES" ] && [ "$cnf" == 5 ]
then
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Ligand Preparation                                                +"
	echo -e " + -------------------------                                                +"
	echo -e " +                                                                          +"
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
	if [ "$formatsmi" == "YES" ] && [ "$smisplit" = "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
	if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
	if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
	if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Running...        +" ; fi
	if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
	if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Waiting...        +" ; fi
	if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Waiting...        +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	mkdir conformer_error ; cd conformer_error; mkdir cnf_in cnf_out; cd ../
	echo -n "
	#!/bin/bash
	ligsplit=\""$ligsplit"\"
	if [ -s \"\$2\" ]
	then
		if [ \"\$ligsplit\" == \"YES\" ]
		then
			rm \"\$1\"
			rm \"\$2\"
		else
			mv \"\$1\" unprepared/
			rm \"\$2\"
		fi
	else
		if [ \"\$ligsplit\" == \"YES\" ]
		then
			mv \"\$1\" "$LIGAND"/conformer_error/cnf_in/
			mv \"\$2\" \"\$1\"
			mv \"\$1\" "$LIGAND"/conformer/cnf/out/		
		else
			cp \"\$1\" "$LIGAND"/conformer_error/cnf_in/
			mv \"\$1\" unprepared/
			mv \"\$2\" \"\$1\"
			mv \"\$1\" "$LIGAND"/conformer/cnf/out/					
		fi
	fi">filedel.bash
	echo -e "\n\n~~~Processing the Ligand conformer generation using obconfab~~~"
	time=`date +"%c"`;echo -e "Ligand Conformation Generation start time:"$time"\n" >>"$LIGAND"/summary.txt
	ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O ga_conf_{} --ff "$forcefield" -r --confab --conf "$nconf" --rcutoff "$confabrmsd" --ecutoff "$confabenergy" --original &>>conformer_gen_log_{.}.txt ; obabel ga_conf_{} -O {.}_conf."$format" -m &>>conformer_gen_log_{.}.txt ; bash filedel.bash {} ga_conf_{}; rm conformer_gen_log_{.}.txt"	
	time=`date +"%c"`;echo -e "Conformer Generation using confab end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	echo -e "~~~Ligand conformer generation using confab finished~~~\n\n"
	rm filedel.bash
	cnf_err=`ls -A conformer_error/cnf_in/`
	if [ -n "$cnf_err" ]
	then
		cnferror="YES"
		echo -e "Fewligands were found error during 3D conversion" >>"$LIGAND"/summary.txt
	else
		cd conformer_error; rmdir cnf_in cnf_out ; cd ../; rmdir conformer_error
	fi
	ligsplit="YES"
	clear
fi
if [ "$cnfmin" == "YES" ]
then
	if [ "$obpdbqt" == "YES" ]
	then
		finalformat="pdbqt"
		echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
		mkdir unidentified_atom_types_ligands
	elif [ "$pypdbqt" == "YES" ]
	then
		finalformat="mol2"
	fi
	if [ "$format" == "$finalformat" ]
	then
		rechange="YES"
	fi
	echo -n "
	#!/bin/bash
	ligsplit=\""$ligsplit"\"
	pypdbqt=\""$pypdbqt"\"
	obpdbqt=\""$obpdbqt"\"
	finalformat=\""$finalformat"\"
	rechange=\""$rechange"\"
	if [ -s \"\$2\" ] 
	then
		if [ \"\$ligsplit\" == \"YES\" ]
		then
			rm \"\$1\"
		else
			mv \"\$1\" unprepared/
		fi
		if [ \"\$pypdbqt\" == \"YES\" ]
		then
			if [ \"\$rechange\" == \"YES\" ]; then  mv \"\$2\" \"\$1\"; fi
		elif [ \"\$obpdbqt\" == \"YES\" ]
		then
			#if [ \"\$rechange\" == \"YES\" ]; then  mv \"\$2\" \"\$1\"; mv \"\$1\" minimized/; fi
			sed \"/REMARK/d\" \"\$2\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${2%.pdbqt}_atm.txt
			for ff in \$(cat log_\${2%.pdbqt}_atm.txt)
			do
				check=\`grep \"\$ff\" AD_atm_types.txt\`
				if [ -n \"\$check\" ]
				then
					echo \"\$ff\" >>log_atom_type.txt
				else
					mv \"\$2\" "$LIGAND"/unidentified_atom_types_ligands/
					rm log_\${2%.pdbqt}_atm.txt
					exit
				fi
			done
			mv \"\$2\" minimized/ 
			rm log_\${2%.pdbqt}_atm.txt
		else
			if [ \"\$finalformat\" == \"sdf\" ] || [ \"\$finalformat\" == \"mol2\" ]
			then 
				cat \"\$2\" >>combined_files.\"\$finalformat\"
				rm \"\$2\"
			fi
		fi
	else	
		cp \"\$1\" minim_error/minim_in/
		if [ \"\$ligsplit\" == \"YES\" ]
		then
			rm \"\$1\"
		else
			mv \"\$1\" unprepared/
		fi
		if [ \"\$rechange\" == \"YES\" ]
		then  
			mv \"\$2\" \"\$1\"
			mv \"\$1\" minim_error/minim_out/
		else
			mv \"\$2\" minim_error/minim_out/
		fi
	fi" >test.bash
	mkdir minim_error ; cd minim_error/; mkdir minim_in minim_out; cd ../
	if [ "$hydro" == 0 ]
	then
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + POAP - Ligand Preparation                                                +"
		echo -e " + -------------------------                                                +"
		echo -e " +                                                                          +"
		if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
		if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
		if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
		if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
		if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
		if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
		if [ "$three" == 1 ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
		if [ "$cnf" == 1 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed         +" ; fi
		if [ "$cnf" == 1 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed(!)      +" ; fi 
		if [ "$cnf" == 2 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed         +" ; fi
		if [ "$cnf" == 2 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed(!)      +" ; fi
		if [ "$cnf" == 3 ] && [ "$cnferror" != "YES" ]; then echo -e " + Ligand conformer generation using Weighted search:     Completed         +"; fi
		if [ "$cnf" == 3 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Weighted search:     Completed(!)      +"; fi
		if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Completed         +" ; fi
		if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Completed         +" ; fi
		echo -e " + Ligand minimization:                                   Running...        +"
		if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
		if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Running...        +" ; fi
		if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Running...        +" ; fi
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		time=`date +"%c"`;echo -e "Ligand Minimization start time:"$time"\n" >>"$LIGAND"/summary.txt
		echo -e "\n\n~~~Processing the Ligand minimization~~~"
		if [ "$rechange" == "YES" ]
		then
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O A_{.}."$finalformat" -r --minimize --ff "$forcefield" "$minimalg" --steps "$steps" --crit "$convergence" --cut --rvdw "$vanderw" --rele "$electro" --freq "$nonbp" --log 2>>log_min.txt ; bash test.bash {} A_{.}."$finalformat""
		else
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O {.}."$finalformat" -r --minimize --ff "$forcefield" "$minimalg" --steps "$steps" --crit "$convergence" --cut --rvdw "$vanderw" --rele "$electro" --freq "$nonbp" --log 2>>log_min.txt ; bash test.bash {} {.}."$finalformat""
		fi
		#ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obminimize -ff "$force" "$c" -n "$steps" -c "$convg" -cut -rvdw "$vdw" -rele "$elec" -pf "$np" {} >{.}.pdb 2>>log_min.txt ; bash test.bash {.}.pdb {}" 	
		time=`date +"%c"`;echo -e "Ligand Minimization end time:"$time"\n\n" >>"$LIGAND"/summary.txt
		echo -e "~~~Ligand minimization finished~~~\n\n"
		clear	
	else
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e " + Ligand Preparation                                                       +"
		echo -e " + ------------------                                                       +"
		echo -e " +                                                                          +"
		if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
		if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
		if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
		if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
		if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
		if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
		if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
		if [ "$three" == 1 ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
		if [ "$cnf" == 1 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed         +" ; fi
		if [ "$cnf" == 1 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed(!)      +" ; fi
		if [ "$cnf" == 2 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed         +" ; fi
		if [ "$cnf" == 2 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed(!)      +" ; fi
		if [ "$cnf" == 3 ] && [ "$cnferror" != "YES" ]; then echo -e " + Ligand conformer generation using Weighted search:     Completed         +"; fi
		if [ "$cnf" == 3 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Weighted search:     Completed(!)      +"; fi
		if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Completed         +" ; fi
		if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Completed         +" ; fi
		echo -e " + Ligand minimization:                                   Running...        +"
		if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Waiting...        +" ; fi
		if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Running...        +" ; fi
		if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Running...        +" ; fi
		echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		time=`date +"%c"`;echo -e "Ligand Minimization start time:"$time"\n" >>"$LIGAND"/summary.txt
		echo -e "\n\n~~~Processing the Ligand minimization~~~"
		if [ "$rechange" == "YES" ]
		then
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O A_{.}."$finalformat" -r --minimize --ff "$forcefield" "$minimalg" --steps "$steps" -h --crit "$convergence" --cut --rvdw "$vanderw" --rele "$electro" --freq "$nonbp" --log 2>>log_min.txt ; bash test.bash {} A_{.}."$finalformat""
		else
			ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obabel {} -O {.}."$finalformat" -r --minimize --ff "$forcefield" "$minimalg" --steps "$steps" -h --crit "$convergence" --cut --rvdw "$vanderw" --rele "$electro" --freq "$nonbp" --log 2>>log_min.txt ; bash test.bash {} {.}."$finalformat""
		fi
		#ls -1U | grep ""$format"" | parallel -j "$joobs" --eta --no-notice "obminimize -ff "$force" "$c" -n "$steps" -h -c "$convg" -cut -rvdw "$vdw" -rele "$elec" -pf "$np" {} >{.}.pdb 2>>log_min.txt ; bash test.bash {.}.pdb {}"
		time=`date +"%c"`;echo -e "Ligand Minimization end time:"$time" \n\n" >>"$LIGAND"/summary.txt
		echo -e "~~~Ligand minimization finished~~~\n\n"
		clear
	fi
	rm test.bash
	min_error=`ls -A minim_error/minim_in/`
	if [ -n "$min_error" ]
	then
		minimerror="YES"
		echo -e "Fewligands were found error during minimization" >>"$LIGAND"/summary.txt
	else
		cd "$LIGAND"; cd minim_error/; rmdir minim_in minim_out; cd ../; rmdir minim_error
	fi
	rm log_min.txt
fi
if [ "$pypdbqt" == "YES" ] && [ "$obout" != "YES" ]
then
	cd "$LIGAND"
	cp "$CONFIG"/prepare_ligand4.py .        
	mkdir pddbqt pddbqt_error; cd pddbqt_error/; mkdir pdbqt_in pdbqt_out; cd ../
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e " + POAP - Ligand Preparation                                                +"
	echo -e " + -------------------------                                                +"
	echo -e " +                                                                          +"
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
	if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
	if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
	if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
	if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
	if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
	if [ "$three" == 1 ] && [ "$threederror" = "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
	if [ "$cnf" == 1 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed         +" ; fi
	if [ "$cnf" == 1 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed(!)      +" ; fi
	if [ "$cnf" == 2 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed         +" ; fi
	if [ "$cnf" == 2 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed(!)      +" ; fi
	if [ "$cnf" == 3 ] && [ "$cnferror" != "YES" ]; then echo -e " + Ligand conformer generation using Weighted search:     Completed         +"; fi
	if [ "$cnf" == 3 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Weighted search:     Completed(!)      +"; fi
	if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Completed         +" ; fi
	if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Completed         +" ; fi
	if [ "$minimerror" != "YES" ] ; then echo -e " + Ligand minimization:                                   Completed         +" ; fi
	if [ "$minimerror" == "YES" ] ; then echo -e " + Ligand minimization:                                   Completed(!)      +" ; fi
	if [ "$kfinal" == 3 ] ; then echo -e " + PDBQT conversion:                                      Running...        +" ; fi
	echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "\n\n~~~Processing the Ligand PDBQT conversion~~~"
	echo -n "
	#!/bin/bash
	pdbqt_error=\`grep \"Sorry\\, there are no Gasteiger parameters\" \"\$1\"\`
	pdbqt_warn_error=\`grep \"WARNING:\" \"\$1\"\`
	traceback_error=\`grep \"Traceback\" \"\$1\"\`
	if [ -n \"\$pdbqt_error\" ] || [ -n \"\$pdbqt_warn_error\" ] || [ -n \"\$tracebackerror\" ]
	then
		mv \"\$2\" "$LIGAND"/pddbqt_error/pdbqt_in/ 2>/dev/null
		mv \"\$3\" "$LIGAND"/pddbqt_error/pdbqt_out/ 2>/dev/null
	else
		sed \"/REMARK/d\" \"\$3\" | cut -c77- | sed \"/^$/d\" | sed \"s/\s//g\" | sort -u >log_\${3%.pdbqt}_atm.txt
		for ff in \$(cat log_\${3%.pdbqt}_atm.txt)
		do
			check=\`grep \"\$ff\" AD_atm_types.txt\`
			if [ -n \"\$check\" ]
			then
				echo \"\$ff\" >>log_atom_type.txt
			else
				mv \"\$3\" "$LIGAND"/unidentified_atom_types_ligands/
				rm log_\${3%.pdbqt}_atm.txt
				rm \"\$2\"
				exit
			fi
		done
		mv \"\$3\" "$LIGAND"/pddbqt/ 2>/dev/null
		rm log_\${3%.pdbqt}_atm.txt
		rm \"\$2\"
	fi" >pddbqt_error_check.bash
	time=`date +"%c"`;echo -e "PDBQT Preparation start time:"$time"\n" >>"$LIGAND"/summary.txt
	echo -e "H\nHD\nHS\nC\nA\nN\nNA\nNS\nOA\nOS\nF\nMg\nMG\nP\nSA\nS\nCl\nCL\nCa\nCA\nMn\nMN\nFe\nFE\nZn\nZN\nBr\nBR\nI\nZ\nG\nGA\nJ\nQ" >AD_atm_types.txt
	mkdir unidentified_atom_types_ligands
	ls -1U | grep "mol2" | parallel -j "$joobs" --eta --no-notice ""$MGLROOT"/bin/pythonsh prepare_ligand4.py -l {} &>>{.}_log.txt ; bash pddbqt_error_check.bash {.}_log.txt {} {.}.pdbqt ; rm {.}_log.txt"
	time=`date +"%c"`;echo -e "PDBQT Preparation end time:"$time" \n\n" >>"$LIGAND"/summary.txt
	rm prepare_ligand4.py pddbqt_error_check.bash
	cat log_atom_type.txt | sort -u >atmtypes.txt
	pdbqt_err=`ls -A "$LIGAND"/pddbqt_error/pdbqt_in/`
	if [ -n "$pdbqt_err" ]
	then
		pdbqterror="YES"
		echo -e "Fewligands were found error during PDBQT conversion" >>"$LIGAND"/summary.txt
		cd "$LIGAND"; mv pddbqt_error/ pdbqt_error/
	else
		cd "$LIGAND"/pddbqt_error/; rmdir pdbqt_in pdbqt_out; cd ../; rmdir pddbqt_error
	fi
	cd "$LIGAND"; mv pddbqt/ pdbqt/
	unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
	if [ -n "$unidecheck" ]
	then
		:
	else
		cd "$LIGAND"; rmdir unidentified_atom_types_ligands
	fi
	cd "$LIGAND"
	atp=0
	while read -r l
	do
		atp="$atp,"$l""	
	done <atmtypes.txt
	atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
	rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
	echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
	clear
	echo -e "~~~Ligand PDBQT conversion finished~~~\n\n"
	clear
fi
cd "$LIGAND"
if [ "$pypdbqt" != "YES" ] && [ "$obpdbqt" != "YES" ]
then
	if [ "$finalformat" == "mol2" ] || [ "$finalformat" == "sdf" ]
	then
		cd "$LIGAND"; mkdir "$finalformat"; mv combined_files."$finalformat" "$finalformat"/
	fi
fi
if [ "$obpdbqt" == "YES" ] && [ "$obout" != "YES" ]
then
	cd "$LIGAND"; mv minimized pdbqt
	cat log_atom_type.txt | sort -u >atmtypes.txt
	unidecheck=`ls -A "$LIGAND"/unidentified_atom_types_ligands/`
	if [ -n "$unidecheck" ]
	then
		:
	else
		cd "$LIGAND"; rmdir unidentified_atom_types_ligands
	fi
	cd "$LIGAND"
	atp=0
	while read -r l
	do
		atp="$atp,"$l""	
	done <atmtypes.txt
	atomtypes=`echo "$atp" | sed "s/0,//g"` #;s/^/'/g;s/$/'/g
	rm log_atom_type.txt atmtypes.txt AD_atm_types.txt
	echo "Atom types are : "$atomtypes"" >>"$LIGAND"/summary.txt
fi
if [ "$obpdbqt" == "YES" ] && [ "$obout" != "YES" ] && [ -d "$LIGAND"/minim_error ]
then
	cd "$LIGAND"; cd minim_error/; mv minim_in pdbqt_in; mv minim_out pdbqt_out;cd ../; mv minim_error pdbqt_error
fi
if [ -d "$LIGAND"/minimized ]
then
	rmdir minimized
fi
echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e " + POAP - Ligand Preparation                                                +"
echo -e " + -------------------------                                                +"
echo -e " +                                                                          +"
if [ "$otherconv" == "YES" ] && [ "$conversionerror" != "YES" ]; then echo -e " + Ligands format conversion: 				  Completed         +"; fi
if [ "$otherconv" == "YES" ] && [ "$conversionerror" == "YES" ]; then echo -e " + Ligands format conversion: 				  Completed(!)      +"; fi
if [ "$formatsmi" == "YES" ] && [ "$smisplit" == "YES" ] ; then echo -e " + SMILES Ligand splitting:                               Completed         +" ; fi
if [ "$formatsmi" == "YES" ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed         +" ; fi
if [ "$formatsmi" == "YES" ] && [ "$threederror" == "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion for SMILES:          Completed(!)      +" ; fi
if [ "$ligsplits" == "YES" ] ; then echo -e " + Ligand splitting:                                      Completed         +" ; fi
if [ "$compname" == 1 ] ; then echo -e " + Ligand renaming:                                       Completed         +" ; fi
if [ "$three" == 1 ] && [ "$threederror" != "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed         +" ; fi
if [ "$three" == 1 ] && [ "$threederror" = "YES" ] ; then echo -e " + 2D ---> 3D Co-ordinate conversion:                     Completed(!)      +" ; fi
if [ "$cnf" == 1 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed         +" ; fi
if [ "$cnf" == 1 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using GA:                  Completed(!)      +" ; fi
if [ "$cnf" == 2 ] && [ "$cnferror" != "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed         +" ; fi
if [ "$cnf" == 2 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Random search:       Completed(!)      +" ; fi
if [ "$cnf" == 3 ] && [ "$cnferror" != "YES" ]; then echo -e " + Ligand conformer generation using Weighted search:     Completed         +"; fi
if [ "$cnf" == 3 ] && [ "$cnferror" == "YES" ] ; then echo -e " + Ligand conformer generation using Weighted search:     Completed(!)      +"; fi
if [ "$cnf" == 4 ] ; then echo -e " + Ligand conformer generation using obconformer:         Completed         +" ; fi
if [ "$confab" == "YES" ] && [ "$cnf" == 5 ] ; then echo -e " + Ligand conformer generation using confab:              Completed         +" ; fi
if [ "$minimerror" != "YES" ] && [ "$obout" != "YES" ] ; then echo -e " + Ligand minimization:                                   Completed         +" ; fi
if [ "$minimerror" == "YES" ] ; then echo -e " + Ligand minimization:                                   Completed(!)      +" ; fi
if [ "$kfinal" == 3 ] && [ "$pdbqterror" != "YES" ] ; then echo -e " + PDBQT conversion:                                      Completed         +" ; fi
if [ "$kfinal" == 3 ] && [ "$pdbqterror" == "YES" ] ; then echo -e " + PDBQT conversion:                                      Completed(!)      +" ; fi
if [ "$kfinal" == 2 ] && [ "$finalformat" == "mol2" ] ; then echo -e " + mol2 conversion:                                       Completed         +" ; fi
if [ "$kfinal" == 1 ] && [ "$finalformat" == "sdf" ] ; then echo -e " + sdf conversion:                                        Completed         +" ; fi
echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "~~~~~Ligand preparion Finished~~~~~~"
time=`date +"%c"`;echo -e "Ligand preparation end time:"$time"\n" >>"$LIGAND"/summary.txt
echo "
If you used POAP in your work, please cite: 

Samdani, A. and Vetrivel, U. (2018). POAP: A GNU parallel based multithreaded 
pipeline of open babel and AutoDock suite for boosted high throughput virtual 
screening. Computational Biology and Chemistry, 74, pp.39-48.
DOI:10.1016/j.compbiolchem.2018.02.012
" >>"$LIGAND"/summary.txt
