#! bin/bash
#------------------
#configuration
submi=1;initt=0;process=0;test=0;
cass_=(1);
#1/icrange 2/randinit 3/miloop
ptrfold='/home/a0132576/code/ferrimosc/set3'
cd $ptrfold
runcycle=${#cass_[@]}
for (( ct=1; ct<=$runcycle; ct++ ))
do
	cass=$((cass_[(($ct-1))]))
	#parent folder
	case $cass in
	    1 )
	        rp=1;rn=1 
	        #rp/+I sweep, rn/-I sweep
	        parmp=(1 1 8);
	        parmn=(1 1 8);
			runfold=get_i_range
			#main folder
			collfold=icrange
			#folder for data
	        ;;
	    2 )
			rp=1;rn=0
	        parmp=(1 1 4);
	        parmn=(1 1 4);
	        runfold=randinit
	        collfold=randinit
	        ;;
	    3 )
	        rp=1;rn=0 
	        #rp/init +m , rn/init -m
	        runfold=miloop
			parmp=(-246 1 -242);
			#under +m, I range
			parmn=(240 2 260);
			#under -m, I range
			collfold=miloop
	        ;;
	    4 )
			rp=1;rn=1
			#rp/Hz , rn/H45 degree b/w yz
	        runfold=hext
	        collfold=hextdat
	        parmp=(-10 3 10);
	        parmn=(-10 3 10);
			;;

	esac
	pamp=($(seq $((parmp[0])) $((parmp[1])) $((parmp[2]))))
	pamn=($(seq $((parmn[0])) $((parmn[1])) $((parmn[2]))))
	sz3=${#pamp[@]}
	Icsubm=(1 1 $sz3);
	#no. of cycles
	cd $runfold
	#-------submit-----------
	for ctIc in $(seq $((Icsubm[0])) $((Icsubm[1])) $((Icsubm[2])))
		do

		#move necessery folders & files
		if [ $submi -eq 1 ]; then
			#submit
			case $cass in
			
				1 )
					tmp=$(bc <<< "3 ^ $ctIc")
					subfold1=paIc_$tmp
					subfold2=paIc_-$tmp
					#subfolder
				;;
				2 )
					tmp=$ctIc
					subfold1=parandinit_$tmp
				;;
				3 )
					subfold1=pamiloopp_$((pamp[(($ctIc-1))]))
					subfold2=pamiloopn_$((pamn[(($ctIc-1))]))
					;;
				4 )
					subfold1=pahextz_$((pamp[(($ctIc-1))]))
					subfold2=pahext45_$((pamp[(($ctIc-1))]))
				;;
			esac

			if [ $rp -eq 1 ]; then
			cd $subfold1
			if [ $test -eq 1 ]; then
				pwd
			else
				qsub PBSScript
				sleep 1
			fi	
			cd ..
			fi

			if [ $rn -eq 1 ]; then
			cd $subfold2
			if [ $test -eq 1 ]; then
				pwd
			else
				qsub PBSScript
				sleep 1
			fi
			cd ..

			fi
			#echo $ctHext_$ctIc

		else
		true
		fi
	done
	#-------process-----------
	if [ $process -eq 1 ]; then
		if [ ! -d $collfold ]; then
		mkdir $collfold
		echo "create folder $collfold"
		else
		echo "$collfold exist"
		fi
		echo "moving mat file"
		cp -R */fin* $collfold
		echo "mat file moved"
		#pwd
	fi
	cd $ptrfold
done
