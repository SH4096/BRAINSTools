#
# Test CLI executables
#
include_regular_expression("^.*$")

# CjyxExecutionModel
find_package(CjyxExecutionModel REQUIRED GenerateCLP)
include(${GenerateCLP_USE_FILE})

include_directories(${DWIConvert_SOURCE_DIR})
include_directories(${DWIConvert_BINARY_DIR})
#include_directories(${ModuleDescriptionParser_SOURCE_DIR})
#include_directories (${TCLAP_SOURCE_DIR}/include)

set (CLP DWIConvert)
add_executable(${CLP}Test ${CLP}Test.cxx)
add_dependencies(${CLP}Test ${CLP})

target_link_libraries(${CLP}Test ${CLP}Lib ${LIBICONV_LIBRARIES})

set_target_properties(${CLP}Test PROPERTIES LABELS ${CLP})
set_target_properties(${CLP}Test PROPERTIES FOLDER ${MODULE_FOLDER})

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------

set(TEST_DATA "${Cjyx_SOURCE_DIR}/Testing/Data/Input")
set(TEMP "${Cjyx_BINARY_DIR}/Testing/Temporary")

# DWIConvert tests
add_test(
    NAME ${CLP}Test
    COMMAND ${Cjyx_LAUNCH_COMMAND} $<TARGET_FILE:${CLP}Test>
    ModuleEntryPoint
    --useBMatrixGradientDirections
    --inputDicomDirectory ${TEST_DATA}/DWIDicom
    --outputDirectory ${TEMP}
    --outputVolume DWIDicom.nhdr
  )
set_property(TEST ${CLP}Test PROPERTY LABELS ${CLP})

