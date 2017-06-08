project(common)

set(
	SOURCES
	common.c
	xcb_common.c
	table.c
)

add_library(common STATIC ${SOURCES})
set_target_properties(common PROPERTIES POSITION_INDEPENDENT_CODE TRUE)
target_link_libraries(common ${CAIRO_LIBRARY})
