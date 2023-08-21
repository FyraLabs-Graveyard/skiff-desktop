# Non-code data for your application is handled here.
# Think icons, UI files, settings schemas, and other assets.
# For your convenience, we included the essentials. Make sure to rename them (and modify the contents) to use your actual app id.

subdir('icons')
subdir('ui')

# A desktop file provides basic information about the application to the shell.
# This allows the shell to display your application's name, icon, and other metadata.
# It's also required for visual launchers, such as the app drawer, to discover and launch your application.
# For more information about desktop files, see https://wiki.archlinux.org/title/desktop_entries and https://specifications.freedesktop.org/desktop-entry-spec/latest/

desktop_file = i18n.merge_file(
    input: configure_file(
        input: 'app.desktop.in.in',
        output: meson.project_name() + '.desktop.in',
        configuration: {
            'ICON_NAME': meson.project_name(),
            'COMMAND': meson.project_name(),
        },
    ),
    output: meson.project_name() + '.desktop',
    po_dir: meson.source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications',
)

desktop_file_validate = find_program('desktop-file-validate', required: false)
if desktop_file_validate.found()
    test('validate-desktop', desktop_file_validate, args: [desktop_file])
endif

# Appstream is a standard specification for representing additional metadata about applications.
# This metadata will be used within software centers, such as tauOS's catalogue.
# For more information about appstream, see https://www.freedesktop.org/software/appstream/docs/
# There's also a generator that you might find useful: https://www.freedesktop.org/software/appstream/metainfocreator/

appstream_file = i18n.merge_file(
    input: configure_file(
        input: 'appdata.xml.in.in',
        output: meson.project_name() + '.appdata.xml.in',
        configuration: {
            'APP_ID': meson.project_name(),
            'GETTEXT_PACKAGE': meson.project_name(),
        },
    ),
    output: meson.project_name() + '.appdata.xml',
    po_dir: meson.source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo',
)

appstream_util = find_program('appstreamcli', required: false)
if appstream_util.found()
    test(
        'Validate appstream file',
        appstream_util,
        args: ['validate', appstream_file, '--explain', '--strict'],
    )
endif

# GSettings provides a simple interface for your application to store user settings.
# A gschema file declares information about your application's settings.
# For more information about GSettings and the gschema format, see: https://wiki.gnome.org/HowDoI/GSettings

install_data(
    configure_file(
        input: 'gschema.xml.in',
        output: meson.project_name() + '.gschema.xml',
        configuration: {
            'APP_ID': meson.project_name(),
            'APP_PATH': path_identifier,
        },
    ),
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas'),
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
    test(
        'Validate schema file',
        compile_schemas,
        args: ['--strict', '--dry-run', meson.current_source_dir()],
    )
endif

# GResources allow you to bundle and reference assets within your application.
# Resources are specified using a gresource file.
# For more information about GResources, see: https://docs.gtk.org/gio/struct.Resource.html

gresources = gnome.compile_resources(
    'resources',
    configure_file(
        input: 'gresource.xml.in',
        output: meson.project_name() + '.gresource.xml',
        configuration: {
            'APP_ID': meson.project_name(),
            'APP_PATH': path_identifier,
        },
    ),
    source_dir: meson.current_build_dir(),
    dependencies: blueprints,
    c_name: 'resources',
    install_dir: get_option('datadir') / meson.project_name(),
)

add_project_arguments(
    '--gresourcesdir',
    meson.current_build_dir(),
    language: ['vala'],
)
