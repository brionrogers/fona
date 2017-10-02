#!/bin/bash

getSensorDate()
{
	sudo screen -S gps -X stuff "AT+CGNSINF^M"
}

getParsedSensorDate()
{
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
	
	closeGPSSession
}

closeGPSSession()
{
	sudo screen -X -S gps quit
}

sendTextMessage() 
{
	PHONE_NUMBER=$1
	TEXT_MESSAGE=$2
	COMMAND='AT+CMGS="$1"'
	
	sudo screen -S gps -X stuff "AT+CMGS="$1^M"
	
	# AT+CMGS="+31628870634"
}

echo "Starting script.."
echo "Select your action..."
echo "1) Retrieve sensor data..."
echo "2) Get Parsed Sensor Data..."
echo "3) Send A  Text Message..."

while true; do
    read -p "Select?" yn
    case $yn in
        [1]* ) getSensorData; break;;
        [2]* ) getParsedData; break;;
		[3]* ) sendTextMessage; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

getSensorDate
getParsedSensorDate
sendTextMessage
echo "Ending script..."

: > $input

