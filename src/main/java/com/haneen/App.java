package com.haneen;

import java.time.LocalDateTime;

public class App {
    public static void main(String[] args) {
        String name = System.getenv().getOrDefault("NAME", "World");
        System.out.println("Hello, " + name);
        System.out.println("Time now: " + LocalDateTime.now());
        System.out.println("Java version: " + System.getProperty("java.version"));

        // Detect Docker vs Host using an env var we'll set in the runtime image
        String insideDocker = System.getenv("RUNNING_IN_CONTAINER");
        if ("true".equalsIgnoreCase(insideDocker)) {
            System.out.println("Running inside: Docker container");
        } else {
            System.out.println("Running inside: Host JVM");
        }
    }
}
