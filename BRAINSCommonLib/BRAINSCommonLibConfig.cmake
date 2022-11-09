# BRAINSCommonLib could be installed anywhere, so set all paths based on where
# this file was found (which should be the lib/BRAINSCommonLib directory of the
# installation)
get_filename_component(BRAINSCommonLib_CONFIG_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

set(BRAINSCommonLib_USE_FILE "${BRAINSCommonLib_CONFIG_DIR}/UseBRAINSCommonLib.cmake")
#set(ITK_DIR "")
