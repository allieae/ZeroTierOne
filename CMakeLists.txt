# CMake build script for libzerotiercore.a

cmake_minimum_required (VERSION 2.8)
project (zerotiercore)

set (PROJ_DIR ${PROJECT_SOURCE_DIR})
set (ZT_DEFS -std=c++11)

file(GLOB core_src_glob ${PROJ_DIR}/node/*.cpp)
add_library(zerotiercore STATIC ${core_src_glob})

target_compile_options(zerotiercore PRIVATE ${ZT_DEFS})

option(BUILD_DOCS "Build documentation")

# check if Doxygen is installed
find_package(Doxygen)
if (DOXYGEN_FOUND)
    # set input and output config files
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    # request to configure the file
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
    message("Doxygen build started")

    # note the option ALL which allows to build the docs together with the application
    add_custom_target( doc_doxygen ALL
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM )
else (DOXYGEN_FOUND)
  message("Doxygen must be installed to generate the doxygen")
endif (DOXYGEN_FOUND)
