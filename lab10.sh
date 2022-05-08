#!/bin/bash
#--------------------------------------------------------------------------
#Created by Justin Trubela 5/5/22
#Create a Fibonacci bash script that allows the user to choose a 
#	recursive or non-recursive version of fibonacci sequence given a number
#   and calculate the OVERALL RUN TIME & each ITERATION RUN TIME
#--------------------------------------------------------------------------
USER_Num=$1
USER_Letter=""
USER_FileName="fibonacci.out"

echo "Welcome to fibonacci speed test!"
echo "Choose your function type: Recursive(R|r) or Non-Recursive(N|n)"
echo "Checking to see if the output file needed exists."

#Check to see if user number is < 1 or is negative
while [ $USER_Num -lt 2 ] ; do  
	echo "Number entered not an option. Enter new number: "
	read USER_Num
	if [ $USER_Num -ge 2 ] ; then
		break
	fi
done

#File Check
if [[ ! -f $USER_FileName ]] ; then 
    echo "File does not exist. Creating now."
    touch $USER_FileName
else
	echo "File exists. Deleting its contents and overwriting"
	rm $USER_FileName
	touch $USER_FileName
fi


echo "Enter the type of fib_nonacci function('R' or 'r' for recursive and 'N' or 'n' for non-recursive):"
read USER_Letter

#Create functions for recursive/non-recursive
#recursive function
fib_r(){
	#get commandline input
	userNum=$1
	if [ "$userNum" -lt 2 ] ; then
		echo "$userNum"
	else
		(( --userNum ))
		eq1=$( fib_r $userNum)

		(( --userNum ))
		eq2=$( fib_r $userNum)

		echo $(( eq1 + eq2 ))
	fi
}

#non-recursive function
function fib_n(){ 
	#get commandline input
    userNum=$1

    result=0
	num2=1
	count=2
   
    for (( i=0; i<$userNum; i++ )) ; do
        temp=$((result + num2))
        result=$num2
        num2=$temp
    done
    echo $result
}

function getFibonacciTiming(){
    #Take in parameters for this function
    function_FileName=$1
    function=$2
    function_Number=$3
    function_Type=$4
    
    REPORT_LineCounter=1
    REPORT_LineCount=10
    USER_Sum=0.0
    USER_Average=0.0
    
    #Get Start Date Time
    StartDate=$(date +"%B%e, %Y %T.%N")
    StartDateTiming=`date --date="$StartDate" '+%s.%N'`
    echo "START: $StartDate" | tee -a $function_FileName                     
    echo "" | tee -a $function_FileName

    #Report which method user chose, the number entered on the command line
    echo "$function_Type for $USER_Num" | tee -a $function_FileName            
    echo "" | tee -a $function_FileName
    echo "run     fibonacci      time" | tee -a $function_FileName 

    #RUN Function 10 TIMES to send to report
    while [ $REPORT_LineCounter -le $REPORT_LineCount ]                 
    do
        #Get start time	for average iteration timing
        Function_StartTime=$(date +"%T.%N")
        Function_StartTiming=`date --date="$Function_StartTime" '+%s.%N'`

        #function result call
        Function_Result="$($function $USER_Num)"                            

        #Get end time for average iteration timing
        Function_EndTime=$(date +"%T.%N")
        Function_EndTiming=`date --date="$Function_EndTime" '+%s.%N'`

        #GET DURATION of iteration
        Function_Duration=`echo "scale = 10; $Function_EndTiming-$Function_StartTiming" | bc`
        USER_Sum=`echo "$USER_Sum+$Function_Duration" | bc`
        #Output to file
        echo "$REPORT_LineCounter        $Function_Result           $Function_Duration" | tee -a $function_FileName
        REPORT_LineCounter=$(($REPORT_LineCounter + 1))
    done
    
    #Calculate the average for function run
    echo "" | tee -a $function_FileName
    USER_Average=`echo "scale = 10; $USER_Sum/$USER_Num" | bc -l`           
    echo "Average Time: $USER_Average" | tee -a $function_FileName          

    #Get End Date Time
    EndDate=$(date +"%B%e, %Y %T.%N")
    EndDateTiming=`date --date="$EndDate" '+%s.%N'`
    echo "" | tee -a $function_FileName
    echo "END: $EndDate" | tee -a $function_FileName
    
    #Get Minutes
    StartDateMinutes=`date --date="$StartDate" '+%M'`
    EndDateMinutes=`date --date="$EndDate" '+%M'`
    DateDurationMinutes=`echo "scale = 10; $EndDateMinutes-$StartDateMinutes" | bc`
    #Get START AND END TIME DURATIONS
    DateDurationSecsAndNano=`echo "scale = 10; $EndDateTiming-$StartDateTiming" | bc | awk '{printf "%f", $0}'`
    echo "" | tee -a $function_FileName

    #IF any is 0 it doesnt show so make them string representations
    # if [[ $DateDurationMinutes -eq 0 ]]
    # then 
    #     DateDurationMinutes="0"
    # fi

    #PUT ALL TIME VARIATIONS TOGETHER
    TotalTime="$DateDurationMinutes:$DateDurationSecsAndNano"
    echo "Total Time for the run = $TotalTime" | tee -a $function_FileName
	# echo "0.1 + 0.1" | bc | awk '{printf "%f", $0}'
	#; if(x<1) print 0; x" | bc 
	# echo "x=0.1 + 0.1; if(x<1) print 0; x" | bc
	# | bc | sed 's/^\./0./'
    echo ""
    echo "Report has finished"
}
while :
do
    case $USER_Letter in
	    #Recursive	
		R|r) 
            #Report that the report has begun
            echo "Report has started"
            getFibonacciTiming "fibonacci.out" fib_r $USER_Num "RECURSIVE"
  			break;;
		#Non-Recursive
    	N|n) 
            echo "Report has started"
		    getFibonacciTiming "fibonacci.out" fib_n $USER_Num "NON-RECURSIVE"
		    break;;
		#Other
    	*)  
            echo "Non an option. Enter either \'R\' or \'r\' to use recursive and \'N\' or \'n\' to use non-recursive method: "
	    	read USER_Letter;;  
    esac
done 