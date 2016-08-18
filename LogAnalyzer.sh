#!/bin/bash
#Downloads manager for different users on narmada.iiitdmj.ac.in
document=('pdf' 'txt' 'docx' 'doc' 'rtf' 'dat' 'ppt' 'pptx' 'odf' 'xml' 'html' 'odt' 'c' 'cpp' 'sh' 'java')
compressed=('rar' 'zip' 'tar' '7z' 'iso')
video=('mp4' 'mkv' 'avi' 'flv' 'WebM' 'mov' 'wmv' '3gp' 'mpg' 'mpeg')
audio=('mp3' 'wav' 'ogg' 'mp4a' 'wma')
application=('exe' 'rpm' 'deb' 'dmg' 'jar' 'jad' 'bin' 'apk' 'run')
image=('png' 'jpeg' 'jpg' 'xpm' 'gif' 'tiff' 'bmp')
enterDir()
{
	directory=$(ls -1 | sed -n `echo $1`p )
	cd `echo $directory`
}
displayArray()
{
	IFS=":"
	i=0
	for file in $array
	do
		if [ $i != 0 ]
		then
			echo "     $i. $file"
		fi
		i=`expr $i + 1`
	done
}
inCategory()
{
	extension=""
	#declaring arrays w.r.t their type
	doc="";com="";	vid="";	aud="";	app="";	img="";	oth=""
	#declaration end
	shopt -s lastpipe
	ls -1 | while read i 			#While Starts
	do
		extension=$(echo $i | cut -d '.' -f2)
		flag=true
		if [ $flag = true ]						#for documents
		then
			for ext in ${document[@]}
			do
				if [ $ext = $extension ]
				then
					flag=false
					doc=$doc:$i
				fi
			done
		fi
		if [ $flag = true ]						#for compressed items
		then
			for ext in ${compressed[@]}
			do
				if [ $ext = $extension ]
				then
					flag=false
					com=$com:$i
				fi
			done
		fi
		if [ $flag = true ]						#for videos
		then
			for ext in ${video[@]}
			do
				if [ $ext = $extension ]
				then
					flag=false
					vid=$vid:$i
				fi
			done
		fi
		if [ $flag = true ]						#for audios
		then
			for ext in ${audio[@]}
			do
				if [ $ext = $extension ]
				then
					flag=false
					aud=$aud:$i
				fi
			done
		fi
		if [ flag = true ]						#for applications
		then
			for ext in ${application[@]}
			do
				if [ $ext = $extension ]
				then
					flag=false
					app=$app:$i
				fi
			done
		fi
		if [ $flag = true ]						#for images
		then
			for ext in ${image[@]}
			do
				if [ $ext = $extension ]
				then
					flag=false
					img=$img:$i
				fi
			done
		fi
		if [ $flag = true ]						#for others
		then
				flag=false
				oth=$oth:$i
		fi
	done	#End While
	#Displaying the all files in a category
	echo "----------Documents----------"
	array=$doc
	if [ "X$doc" = "X" ]
	then
		echo "     No Documents"
	else displayArray $array
	fi
	echo "----------Compresseds--------"
	array=$com
	if [ "X$com" = "X" ]
	then
		echo "     No Compressed files"
	else displayArray $array
	fi
	echo "----------Videos-------------"
	array=$vid
	if [ "X$vid" = "X" ]
	then
		echo "     No Video files"
	else displayArray $array
	fi
	echo "----------Audios-------------"
	array=$aud
	if [ "X$aud" = "X" ]
	then
		echo "     No Audio files"
	else displayArray $array
	fi
	echo "----------Applications-------"
	array=$app
	if [ "X$app" = "X" ]
	then
		echo "     No Applications"
	else displayArray $array
	fi
	echo "----------Images-------------"
	array=$img
	if [ "X$img" = "X" ]
	then
		echo "     No Images"
	else displayArray $array
	fi
	echo "----------Others-------------"
	array=$oth
	if [ "X$oth" = "X" ]
	then
		echo "     No Other files"
	else displayArray $array
	fi
	#Displaying finished
}
recentDownloads()
{
	ls -lt | sed "1d" | awk '{printf "     %d. %s  ||Date:%s  Month:%s  Time:%s||\n", NR , $9" "$10" "$11" "$12" "$13" "$14" "$15, $7, $6, $8;}'
}
deleteFiles()
{
	shopt -s lastpipe
	find "`pwd`" -size +`echo $2`c | while read a
	do
		i=$(echo $a | sed 's:/: :g')
		echo $a;
		j=($i)
		fileName=${j[${#j[@]}-1]}
		userName=${j[${#j[@]}-3]}
		echo "$userName:$fileName:size-`du -hs $a | awk '{print $1}'`:`date`" >> ~/LogAnalyzer/delete.log
	done
	find `echo $1` -size +`echo $2`c -delete 		#Deleting the files	in directory($1) of size($2)
}
FLS()
{
	local x=$(pwd | cut -d '/' -f3)
	echo "Now you are in $x folder."
	echo "List of $x members are:-"
	ls -1 | cat -n		#Listing faculties with number in first
	echo -n "Enter number to see list of downloads by particular person:"
	read num
	echo ""
	enterDir $num		#Person name/folder name
	cd Downloads		#Entering into Downloads of any person
	local j=1		#Iterator
	ls -1 | while read i
	do
		z=$(du -hs "`echo $i`" | awk '{print $1}')
		echo "$j.$i    ||size:$z||"
		j=`expr $j + 1`
	done
	echo ""
	echo "Enter the command to do following:-"
	echo "1.Categorized Downloads by type."
	echo "2.Categorized Downloads by date."
	echo "3.Delete the files greater than some mb."
	echo -n "command:"
	read num2
	if [ $num2 = 1 ]
	then
		inCategory
	elif [ $num2 = 2 ]
	then
		recentDownloads
	elif [ $num2 = 3 ]
	then
		echo ""
		echo -n "Enter the size of file above which you have to delete all files in mb:"
		read num
		temp=$(echo "$num*1024*1024" | bc)
		echo ""
		x=.
		deleteFiles	$x $temp					#Deleting the files in current directory(.) of size($temp)
		echo "All files above than $num mb has been deleted!!!"
	else "Wrong command!!!"
	fi
}
basicFunction()
{
	echo ""
	echo "Enter the command to do following:-"
	echo "1.Categorized Downloads by type"
	echo "2.Categorized Downloads by date"
	echo "3.Delete the files greater than some mb"
	echo -n "command:"
	read num
	if [ $num = 1 ]
	then
		inCategory
	elif [ $num = 2 ]
	then
		recentDownloads
	elif [ $num = 3 ]
	then
		echo ""
		echo -n "Enter the size of file above which you have to delete all files in mb:"
		read num
		temp=$(echo "$num*1024*1024" | bc)
		echo ""
		x=.
		deleteFiles $x $temp		#Deleting the files in current directory(.) of size($temp)
		echo "All files above than $num mb has been deleted!!!"
	else "Wrong command!!!"
	fi
}
student()
{
	echo "Now you are in student folder."
	echo "List of groups are:-"
	ls -1 | cat -n		#Listing groups with number in first
	echo -n "Enter number to enter into respective group:"
	read num
	x=$(ls -1 | sed -n `echo $num`p )
	cd `echo $x`
	echo "List of $x batches are:-"
	ls -1 | cat -n		#Listing batches with number in first
	echo -n "Enter number to enter into respective batch:"
	read num
	y=$(ls -1 | sed -n `echo $num`p )
	cd `echo $y`
	echo "List of $y branches are:-"
	ls -1 | cat -n		#Listing branches with number in first
	echo -n "Enter number to enter into respective branch:"
	read num
	z=$(ls -1 | sed -n `echo $num`p )
	cd `echo $z`
	echo "List of $z Students of $x $y batch are:-"
	ls -1 | cat -n		#Listing students with number in first
	echo -n "Enter number to see list of downloads by particular person:"
	read num
	echo ""
	local u=$(ls -1 | sed -n `echo $num`p)		#Person name/folder name
	cd `echo $u`/Downloads		#Entering into Downloads of any person
	local j=1		#Iterator
	ls -l | sed "1d" | while read a b c d e f g h i
	do
		k=$(du -hs "`echo $i`" | awk '{print $1}')
		echo "$j.$i    ||size:$k||"
		j=`expr $j + 1`
	done
	basicFunction
}
GBB()
{
	echo ""
	echo "Select one of the following $1."
	ls -1 | cat -n		#Listing groups with number in first
	echo -n "command:"
	read num
	echo ""
	x=$(ls -1 | sed -n `echo $num`p)			#Variable holding the name of group(btech/mtech)
	echo "Now you can perform actions in $x."
	echo "Enter respective command to do following:-"
	echo "1.Total space taken by particular $1."
	echo "2.Delete the files greater than some mb."
	echo -n "command:"
	read num
	if [ $num = 1 ]
	then
		echo ""
		size=$(du -hs `echo $x` | awk '{print $1}')
		echo "     ||$2:$x has size:$size||"
	elif [ $num = 2 ]
	then
		echo ""
		echo -n "Enter the size of file above which you have to delete all files in mb:"
		read size
		temp=$(echo "$size*1024*1024" | bc)
		echo ""
		echo "$temp"
		pwd
		cd `echo $x`
		y=.
		deleteFiles $y $temp		#Deleting the files in folder($x) of size($temp)
		echo "All files above than $size mb has been deleted!!!"
	else echo "Wrong Command!!!"
	fi
}



#Authors:Shivam Sharma(2011224) ,Abhinav Gupta(2011001) & Rishabh Gupta(2011127)
<<COMMENT
This is log analyzer of narmada.iiitdmj.ac.in ,handling the downloads of users in narmada and gives
functionality to admin to take some measure action over the downloads and some more monitering functions.
It basically a monitering program to check whether a user of narmada is not misusing the space.
COMMENT
<<ASSUMPTION
All files and folders must name with no spaces
ASSUMPTION
#In narmada it should be /user
#Start of main program
cd /users
echo "This is Download Log Analyzer by Abhinav Gupta, Rishabh Gupta & Shivam Sharma."
echo "Select the group of users:-"
echo "1.Faculty"
echo "2.Lab"
echo "3.Staff"
echo "4.Student"
echo "5.ID/RollNo on NIS"
echo "6.Exit"
echo -n "command:"
read num
if [ $num = 1 ] || [ $num = 2 ] || [ $num = 3 ]		#For Faculty ,Lab & Staff as they have same file structure
then
	echo ""
	enterDir $num
	FLS $num
elif [ $num = 4 ]
then
	enterDir $num
	echo ""
	echo "Enter following number to do below functionality:-"
	echo "1.Perform operations on individual."
	echo "2.Perform operations on whole btech/mtech/others groups"
	echo "3.Perform operations on particular batch of btech/mtech"
	echo "4.Perform operations on particular branch of particular batch of btech/mtech"
	echo -n "command:"
	read num
	if [ $num = 1 ]
	then
		student $num
	elif [ $num = 2 ]
	then
		field="groups"
		altF="Group"
		GBB $field $altF
	elif [ $num = 3 ]
	then
		field="batches"
		altF="Batch"
		echo ""
		echo "Select one of the following groups."
		ls -1 | cat -n		#Listing groups with number in first
		echo -n "command:"
		read num
		enterDir $num
		GBB $field $altF
	elif [ $num = 4 ]								#For Student 
	then
		field="branches"
		altF="Branch"
		echo ""
		echo "Select one of the following groups."
		ls -1 | cat -n		#Listing groups with number in first
		echo -n "command:"
		read num
		enterDir $num
		echo ""
		echo "Select one of the following batches."
		ls -1 | cat -n		#Listing batches with number in first
		echo -n "command:"
		read num
		enterDir $num
		GBB $field $altF
	else echo "Wrong Command!!!"
	fi
elif [ $num = 5 ]
then
	echo -n "Enter the ID/RollNo of a person of which you have to analyze the downloads:"
	read id
	x=$(grep -w "`echo $id`" /etc/passwd)
	if [ "X$x" = "X" ]
	then
		echo "ID:$x doesn't exist."
	else
		dir=$(echo $x | cut -d ":" -f6)
		cd `echo $dir`/Downloads
		basicFunction
	fi
elif [ $num = 6 ]
then
	exit
else echo "Wrong command!!!"
fi
cd ~/LogAnalyzer
echo ""
./LogAnalyzer.sh
