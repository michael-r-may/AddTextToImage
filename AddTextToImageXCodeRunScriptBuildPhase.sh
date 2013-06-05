if [ "$CONFIGURATION" == "Debug" ]; then
    for ICONNAME in Icon.png Icon@2x.png Icon-72.png Icon-72@2x.png Icon-Small-50.png Icon-Small-50@2x.png Icon-Small.png Icon-Small@2x.png
    do
       	"${PROJECT_DIR}/Tools/AddTextToImage" "${PROJECT_DIR}/${PROJECT_NAME}/en.lproj/Images/$ICONNAME" "${INFOPLIST_FILE}" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/$ICONNAME"
    done
fi
