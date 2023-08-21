[GtkTemplate (ui = "/com/fyralabs/ValaTemplate/mainwindow.ui")]
public class ValaTemplate.MainWindow : He.ApplicationWindow {
    private const GLib.ActionEntry APP_ENTRIES[] = {
        { "about", action_about },
    };

    public MainWindow (He.Application application) {
        Object (
            application: application,
            icon_name: Config.APP_ID,
            title: _("Vala Template")
        );
    }

    private void action_about () {
        new He.AboutWindow (
            this,
            _("Vala Template") + Config.NAME_SUFFIX,
            Config.APP_ID,
            Config.VERSION,
            Config.APP_ID,
            "https://weblate.fyralabs.com/addons/tauOS/vala-template/",
            "https://github.com/tau-OS/vala-template/issues",
            "https://github.com/tau-OS/vala-template",
            { "Fyra Labs" },
            { "Fyra Labs" },
            2023,
            He.AboutWindow.Licenses.GPLV3,
            He.Colors.PURPLE
        ).present ();
    }


    construct {
        add_action_entries (APP_ENTRIES, this);
    }
}
