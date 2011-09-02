package com.xenao.demo.server;

import com.xenao.demo.server.core.JavaServerProperties;
import com.xenao.demo.server.core.BaseJavaServerLoggedClass;

public class JavaServer extends BaseJavaServerLoggedClass {

	public static JavaServerProperties properties;

	public static void main(String[] args) {
		prepare();
		info("String server...");
		
	}

	private static void prepare() {
		try {
			loadProperties();
			initLogger();
		} catch (Exception e) {
			System.out.println(e.getMessage());
			System.exit(-1);
		}
	}

	private static void loadProperties() throws Exception {
		properties = new JavaServerProperties();
		properties.loadProperties();
	}

	private static void initLogger() {
		org.apache.log4j.PropertyConfigurator.configure(properties.getProperty("log4j.propertyFileName"));
	}

}
