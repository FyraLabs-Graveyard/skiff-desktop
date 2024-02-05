public class SkiffDesktop.Application : He.Application {
    private const GLib.ActionEntry APP_ENTRIES[] = {
        { "quit", quit },
        { "open-thread", action_open_thread, "s" },
        { "mark-as-read", action_mark_as_read, "s" },
        { "trash-thread", action_trash_thread, "s" },
        { "archive-thread", action_archive_thread, "s" },
    };

    public Application () {
        Object (application_id: Config.APP_ID);
    }

    public static int main (string[] args) {
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        Intl.textdomain (Config.GETTEXT_PACKAGE);
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");

        var app = new SkiffDesktop.Application ();
        return app.run (args);
    }

    public override void activate () {
        this.active_window?.present ();
    }

    public override void startup () {
        Gdk.RGBA accent_color = { 0 };
        accent_color.parse ("EF5A3C");
        default_accent_color = He.Color.from_gdk_rgba (accent_color);

        resource_base_path = Config.APP_PATH;

        base.startup ();

        add_action_entries (APP_ENTRIES, this);

        new MainWindow (this);
    }

    // TODO: if someone wants to refactor this and throw the actions into enums, be my guest

    private void action_open_thread (SimpleAction action, Variant? parameter) {
        var thread_id = parameter.get_string (null);
        debug ("Got open-thread action with thread id: %s", thread_id);
        this.active_window?.present ();
        (this.active_window as MainWindow)?.message_handler.send_notification_action (thread_id, "openThread");
    }

    private void action_mark_as_read (SimpleAction action, Variant? parameter) {
        var thread_id = parameter.get_string (null);
        debug ("Got mark-as-read action with thread id: %s", thread_id);
        (this.active_window as MainWindow)?.message_handler.send_notification_action (thread_id, "markAsRead");
    }

    private void action_trash_thread (SimpleAction action, Variant? parameter) {
        var thread_id = parameter.get_string (null);
        debug ("Got trash-thread action with thread id: %s", thread_id);
        (this.active_window as MainWindow)?.message_handler.send_notification_action (thread_id, "sendToTrash");
    }

    private void action_archive_thread (SimpleAction action, Variant? parameter) {
        var thread_id = parameter.get_string (null);
        debug ("Got archive-thread action with thread id: %s", thread_id);
        (this.active_window as MainWindow)?.message_handler.send_notification_action (thread_id, "archive");
    }
}
