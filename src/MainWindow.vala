[GtkTemplate (ui = "/com/fyralabs/SkiffDesktop/mainwindow.ui")]
public class SkiffDesktop.MainWindow : He.ApplicationWindow {
    private const GLib.ActionEntry APP_ENTRIES[] = {
        { "about", action_about },
    };
    private const string BASE_URL = "https://app.skiff.com/";

    [GtkChild]
    private unowned Gtk.Box main_box;
    private WebKit.WebView webview = new WebKit.WebView ();
    private WebKit.UserScript script = new WebKit.UserScript (
        "window.IsSkiffWindowsDesktop = true;",
        WebKit.UserContentInjectedFrames.TOP_FRAME,
        WebKit.UserScriptInjectionTime.START,
        null,
        null
    );

    public MainWindow (He.Application application) {
        Object (
            application: application,
            icon_name: Config.APP_ID,
            title: _("Skiff")
        );
    }

    private Gtk.Widget on_create (WebKit.NavigationAction navigation_action) {
        var requst = navigation_action.get_request ();
        var uri = requst.get_uri ();

        if (uri.has_prefix (BASE_URL)) {
            webview.load_uri (uri);
        } else {
            new Gtk.UriLauncher (uri).launch (this, null, null);
        }

        return null;
    }

    private bool on_decide_policy (
        WebKit.WebView web_view,
        WebKit.PolicyDecision policy_decision,
        WebKit.PolicyDecisionType decision_type
    ) {
        switch (decision_type) {
            case NAVIGATION_ACTION: {
                var uri = ((WebKit.NavigationPolicyDecision)policy_decision)
                    .get_navigation_action ()
                    .get_request ()
                    .get_uri ();
                if (!uri.has_prefix (BASE_URL)) {
                    policy_decision.ignore ();
                }
                break;
            }
            case NEW_WINDOW_ACTION: {
                var uri = ((WebKit.NavigationPolicyDecision)policy_decision)
                    .get_navigation_action ()
                    .get_request ()
                    .get_uri ();
                if (uri.has_prefix (BASE_URL)) {
                    webview.load_uri (uri);
                } else {
                    new Gtk.UriLauncher (uri).launch (this, null, null);
                }
                break;
            }
            case RESPONSE:
                break;
            default:
                return false;
        }

        return true;
    }

    private void action_about () {
        new He.AboutWindow (
            this,
            _("Skiff") + Config.NAME_SUFFIX,
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
            He.Colors.ORANGE
        ).present ();
    }

    construct {
        var content_manager = webview.get_user_content_manager ();
        content_manager.add_script (script);

        var network_session = webview.get_network_session ();
        var website_data_manager = network_session.get_website_data_manager ();
        var cookie_manager = webview.network_session.get_cookie_manager ();
        cookie_manager.set_persistent_storage (
            Path.build_filename (
                website_data_manager.base_data_directory,
                "cookies"
            ),
            WebKit.CookiePersistentStorage.SQLITE
        );

        var settings = webview.get_settings ();
        settings.enable_back_forward_navigation_gestures = true;
        settings.enable_developer_extras = true;

        webview.decide_policy.connect (on_decide_policy);
        webview.create.connect (on_create);

        webview.vexpand = true;
        main_box.append (webview);

        webview.load_uri (BASE_URL);

        add_action_entries (APP_ENTRIES, this);
    }
}
