public class SkiffDesktop.MessageHandler {
    private WebKit.WebView webview;
    private WebKit.UserScript script = new WebKit.UserScript (
        """
        window.IsSkiffWindowsDesktop = true
        window.chrome = {
            webview: {
                postMessage: (v) => window.webkit.messageHandlers.skiffDesktop.postMessage(v),
                addEventListener: (_, listener) => window._skiffListener = listener,
                removeEventListener: (_, listener) => delete window._skiffListener,
            }
        }
        """,
        WebKit.UserContentInjectedFrames.TOP_FRAME,
        WebKit.UserScriptInjectionTime.START,
        null,
        null
    );

    private class NotificationItem : Object, Json.Serializable {
        public string title { get; set; }
        public string body { get; set; }
        public string thread_id { get; set; }
        public string email_id { get; set; }

        public override unowned ParamSpec? find_property (string name) {
            switch (name) {
                case "threadID":
                    name = "thread_id";
                    break;
                case "emailID":
                    name = "email_id";
                    break;
            }

            return this.get_class ().find_property (name);
        }
    }

    private class UnreadData : Object, Json.Serializable {
        public int num_unread { get; set; }

        public override unowned ParamSpec? find_property (string name) {
            switch (name) {
                case "numUnread":
                    name = "num_unread";
                    break;
            }

            return this.get_class ().find_property (name);
        }
    }

    private void display_notification (NotificationItem notification_item) {
        var notification = new Notification (notification_item.title);
        notification.set_body (notification_item.body);

        notification.set_default_action_and_target ("app.open-thread", "s", notification_item.thread_id);
        notification.add_button_with_target (_("Mark As Read"), "app.mark-as-read", "s", notification_item.thread_id);
        // notification.add_button_with_target(_("Mark As Spam"), "app.mark-as-spam", "s", notification_item.thread_id); kinda useless IMO (plus, goes over GNOME's limit :/)
        notification.add_button_with_target(  _("Trash"), "app.trash-thread", "s", notification_item.thread_id);
        notification.add_button_with_target (_("Archive"), "app.archive-thread", "s", notification_item.thread_id);

        GLib.Application.get_default ().send_notification ("meowy", notification);
    }

    public void send_notification_action (string thread_id, string action) {
        var root = new Json.Builder ()
            .begin_object ()
            .set_member_name ("type")
            .add_string_value ("notificationAction")
            .set_member_name ("data")
                .begin_object ()
                .set_member_name ("action")
                .add_string_value (action)
                .set_member_name ("threadId")
                .add_string_value (thread_id)
                .end_object ()
            .end_object ()
            .get_root ();

        var generator = new Json.Generator ();
        generator.set_root (root);

        string? json_string = generator.to_data (null);

        var dict = new VariantDict ();
        dict.insert ("message", "s", json_string);
        var args = dict.end ();

        this.webview.call_async_javascript_function (
            """
            if ('_skiffListener' in window) {
                window._skiffListener({ data: message })
            }
            """,
            -1,
            args,
            null,
            null,
            null
        );
    }

    public void on_script_message (JSC.Value val) {
        var parser = new Json.Parser ();
        parser.load_from_data (val.to_string ());

        var root = parser.get_root ();
        var root_object = root.get_object ();
        var message_type = root_object.get_string_member ("type");
        var message_data = root_object.get_member ("data");

        switch (message_type) {
            case "unreadMailCount":
                var unread_data = Json.gobject_deserialize (typeof (UnreadData), message_data) as UnreadData;
                assert (unread_data != null);

                debug ("Received unread count of %d", unread_data.num_unread);
                // TODO: do something with this count
                break;
            case "newMessageNotifications":
                var notification_data = message_data.get_object ();
                var notification_array = notification_data.get_array_member ("notificationData");

                debug ("Received %u new message notifications", notification_array.get_length ());

                foreach (var element in notification_array.get_elements ()) {
                    var notification_item = Json.gobject_deserialize (typeof (NotificationItem), element) as NotificationItem;
                    assert (notification_item != null);
                    display_notification (notification_item);
                }
                break;
            default:
                debug ("Received unknown message %s", val.to_string ());
                break;
        }
    }

    public MessageHandler (WebKit.WebView webview) {
        this.webview = webview;

        var content_manager = webview.get_user_content_manager ();
        content_manager.add_script (this.script);
        content_manager.script_message_received.connect (this.on_script_message);
        content_manager.register_script_message_handler ("skiffDesktop", null);
    }
}
