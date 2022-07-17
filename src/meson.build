
if qt6_dep.found()
	processed = qt6.preprocess(
		qresources : 'resources.qrc',
	)
endif

source = [
	'main.cpp',
]


source += processed

executable(
	meson.project_name(),
	sources: [source],
	dependencies: [qt6_dep, gst_dep],
	install: true,
)