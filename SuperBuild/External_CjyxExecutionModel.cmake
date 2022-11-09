
set(proj CjyxExecutionModel)

# Set dependency list
set(${proj}_DEPENDENCIES "ITKv5")

if(Cjyx_BUILD_PARAMETERSERIALIZER_SUPPORT)
  set(${proj}_DEPENDENCIES ${${proj}_DEPENDENCIES} JsonCpp ParameterSerializer)
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED CjyxExecutionModel_DIR AND NOT EXISTS ${CjyxExecutionModel_DIR})
  message(FATAL_ERROR "CjyxExecutionModel_DIR variable is defined but corresponds to nonexistent directory")
endif()

if(NOT DEFINED CjyxExecutionModel_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  set(EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS)
  set(EXTERNAL_PROJECT_OPTIONAL_CMAKE_ARGS)

  if(APPLE)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS
      -DCjyxExecutionModel_DEFAULT_CLI_EXECUTABLE_LINK_FLAGS:STRING=-Wl,-rpath,@loader_path/../../../
      )
  endif()

  if(NOT DEFINED git_protocol)
    set(git_protocol "https")
  endif()

  macro(_set var type value)
    set(${var} ${value})
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS
      -D${var}:${type}=${value}
      )
  endmacro()

# _set(CjyxExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY PATH
#   ${CMAKE_BINARY_DIR}/${Cjyx_BINARY_INNER_SUBDIR}/${Cjyx_CLIMODULES_BIN_DIR})
# _set(CjyxExecutionModel_DEFAULT_CLI_LIBRARY_OUTPUT_DIRECTORY PATH
#   ${CMAKE_BINARY_DIR}/${Cjyx_BINARY_INNER_SUBDIR}/${Cjyx_CLIMODULES_LIB_DIR})
# _set(CjyxExecutionModel_DEFAULT_CLI_ARCHIVE_OUTPUT_DIRECTORY PATH
#   ${CMAKE_BINARY_DIR}/${Cjyx_BINARY_INNER_SUBDIR}/${Cjyx_CLIMODULES_LIB_DIR})
#
# _set(CjyxExecutionModel_DEFAULT_CLI_INSTALL_RUNTIME_DESTINATION STRING
#   ${Cjyx_INSTALL_CLIMODULES_BIN_DIR})
# _set(CjyxExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION STRING
#   ${Cjyx_INSTALL_CLIMODULES_LIB_DIR})
# _set(CjyxExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION STRING
#   ${Cjyx_INSTALL_CLIMODULES_LIB_DIR})

  if(Cjyx_BUILD_PARAMETERSERIALIZER_SUPPORT)
    _set(ParameterSerializer_DIR PATH ${ParameterSerializer_DIR})
    _set(JsonCpp_INCLUDE_DIR PATH ${JsonCpp_INCLUDE_DIR})

    # JsoncCpp_LIBRARY needs to be added as a CMAKE_ARGS because it contains an
    # expression that needs to be evaluated
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_CMAKE_ARGS
      -DJsonCpp_LIBRARY:PATH=${JsonCpp_LIBRARY}
      )
  endif()

  # If it applies, prepend "CMAKE_ARGS"
  if(NOT EXTERNAL_PROJECT_OPTIONAL_CMAKE_ARGS STREQUAL "")
    set(EXTERNAL_PROJECT_OPTIONAL_CMAKE_ARGS
      CMAKE_ARGS
      ${EXTERNAL_PROJECT_OPTIONAL_CMAKE_ARGS})
  endif()

  ExternalProject_SetIfNotDefined(
    ${CMAKE_PROJECT_NAME}_${proj}_GIT_REPOSITORY
    "${git_protocol}://github.com/Cjyx/CjyxExecutionModel.git"
    QUIET
    )

  ExternalProject_SetIfNotDefined(
    ${CMAKE_PROJECT_NAME}_${proj}_GIT_TAG
    # "update-tclap" # format outputs
    f19d6e88a94ba8f31ddafcff4adf185fe90d7e72 # 20210122
    QUIET
    )

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-${EXTERNAL_PROJECT_BUILD_TYPE}-build)

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    GIT_REPOSITORY "${${CMAKE_PROJECT_NAME}_${proj}_GIT_REPOSITORY}"
    GIT_TAG "${${CMAKE_PROJECT_NAME}_${proj}_GIT_TAG}"
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      ${EXTERNAL_PROJECT_DEFAULTS}
      -DITK_DIR:PATH=${ITK_DIR}

      -DCjyxExecutionModel_USE_SERIALIZER:BOOL=${Cjyx_BUILD_PARAMETERSERIALIZER_SUPPORT}
      -DCjyxExecutionModel_USE_JSONCPP:BOOL=${Cjyx_BUILD_PARAMETERSERIALIZER_SUPPORT}
      -DDCMTK_DIR:PATH=${DCMTK_DIR}
      -DGENERATECLP_USE_MD5:BOOL=ON #Needed to avoid rebuilding CLP applications
      -DCjyxExecutionModel_LIBRARY_PROPERTIES:STRING=${Cjyx_LIBRARY_PROPERTIES}
      -DCjyxExecutionModel_INSTALL_BIN_DIR:PATH=${${LOCAL_PROJECT_NAME}_INSTALL_LIB_DIR}
      -DCjyxExecutionModel_INSTALL_LIB_DIR:PATH=${${LOCAL_PROJECT_NAME}_INSTALL_LIB_DIR}
      #-DCjyxExecutionModel_INSTALL_SHARE_DIR:PATH=${Cjyx_INSTALL_ROOT}share/${CjyxExecutionModel}
      -DCjyxExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Cjyx_BINARY_INNER_SUBDIR}/${Cjyx_CLIMODULES_BIN_DIR}
      -DCjyxExecutionModel_DEFAULT_CLI_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Cjyx_BINARY_INNER_SUBDIR}/${Cjyx_CLIMODULES_LIB_DIR}
      -DCjyxExecutionModel_DEFAULT_CLI_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Cjyx_BINARY_INNER_SUBDIR}/${Cjyx_CLIMODULES_LIB_DIR}
      -DCjyxExecutionModel_DEFAULT_CLI_INSTALL_RUNTIME_DESTINATION:STRING=${Cjyx_INSTALL_CLIMODULES_BIN_DIR}
      -DCjyxExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION:STRING=${Cjyx_INSTALL_CLIMODULES_LIB_DIR}
      -DCjyxExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION:STRING=${Cjyx_INSTALL_CLIMODULES_LIB_DIR}
      -DCjyxExecutionModel_DEFAULT_CLI_TARGETS_FOLDER_PREFIX:STRING=Module-
      ${EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS}
      ${EXTERNAL_PROJECT_OPTIONAL_CMAKE_ARGS}
      # macOS
      -DCMAKE_MACOSX_RPATH:BOOL=${BRAINSTOOLS_MACOSX_RPATH}
      #INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

  ExternalProject_GenerateProjectDescription_Step(${proj})

  set(CjyxExecutionModel_DIR ${EP_BINARY_DIR})

  #-----------------------------------------------------------------------------
  # Launcher setting specific to build tree

  set(${proj}_LIBRARY_PATHS_LAUNCHER_BUILD ${CjyxExecutionModel_DIR}/ModuleDescriptionParser/bin/<CMAKE_CFG_INTDIR>)
  mark_as_superbuild(
    VARS ${proj}_LIBRARY_PATHS_LAUNCHER_BUILD
    LABELS "LIBRARY_PATHS_LAUNCHER_BUILD"
    )

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

mark_as_superbuild(
  VARS CjyxExecutionModel_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
