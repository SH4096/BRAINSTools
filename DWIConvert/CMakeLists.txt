
project(DWIConvert)

#-----------------------------------------------------------------------------
# Dependencies.
#

#
# ITK
#

FindITKUtil( DWIConvert_ITK
  ITKImageIntensity
  ITKImageStatistics
  ITKTestKernel
  ITKIODCMTK
  ITKIORAW
  ITKDCMTK
  ITKNrrdIO
)

#-----------------------------------------------------------------------------
enable_testing()

list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_LIST_DIR})

set(DWIConvertSupportLib_SRCS
#  FSLToNrrd.cxx
#  NrrdToFSL.cxx
  NRRDDWIConverter.h
  NRRDDWIConverter.cxx
  FSLDWIConverter.h
  FSLDWIConverter.cxx
  DWIConvertUtils.h
  DWIConvertUtils.cxx
  DWIConverterFactory.h
  DWIConverterFactory.cxx
  DWIConverter.h
  DWIConverter.cxx
  DWIDICOMConverterBase.h
  DWIDICOMConverterBase.cxx
  GEDWIConverter.h
  GenericDWIConverter.h
  HitachiDWIConverter.h
  PhilipsDWIConverter.h
  SiemensDWIConverter.h
  StringContains.h
  GEDWIConverter.cxx
  GenericDWIConverter.cxx
  HitachiDWIConverter.cxx
  PhilipsDWIConverter.cxx
  SiemensDWIConverter.cxx
  SiemensDWIConverter.hxx
  DWIConvertLib.cxx
  DWIConvertLib.h)

set(MODULE_FOLDER "Module-DWIConvert")

add_library(DWIConvertSupportLib STATIC ${DWIConvertSupportLib_SRCS})
target_link_libraries(DWIConvertSupportLib ${DWIConvert_ITK_LIBRARIES} BRAINSCommonLib)
set_target_properties(DWIConvertSupportLib PROPERTIES FOLDER ${MODULE_FOLDER})

set(PROGS_LIST_1
  Convert4DImageTo3DSeries
  )
foreach(prog ${PROGS_LIST_1})
  add_executable(${prog} ${prog}.cxx)
  target_link_libraries(${prog} DWIConvertSupportLib)
  set_target_properties(${prog} PROPERTIES FOLDER ${MODULE_FOLDER})
endforeach()

#-----------------------------------------------------------------------------
# SEMMacroBuildCLI(
#     NAME ${MODULE_NAME}
#     LOGO_HEADER ${Cjyx_SOURCE_DIR}/Resources/NAMICLogo.h
#     TARGET_LIBRARIES DWIConvertSupportLib
# )

# several files needed down in ExtenededTesting
StandardBRAINSBuildMacro(NAME DWIConvert EXECUTABLE_ONLY
  TARGET_LIBRARIES DWIConvertSupportLib)

set(DWIConvertTest_SRC)
foreach(f ${DWIConvertSupportLib_SRCS})
  list(APPEND DWIConvertTest_SRC
          ${CMAKE_CURRENT_LIST_DIR}/${f})
endforeach()

if(BUILD_TESTING AND NOT BRAINSTools_DISABLE_TESTING)
  add_subdirectory(TestSuite)
endif()
