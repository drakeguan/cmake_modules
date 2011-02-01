FUNCTION(FIND_MAYA_LIBRARY component)
    IF(WIN32)
	IF(MSVC)
	    SET(MAYA_EXTENSION ".mll")
	ENDIF(MSVC)
	# refer to: http://crackart.org/wiki/HowTo/CMakeForMaya
	#SET ( SCENG_MAYA_2010_DEFINITIONS "_AFXDLL,_MBCS,NT_PLUGIN,REQUIRE_IOSTREAM" )
    ELSEIF(APPLE)
    ELSE(WIN32)
	FIND_LIBRARY(MAYA_${component}_LIBRARY
	    NAMES
	    ${component}
	    PATHS
	    /usr/autodesk/maya2011-x64/lib/
	    )
	MARK_AS_ADVANCED(MAYA_${component}_LIBRARY)
	IF(MAYA_${component}_LIBRARY)
	    LIST(APPEND MAYA_LIBRARIES ${MAYA_${component}_LIBRARY})
	ENDIF(MAYA_${component}_LIBRARY)
    ENDIF(WIN32)
ENDFUNCTION(FIND_MAYA_LIBRARY)

IF(WIN32)
    FIND_PATH(MAYA_INCLUDE_DIR maya/MTypes.h
	PATHS
	"$ENV{PROGRAMFILES}/Autodesk/Maya2011/include/"
	"$ENV{MAYA_LOCATION}/include"
	)
ELSEIF(APPLE)
ELSE(WIN32)
    FIND_PATH(MAYA_INCLUDE_DIR maya/MTypes.h
	PATHS
	/usr/autodesk/maya2011-x64/include/
	)
ENDIF(WIN32)
MARK_AS_ADVANCED(MAYA_INCLUDE_DIR)

FIND_MAYA_LIBRARY(OpenMaya)
FIND_MAYA_LIBRARY(Foundation)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MAYA DEFAULT_MSG MAYA_OpenMaya_LIBRARY MAYA_INCLUDE_DIR)

IF(MAYA_FOUND)
    SET(CMAKE_CXX_COMPILER g++-4.1)
    SET(CMAKE_C_FLAGS "-DBits64_ -m64 -DUNIX -D_BOOL -DLINUX -DFUNCPROTO -D_GNU_SOURCE -DLINUX_64 -fPIC -fno-strict-aliasing -DREQUIRE_IOSTREAM -Wno-deprecated -O3 -Wall -Wno-multichar -Wno-comment -Wno-sign-compare -funsigned-char -Wno-reorder -fno-gnu-keywords -ftemplate-depth-25 -pthread")
    SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Wno-deprecated -fno-gnu-keywords")
    SET(CMAKE_SHARED_LINKER_FLAGS "-Wl,-Bsymbolic")

    SET(MAYA_INCLUDE_DIRS ${MAYA_INCLUDE_DIR})
    LIST(APPEND MAYA_LIBRARIES 
	${MAYA_OPENMAYA_LIBRARY}
	${MAYA_FOUNDATION_LIBRARY}
	)
    FOREACH(component ${MAYA_FIND_COMPONENTS})
	FIND_MAYA_LIBRARY(${component})
    ENDFOREACH(component)
ENDIF(MAYA_FOUND)
