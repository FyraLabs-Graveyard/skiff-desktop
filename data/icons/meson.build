# This is where your app's icons will be installed from.

# app.svg is the primary visible icon for your application, displayed in the dock, for instance. 
# symbolic.svg is a symbolic representation of your icon, usually a black and white outline.
# source.svg isn't used in the build pipeline, but is provided as a convenience when designing your own icon.

install_data(
    'app.svg',
    rename: '@0@.svg'.format(meson.project_name()),
    install_dir: get_option('datadir') / 'icons/hicolor/scalable/apps',
)

install_data(
    'symbolic.svg',
    rename: '@0@-symbolic.svg'.format(meson.project_name()),
    install_dir: get_option('datadir') / 'icons/hicolor/symbolic/apps',
)
