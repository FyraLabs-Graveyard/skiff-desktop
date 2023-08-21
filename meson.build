project('com.fyralabs.ValaTemplate', ['c', 'vala'], version: '0.1.0')

# Convert the app id to a GNOME style path identifier
path_identifier = '/' + meson.project_name().replace('.', '/')

subproject('blueprint-compiler', required: false)

gnome = import('gnome')
i18n = import('i18n')

subdir('data')
subdir('src')
subdir('po')

gnome.post_install(
    glib_compile_schemas: true,
    gtk_update_icon_cache: true,
    update_desktop_database: true,
)
