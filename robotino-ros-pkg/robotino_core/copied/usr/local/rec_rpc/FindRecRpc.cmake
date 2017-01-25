IF( NOT RECRPC_DIR )
	IF( WIN32 )
		IF( CMAKE_SIZEOF_VOID_P EQUAL 8 )
			STRING( REPLACE "\\" "/" RECRPC_DIR "$ENV{RECRPC64_DIR}" )
		ELSE( CMAKE_SIZEOF_VOID_P EQUAL 8 )
			STRING( REPLACE "\\" "/" RECRPC_DIR "$ENV{RECRPC32_DIR}" )
		ENDIF( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	ELSE( WIN32 )
			SET( RECRPC_DIR "/usr/local/rec_rpc" )
	ENDIF( WIN32 )
ENDIF( NOT RECRPC_DIR )

IF( NOT RECRPC_DIR )
	IF( WIN32 )
		IF( CMAKE_SIZEOF_VOID_P EQUAL 8 )
			STRING( REPLACE "\\" "/" PROGRAMS "$ENV{ProgramFiles}" )
			SET( RECRPC_DIR "${PROGRAMS}/REC GmbH/rpc" )
		ELSE( CMAKE_SIZEOF_VOID_P EQUAL 8 )
			STRING( REPLACE "\\" "/" PROGRAMS "$ENV{ProgramFiles(x86)}" )
			SET( RECRPC_DIR "${PROGRAMS}/REC GmbH/rpc" )
		ENDIF( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	ELSE( WIN32 )
		SET( RECRPC_DIR "/usr/local/rec_rpc" )
	ENDIF( WIN32 )
ENDIF( NOT RECRPC_DIR )

SET( REC_RPC_INCLUDE_DIR "${RECRPC_DIR}/include" ) 
SET( REC_RPC_LIB_DIR "${RECRPC_DIR}/lib" ) 
SET( REC_RPC_BIN_DIR "${RECRPC_DIR}/bin" ) 

FIND_PATH(
	REC_RPC_INCLUDES
	rec/rpc/Client.h
	${REC_RPC_INCLUDE_DIR}
)

FIND_LIBRARY(
	REC_RPC_RELEASE_LIBRARY
	NAMES 
	rec_rpc
	PATHS
	${REC_RPC_LIB_DIR}
)

IF( WIN32 )
	FIND_LIBRARY(
		REC_RPC_DEBUG_LIBRARY
		NAMES 
		rec_rpcd
		PATHS
		${REC_RPC_LIB_DIR}
	)

	SET( REC_RPC_LIBRARY optimized "${REC_RPC_RELEASE_LIBRARY}" debug "${REC_RPC_DEBUG_LIBRARY}" )

	FIND_FILE(
		REC_RPC_RELEASE_DLL
		rec_rpc.dll 
		${REC_RPC_BIN_DIR}
		NO_DEFAULT_PATH 
	)
	FIND_FILE(
		REC_RPC_DEBUG_DLL
		rec_rpcd.dll 
		${REC_RPC_BIN_DIR}
		NO_DEFAULT_PATH 
	)
ELSE( WIN32 )
	SET( REC_RPC_LIBRARY "${REC_RPC_RELEASE_LIBRARY}" )
ENDIF( WIN32 )

MACRO( COPY_REC_RPC_DLLS releaseTarget debugTarget )
	CONFIGURE_FILE( ${REC_RPC_RELEASE_DLL} ${releaseTarget} COPYONLY )
    CONFIGURE_FILE( ${REC_RPC_DEBUG_DLL} ${debugTarget} COPYONLY )
ENDMACRO( COPY_REC_RPC_DLLS )

IF( LIBREC_RPC )
	SET( REC_RPC_LIB_FOUND TRUE )
ENDIF( LIBREC_RPC )

MARK_AS_ADVANCED( REC_RPC_LIB_FOUND )
MARK_AS_ADVANCED( REC_RPC_INCLUDES )