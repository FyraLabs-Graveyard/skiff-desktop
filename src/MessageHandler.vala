public class SkiffDesktop.MessageHandler {
    private class NotificationItem : Object {
        public string title { get; set; }
        public string body { get; set; }
        public string threadID { get; set; }
        public string emailID { get; set; }
    }

    private class NotificationData : Object {
        public NotificationItem[] notificationData { get; set; }
    }

    private class UnreadData : Object {
        public int numUnread { get; set; }
    }

    public void on_script_message (JSC.Value val) {
        var parser = new Json.Parser ();
        parser.load_from_data (val.to_string ());

        var root = parser.get_root ();
        var message_type = root.get_object ().get_string_member ("type");

        switch (message_type) {
            case "unreadMailCount":
                var unread_data = Json.gobject_deserialize (typeof (UnreadData), root) as UnreadData;
                assert (unread_data != null);
                print ("unread count: %d\n", unread_data.numUnread);
                break;
            case "newMessageNotifications":
                var notification_data = Json.gobject_deserialize (typeof (NotificationData), root) as NotificationData;
                assert (notification_data != null);
                print ("notifications: %d\n", notification_data.notificationData.length);
                break;
            default:
                print ("Received unknown message %s\n", val.to_string ());
                break;
        }
    }
}
