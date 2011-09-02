package com.xenao.demo.server.core;

import com.xenao.demo.server.JavaServer;
import org.apache.log4j.Logger;

public class BaseJavaServerLoggedClass {

	protected static final Logger logger = Logger.getLogger(JavaServer.class);

	protected static void info(String msg) {
		if (logger != null) {
			logger.info(msg);
		}
	}

	protected static void exception(String msg, Throwable t) {
		if (logger != null) {
			String message = "\n:::::::::::::::::::::::::::::::::::::::::::::::::::\n" + msg;
			logger.error(message, t);
		}
	}
}
