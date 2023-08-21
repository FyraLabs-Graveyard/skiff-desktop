[GtkTemplate (ui = "/com/fyralabs/SkiffDesktop/mainwindow.ui")]
public class SkiffDesktop.MainWindow : He.ApplicationWindow {
    private const GLib.ActionEntry APP_ENTRIES[] = {
        { "about", action_about },
    };
    private const string baseURL = "https://app.skiff.com/";

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

    private bool on_decide_policy (
        WebKit.WebView web_view,
        WebKit.PolicyDecision policy_decision,
        WebKit.PolicyDecisionType decision_type
    ) {
        switch (decision_type) {
            case NAVIGATION_ACTION: {
                var uri = ((WebKit.NavigationPolicyDecision)policy_decision).get_navigation_action ().get_request ().get_uri ();
                if (!uri.has_prefix (baseURL)) {
                    policy_decision.ignore ();
                }
                break;
            }
            case NEW_WINDOW_ACTION: {
                var uri = ((WebKit.NavigationPolicyDecision)policy_decision).get_navigation_action ().get_request ().get_uri ();
                if (uri.has_prefix (baseURL)) {
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

        webview.vexpand = true;
        webview.load_uri (baseURL);
        webview.decide_policy.connect (on_decide_policy);

        main_box.append (webview);

        add_action_entries (APP_ENTRIES, this);
    }
}
