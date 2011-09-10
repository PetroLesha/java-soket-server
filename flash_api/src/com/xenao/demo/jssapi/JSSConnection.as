package com.xenao.demo.jssapi {
	import com.xenao.demo.jssapi.enums.JSSClientDisconnectionReason;
	import com.xenao.demo.jssapi.events.JSSEvent;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	public class JSSConnection {

		private var _debug:Boolean;
		private var _dispatcher:IEventDispatcher;

		private var _host:String;
		private var _port:int;
		private var _socket:Socket;

		private var _isConnected:Boolean;

		public function JSSConnection(dispatcher:IEventDispatcher, debug:Boolean = false) {
			_dispatcher = dispatcher;
			_debug = debug;

			createSocketAndAddHandlers();
		}

		private function createSocketAndAddHandlers():void {
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, handleSocketConnect);
			_socket.addEventListener(Event.CLOSE, handleSocketClose);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, handleSocketError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
		}

		public function connect(host:String, port:int):void {
			_host = host;
			_port = port;

			try {
				log("Connect to " + _host + ":" + _port);
				_socket.connect(_host, _port);
			} catch (error:SecurityError) {
				log("Security error: " + error);
				_dispatcher.dispatchEvent(new JSSEvent(JSSEvent.SECURITY_ERROR, error.toString()));
			} catch (error:Error) {
				log("Connection error: " + error);
				throw error;
			}
		}

		private function handleSocketConnect(event:Event):void {
			log("Connected: " + event);
			_isConnected = true;
			_dispatcher.dispatchEvent(new JSSEvent(JSSEvent.CONNECT_TO_SERVER_SOCKET))
		}

		public function disconnect(reason:String):void {
			try {
				if (_socket != null) {
					_socket.close();
				}
			} catch(error:Error) {
				log("Socket not connected:" + error.message);
			}
			dispatchConnectionLost(reason);
		}

		private function handleSocketClose(event:Event):void {
			dispatchConnectionLost(JSSClientDisconnectionReason.SOCKET_CLOSE);
		}

		private function dispatchConnectionLost(reason:String):void {
			log("Connection lost: " + reason);
			_isConnected = false;
			_dispatcher.dispatchEvent(new JSSEvent(JSSEvent.CONNECTION_LOST, reason));
		}

		private function log(message:String):void {
			if (_debug) {
				var str:String = getCurrentUTCTime() + " " + message;
				trace(str);
			}
		}

		public static function getCurrentUTCTime():String {
			var date:Date = new Date();

			var textMilliseconds:String = String(date.millisecondsUTC);
			while (textMilliseconds.length < 3) {
				textMilliseconds = "0" + textMilliseconds;
			}

			var textSeconds:String = String(date.secondsUTC);
			if (textSeconds.length == 1) {
				textSeconds = "0" + textSeconds;
			}

			var textMinutes:String = String(date.minutesUTC);
			if (textMinutes.length == 1) {
				textMinutes = "0" + textMinutes;
			}

			var textHours:String = String(date.hoursUTC);
			if (textHours.length == 1) {
				textHours = "0" + textHours;
			}

			return textHours + ":" + textMinutes + ":" + textSeconds + "." + textMilliseconds;
		}


		private function handleSocketData(event:ProgressEvent):void {
			receiveData(_socket.readUTFBytes(_socket.bytesAvailable));
		}

		private function handleSocketError(event:IOErrorEvent):void {
			log("Socket error: " + event);
			_dispatcher.dispatchEvent(new JSSEvent(JSSEvent.SOCKET_ERROR));
		}

		private function handleSecurityError(event:SecurityErrorEvent):void {
			log("Security error: " + event);
			_dispatcher.dispatchEvent(new JSSEvent(JSSEvent.SECURITY_ERROR, event.toString()));
		}

		public function sendRequest(request:String):void {
			if (_socket != null && _socket.connected) {
				request += "\n";

				try {
					_socket.writeUTFBytes(request);
					_socket.flush();
					log("Message sent: " + request.toString());
				} catch(error:Error) {
					log("Error sending data: " + error);
				}

			} else {
				if (_isConnected) {
					dispatchConnectionLost(JSSClientDisconnectionReason.SOCKED_CONNECTED_FAIL);
				} else {
					throw new Error("Sending request without connection");
				}
			}
		}

		private function receiveData(msg:String):void {
			log("Message received: " + msg);
			_dispatcher.dispatchEvent(new JSSEvent(JSSEvent.RECEIVE_DATA, msg));
		}

		//noinspection JSUnusedGlobalSymbols
		public function get host():String {
			return _host;
		}

		//noinspection JSUnusedGlobalSymbols
		public function get port():int {
			return _port;
		}

		//noinspection JSUnusedGlobalSymbols
		public function isConnect():Boolean {
			return _socket != null && _socket.connected;
		}

	}
}