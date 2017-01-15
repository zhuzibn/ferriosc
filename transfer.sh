#! bin/bash
#1icrange 2randinit 3miloop 4hext
cass_=(4)
runcycle=${#cass_[@]}
for (( ct=1; ct<=$runcycle; ct++ )); do
	cass=$((cass_[(($ct-1))]))
	case $cass in
		1 )
			scp -r a0132576@137.132.146.179:/home/a0132576/code/ferrimosc/set2/get_i_range/icrange ~/icrange
			;;
		2 )
			scp -r a0132576@137.132.146.179:/home/a0132576/code/ferrimosc/set2/randinit/randinit ~/randinit
			;;
		3 )
			scp -r a0132576@137.132.146.179:/home/a0132576/code/ferrimosc/set2/miloop/miloop ~/miloop
		;;
		4 )
			scp -r a0132576@137.132.146.179:/home/a0132576/code/ferrimosc/set2/hext/hextdat ~/hextdat
		;;
	esac
done

