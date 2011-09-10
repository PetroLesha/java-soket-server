package com.xenao.demo.jssapi {
	import com.xenao.demo.jssapi.enums.JSSClientDisconnectionReason;

	import flash.events.EventDispatcher;

	public class JSSApi extends EventDispatcher{

		private var _connection:JSSConnection;

		public function JSSApi(debug:Boolean = false) {
			_connection = new JSSConnection(this, debug);
		}

		/*---------------------------- Delegated ------------------------*/
		public function connect(host:String, port:int):void {
			_connection.connect(host, port);
		}

		public function disconnect(reason:String = JSSClientDisconnectionReason.MANUAL_DISCONNECT):void {
			_connection.disconnect(reason);
		}

		public function sendRequest(request:String):void {
			_connection.sendRequest(request);
		}

		public function get host():String {
			return _connection.host;
		}

		public function get port():int {
			return _connection.port;
		}

		public function isConnect():Boolean {
			return _connection.isConnect();
		}

	}
	
}