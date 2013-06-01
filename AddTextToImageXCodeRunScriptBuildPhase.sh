VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}"`
echo ' adding '$VERSION

for ICONNAME in Icon.png Icon@2x.png Icon-72.png Icon-72@2x.png Icon-Small-50.png Icon-Small-50@2x.png Icon-Small.png Icon-Small@2x.png
do
echo 'adjusting icon for '${PROJECT_DIR}/${PROJECT_NAME}/en.lproj/Images/$ICONNAME
${PROJECT_DIR}/Tools/AddTextToImage ${PROJECT_DIR}/${PROJECT_NAME}/en.lproj/Images/$ICONNAME $VERSION ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/$ICONNAME
done
