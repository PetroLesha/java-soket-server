package {
	import com.xenao.demo.jssapi.JSSApi;
	import com.xenao.demo.jssapi.events.JSSEvent;

	import flash.display.Sprite;

	public class Flash_client extends Sprite {
		private var _jss:JSSApi;

		public function Flash_client() {

			_jss = new JSSApi(true);
			_jss.addEventListener(JSSEvent.CONNECT_TO_SERVER_SOCKET, handleConnect)
			_jss.addEventListener(JSSEvent.RECEIVE_DATA, handleReceiveData)

			trace("Connecting...");
			_jss.connect("localhost", 9777);

		}

		private function handleConnect(event:JSSEvent):void {
			trace("Connected");
			var messageToServer:String = "Hello!";
			trace("Sending Data: " + messageToServer);
			_jss.sendRequest(messageToServer);

		}

		private function handleReceiveData(event:JSSEvent):void {
			var messageFromServer:String = String(event.data);
			trace("Received: " + messageFromServer);
		}
	}
}
