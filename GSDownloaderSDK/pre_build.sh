# Sets the target folders and the final framework product.

FMK_NAME=GSDownloaderSDK

FMK_VERSION=A



# Install dir will be the final output to the framework.

# The following line create it in the root folder of the current project.

INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.

#WRK_DIR=build

DEVICE_DIR=Release-iphoneos/${FMK_NAME}.framework

SIMULATOR_DIR=Release-iphonesimulator/${FMK_NAME}.framework

cd ${PROJECT_DIR}
rm -rf build

# Building both architectures.

xcodebuild -sdk iphoneos -configuration "Release"

xcodebuild -sdk iphonesimulator -configuration "Release"



# Cleaning the oldest.

if [ -d "${INSTALL_DIR}" ]

then

rm -rf "${INSTALL_DIR}"

fi



# Creates and renews the final product folder.

mkdir -p "${INSTALL_DIR}"

mkdir -p "${INSTALL_DIR}/Versions"

mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}"

mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources"

mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers"



# Creates the internal links.

# It MUST uses relative path, otherwise will not work when the folder is copied/moved.

ln -s "${FMK_VERSION}" "${INSTALL_DIR}/Versions/Current"

ln -s "Versions/Current/Headers" "${INSTALL_DIR}/Headers"

ln -s "Versions/Current/Resources" "${INSTALL_DIR}/Resources"

ln -s "Versions/Current/${FMK_NAME}" "${INSTALL_DIR}/${FMK_NAME}"

#into build
cd build

# Copies the headers and resources files to the final product folder.

cp -R "${DEVICE_DIR}/Headers/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/"



# Removes the binary and header from the resources folder.

rm -r "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/Headers" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/${FMK_NAME}"



# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.

lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/Versions/${FMK_VERSION}/${FMK_NAME}"

cd ..

rm -rf build

#rm -r "${WRK_DIR}"