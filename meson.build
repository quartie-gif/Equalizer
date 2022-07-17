project('Equalizer',
        'cpp',
	default_options : ['cpp_std=c++17'])




qt6 = import('qt6')
qt6_modules_dep = ['Core', 'Gui', 'Widgets', 'Qml', 'Quick', 'multimedia', 'multimediawidgets']
qt6_dep = dependency('qt6', modules: qt6_modules_dep)
gst_dep = dependency('gstreamer-1.0', version : '1.20.2',
  fallback : ['gstreamer', 'gst_dep'])

pkg_mod = import('pkgconfig')
python3 = import('python').find_installation()

# moc_files = qt6.preprocess(moc_headers : 'MainWindow.h',
#                            dependencies : qt6_dep)
devenv = environment()
devenv.set('QTDIR', '/usr/local/Cellar/qt/6.3.0/lib/')
devenv.set('GST_PLUGIN_PATH', '/usr/local/lib/gstreamer-1.0')


meson.add_devenv(devenv)

subdir('src')
subdir('tests')