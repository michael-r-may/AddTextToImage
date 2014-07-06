if [ "$CONFIGURATION" == "Ad Hoc Release" ]; then
	ICONNAMES=$(find ./Images.xcassets/AppIcon.appiconset -type f -name \*.png)
	
	for ICONNAME in ${ICONNAMES} 
	do
		ICONFILENAME=$(basename $ICONNAME)
		echo "${PROJECT_DIR}/Tools/AddTextToImage" ${ICONNAME} "${INFOPLIST_FILE}" "${TARGET_BUILD_DIR}/${ICONFILENAME}"	
   		"${PROJECT_DIR}/Tools/AddTextToImage" ${ICONNAME} "${INFOPLIST_FILE}" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/${ICONFILENAME}"	
	done
fi
