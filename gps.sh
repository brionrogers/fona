#!/bin/bash

TEXT_MESSAGE
LONGITUDE
LATITUDE

getSensorData()
{
	sudo pkill screen
	clearLog
	sudo screen -dmS gps -L log.txt /dev/serial0 115200
	sudo screen -S gps -X stuff "AT+CGNSINF^M"
	
	WAIT_FOR_FILE_GROWTH=true
	
	while [ $WAIT_FOR_FILE_GROWTH -eq 0]; do
		if [ stat --printf="%s" /home/pi/log.txt > 0 ]; then
			sleep 1
		else
			WAIT_FOR_FILE_GROWTH=false
		fi
	done
	
}

getParsedSensorData()
{
echo "Entering getParsedSensorData()"

input="/home/pi/log.txt"
while IFS= read -r var
do
  checkOutput=${var:0:8}
   if [ $checkOutput = "+CGNSINF" ]
        then
			resultString=${var:10:${#var}}
			echo $resultString >> coords.txt
			
			GNSS_RUN_STATUS=$(echo $resultString | cut -d',' -f1)
			printf " GNSS Run Status: "
			printf " GNSS Run Status: " >> output.txt
			echo $GNSS_RUN_STATUS
			echo $GNSS_RUN_STATUS >> output.txt     # GNSS Run Status
			
			FIX_STATUS=$(echo $resultString | cut -d',' -f2)
			printf " Fix Status: "
			printf " Fix Status: " >> output.txt
			echo $FIX_STATUS
			echo $FIX_STATUS >> output.txt     # Fix Status
			
			UTC_DATE_AND_TIME=$(echo $resultString | cut -d',' -f3)
			printf " UTC Date & Time: "
			printf " UTC Date & Time: " >> output.txt
			echo $UTC_DATE_AND_TIME
			echo $UTC_DATE_AND_TIME >> output.txt     # UTC Date & Time
			
			LATITUDE=$(echo $resultString | cut -d',' -f4)
			printf " Latitude: "
			printf " Latitude: " >> output.txt
			echo $LATITUDE
			echo $LATITUDE >> output.txt     # Latitude
			
			LONGITUDE=$(echo $resultString | cut -d',' -f5)
			printf " Longitude: "
			printf " Longitude: " >> output.txt
			echo $LONGITUDE
			echo $LONGITUDE >> output.txt     # Longitude
			
			MSL_ALTITUDE=$(echo $resultString | cut -d',' -f6)
			printf " MSL Altitude: "
			printf " MSL Altitude: " >> output.txt
			echo $MSL_ALTITUDE
			echo $MSL_ALTITUDE >> output.txt     # MSL Altitude
			
			SPEED_OVER_GROUND=$(echo $resultString | cut -d',' -f7)
			printf " Speed Over Ground: "
			printf " Speed Over Ground: " >> output.txt
			echo $SPEED_OVER_GROUND
			echo $SPEED_OVER_GROUND >> output.txt     # Speed Over Ground
			
			COURSE_OVER_GROUND=$(echo $resultString | cut -d',' -f8)
			printf " Course Over Ground: "
			printf " Course Over Ground: " >> output.txt
			echo $COURSE_OVER_GROUND
			echo $COURSE_OVER_GROUND >> output.txt     # Course Over Ground
			
			FIX_MODE=$(echo $resultString | cut -d',' -f9)
			printf " Fix Mode: "
			printf " Fix Mode: " >> output.txt
			echo $FIX_MODE
			echo $FIX_MODE >> output.txt     # Fix Mode
			
			RESERVED_ONE=$(echo $resultString | cut -d',' -f10)
			printf " Reserved1: "
			printf " Reserved1: " >> output.txt
			echo $RESERVED_ONE
			echo $RESERVED_ONE >> output.txt    # Reserved1
			
			HDOP=$(echo $resultString | cut -d',' -f11)
			printf " HDOP: "
			printf " HDOP: " >> output.txt
			echo $HDOP
			echo $HDOP >> output.txt    # HDOP
			
			PDOP=$(echo $resultString | cut -d',' -f12)
			printf " PDOP: "
			printf " PDOP: " >> output.txt
			echo $PDOP
			echo $PDOP >> output.txt    # PDOP
			
			VDOP=$(echo $resultString | cut -d',' -f13)
			printf " VDOP: "
			printf " VDOP: " >> output.txt
			echo $VDOP
			echo $VDOP >> output.txt    # VDOP
			
			RESERVED_TWO=$(echo $resultString | cut -d',' -f14)
			printf " Reserved2: "
			printf " Reserved2: " >> output.txt
			echo $RESERVED_TWO
			echo $RESERVED_TWO >> output.txt    # Reserved2
			
			GNSS_SATELLITES_VIEW=$(echo $resultString | cut -d',' -f15)
			printf " GNSS Satellites in View: "
			printf " GNSS Satellites in View: " >> output.txt
			echo $GNSS_SATELLITES_VIEW
			echo $GNSS_SATELLITES_VIEW >> output.txt    # GNSS Satellites in View
			
			GNSS_SATALLITES_USED=$(echo $resultString | cut -d',' -f16)
			printf " GNSS Satellites Used: "
			printf " GNSS Satellites Used: " >> output.txt
			echo $GNSS_SATELLITES_USED
			echo $GNSS_SATELLITES_USED >> output.txt    # GNSS Satellites Used

			GLONASS_SATELLITES_USED=$(echo $resultString | cut -d',' -f17)
			printf " GLONASS Satellites Used: "
			printf " GLONASS Satellites Used: " >> output.txt
			echo $GLONASS_SATELLITES_USED
			echo $GLONASS_SATELLITES_USED >> output.txt    # GLONASS Satellites Used
			
			RESERVED_THREE=$(echo $resultString | cut -d',' -f18)
			printf " Reserved3: "
			printf " Reserved3: " >> output.txt
			echo $RESERVED_THREE
			echo $RESERVED_THREE >> output.txt    # Reserved3
			
			CN0_MAX=$(echo $resultString | cut -d',' -f19)
			printf " C/N0 Max: "
			printf " C/N0 Max: " >> output.txt
			echo $CN0_MAX
			echo $CN0_MAX >> output.txt    # C/N0 Max
			
			HPA=$(echo $resultString | cut -d',' -f20)
			printf " HPA: "
			printf " HPA: " >> output.txt
			echo $HPA
			echo $HPA >> output.txt    # HPA
			
			VPA=$(echo $resultString | cut -d',' -f21)
			printf " VPA: "
			printf " VPA: " >> output.txt
			echo $VPA
			echo $VPA >> output.txt    # VPA

        fi
	done < "$input"
	
	echo "Leaving getParsedSensorData()"
	closeGPSSession

	
}

closeGPSSession()
{
	sudo screen -X -S gps quit
	sudo pkill screen
	checkContinue "Continue closeGPSSession()?"
}

checkContinue() 
{
	read -p "$1 " choice
	case $choice in
		[Yy]* ) ;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
	esac
	
}

sendTextMessage() 
{
	clearLog
	echo "Entering sendTextMessage()"

	read -p "Enter a cell number: " phoneNumber
	read -p "Enter a message: " textMessage

	PHONE_NUMBER=$phoneNumber
	TEXT_MESSAGE=$textMessage
	
	echo $PHONE_NUMBER
	echo $TEXT_MESSAGE
	
	sudo screen -S gps -X stuff "AT+CMGS=\"$PHONE_NUMBER\"^M"
	sudo screen -S gps -X stuff "$TEXT_MESSAGE^M"
	sudo screen -S gps -X stuff "^Z"
	
	checkContinue "Continue sendTextMessage()?"
	closeGPSSession
}

sendGPSTextMessage() 
{
	if [ $(stat --printf="%s" /home/pi/log.txt) <= 0 ]; then
			echo "Sleeping..."
			sleep 3
		else
			WAIT_FOR_FILE_GROWTH=false
		fi
	
	echo "Entering sendGPSTextMessage()"

	read -p "Enter a cell number: " phoneNumber
		
	PHONE_NUMBER=$phoneNumber
	
	getCoords
	
	TEXT_MESSAGE="Latitude: "$LATITUDE", Longitude: "$LONGITUDE", Altitude: "$MSL_ALTITUDE
	echo "Text Message:"$TEXT_MESSAGE
	#sudo screen -S gps -X stuff "AT+CMGF=1^M"
	
	echo $PHONE_NUMBER
	echo $TEXT_MESSAGE
	
	#  screen -S gps -X stuff "AT+CMGS=\"$PHONE_NUMBER\"^M"
	# sudo screen -S gps -X stuff "$TEXT_MESSAGE^M"
	# sudo screen -S gps -X stuff "^Z"
	
	checkContinue "Continue sendGpsTextMessage"
	closeGPSSession
}

getCoords()
{
echo "Entering getCoords()"

input="/home/pi/log.txt"
echo $input

while IFS= read -r var
do
  checkOutput=${var:0:8}
   if [ $checkOutput = "+CGNSINF" ]
        then
			resultString=${var:10:${#var}}
			echo $resultString >> coords.txt
			
			GNSS_RUN_STATUS=$(echo $resultString | cut -d',' -f1) # GNSS Run Status
			echo $GNSS_RUN_STATUS
			
			FIX_STATUS=$(echo $resultString | cut -d',' -f2) # Fix Status
			echo $FIX_STATUS
			
			UTC_DATE_AND_TIME=$(echo $resultString | cut -d',' -f3) # UTC Date & Time		
			echo $UTC_DATE_AND_TIME
			
			LATITUDE=$(echo $resultString | cut -d',' -f4) # Latitude
			echo $LATITUDE
			
			LONGITUDE=$(echo $resultString | cut -d',' -f5) # Longitude
			echo $LONGITUDE
			
			MSL_ALTITUDE=$(echo $resultString | cut -d',' -f6) # MSL Altitude
			echo $MSL_ALTITUDE
			
			SPEED_OVER_GROUND=$(echo $resultString | cut -d',' -f7) # Speed Over Ground
			echo $SPEED_OVER_GROUND
			
			COURSE_OVER_GROUND=$(echo $resultString | cut -d',' -f8) # Course Over Ground
			echo $COURSE_OVER_GROUND
			
			FIX_MODE=$(echo $resultString | cut -d',' -f9) # Fix Mode
			echo $FIX_MODE
			
			RESERVED_ONE=$(echo $resultString | cut -d',' -f10) # Reserved1
			echo $RESERVED_ONE
			
			HDOP=$(echo $resultString | cut -d',' -f11) # HDOP
			echo $HDOP
			
			PDOP=$(echo $resultString | cut -d',' -f12) # PDOP
			echo $PDOP
			
			VDOP=$(echo $resultString | cut -d',' -f13) # VDOP
			echo $VDOP
			
			RESERVED_TWO=$(echo $resultString | cut -d',' -f14) # Reserved2
			echo $RESERVED_TWO
			
			GNSS_SATELLITES_VIEW=$(echo $resultString | cut -d',' -f15) # GNSS Satellites in View
			echo $GNSS_SATELLITES_VIEW
			
			GNSS_SATALLITES_USED=$(echo $resultString | cut -d',' -f16) # GNSS Satellites Used
			echo $GNSS_SATELLITES_USED

			GLONASS_SATELLITES_USED=$(echo $resultString | cut -d',' -f17) # GLONASS Satellites Used
			echo $GLONASS_SATELLITES_USED
			
			RESERVED_THREE=$(echo $resultString | cut -d',' -f18) # Reserved3
			echo $RESERVED_THREE
			
			CN0_MAX=$(echo $resultString | cut -d',' -f19)  # C/N0 Max
			echo $CN0_MAX
			
			HPA=$(echo $resultString | cut -d',' -f20) # HPA
			echo $HPA

			VPA=$(echo $resultString | cut -d',' -f21) # VPA
			echo $VPA

        fi
	done < "$input"
	
	echo "Latitude: "$LATITUDE" "
	echo "Longitude: "$LONGITUDE" "
	echo "Altitude: "$MSL_ALTITUDE" "
	
	echo "Leaving getCoords()"	
}

clearLog() {
echo "Clearing Logs..."
	sudo cat /dev/null > /home/pi/log.txt
}

clearLogs() {
	sudo cat /dev/null > /home/pi/log.txt
	sudo cat /dev/null > /home/pi/output.txt
	sudo cat /dev/null > /home/pi/coords.txt
}

# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "Select your action..."
	echo "1) Activate gps sensor..."
	echo "2) Get Parsed Sensor Data..."
	echo "3) Send A Text Message..."
	echo "4) Send A GPS Text Message..."
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
		[1]* ) getSensorData; break;;
        [2]* ) getParsedSensorData; break;;
		[3]* ) sendTextMessage; break;;
		[4]* ) sendGPSTextMessage; break;;
        * ) echo "Please answer yes or no.";;
	esac
}


while true
do
	show_menus
	read_options
done

echo "Ending script..."

: > $input

