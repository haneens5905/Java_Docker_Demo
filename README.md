# Java Docker Demo

##  Description

This project demonstrates how to containerize a simple Java application
using **multi-stage Docker builds** and then explore concepts like
extracting and decompiling the built JAR. It is primarily for learning
purposes --- to understand how Docker works with Java, how to keep
images lightweight, and how reverse-engineering JARs can be performed.

------------------------------------------------------------------------

##  Learning Outcomes

-   How to use **multi-stage Docker builds** to separate build and
    runtime environments.\
-   How to extract artifacts (e.g., JAR files) from Docker containers.\
-   How to decompile Java bytecode back into human-readable source.\
-   Understand the difference between running an app inside Docker
    vs. on the host.\
-   Practice best practices in Docker image building.

------------------------------------------------------------------------

##  Prerequisites

Before running the project, ensure you have the following installed:

-   **Java 17** (JDK)\
-   **Docker** (20.x or newer recommended)\
-   **Maven** (3.6+ recommended)\
-   **jd-cli** (Java decompiler) --- included in this repo for
    convenience, but you can also [download it
    here](https://github.com/kwart/jd-cli).\
-   A Unix-like environment (Linux/macOS). Windows should work too but
    commands may differ slightly.

------------------------------------------------------------------------

##  Project Structure

    Java_Docker_Demo/
    │── Dockerfile
    │── pom.xml
    │── src/main/java/com/example/App.java
    │── jd-cli-1.2.0-dist.tar.gz   # Decompiler (bundled)
    │── LICENSE
    │── recovered-app.jar          # Extracted jar (artifact)
    │── app.jar                    # Build artifact (should be ignored in production)

------------------------------------------------------------------------

##  Setup Instructions

### 1. Clone the repository

``` bash
git clone https://github.com/haneens5905/Java_Docker_Demo.git
cd Java_Docker_Demo
```

### 2. Build and Run Locally (without Docker)

If you want to compile and run the app directly:

``` bash
mvn clean package
java -jar target/app.jar
```

Expected output:

    Running inside: host JVM

------------------------------------------------------------------------

##  Building and Running with Docker

### 1. Build the Docker Image

``` bash
docker build -t java-docker-demo .
```

### 2. Run the Container

``` bash
docker run --rm java-docker-demo
```

Expected output:
```
Hello, World
Time now: 2025-08-19T16:05:54.323079391
Java version: 17.0.16
Running inside: Docker container
```

------------------------------------------------------------------------

##  Extracting the Built JAR from Docker

1.  Run the container in the background:

    ``` bash
    docker run --name java-demo -d java-docker-demo
    ```

2.  Copy the JAR from the container:

    ``` bash
    docker cp java-demo:/app/app.jar ./recovered-app.jar
    ```

3.  Stop and remove the container:

    ``` bash
    docker rm -f java-demo
    ```

4.  Run the recovered JAR on the host:

    ``` bash
    java -jar recovered-app.jar
    ```

    Expected output:

        Running inside: host JVM (recovered JAR)

------------------------------------------------------------------------

##  Decompiling the JAR

1.  Extract jd-cli (already bundled or download from official repo).\

2.  Run:

    ``` bash
    java -jar jd-cli-1.2.0-dist/jd-cli.jar recovered-app.jar -od decompiled
    ```

3.  View the decompiled source under the `decompiled/` folder.

Example recovered code:

``` java
package com.haneen;

import java.time.LocalDateTime;

public class App {
  public static void main(String[] args) {
    String name = System.getenv().getOrDefault("NAME", "World");
    System.out.println("Hello, " + name);
    System.out.println("Time now: " + LocalDateTime.now());
    System.out.println("Java version: " + System.getProperty("java.version"));
    String insideDocker = System.getenv("RUNNING_IN_CONTAINER");
    if ("true".equalsIgnoreCase(insideDocker)) {
      System.out.println("Running inside: Docker container");
    } else {
      System.out.println("Running inside: Host JVM");
    } 
  }
}

```

------------------------------------------------------------------------

##  Cleaning Up

Remove unused containers/images to free space:

``` bash
docker rm -f $(docker ps -aq)
docker rmi -f java-docker-demo
```

------------------------------------------------------------------------

##  Troubleshooting / Common Issues

-   **Docker not found** → Ensure Docker is installed and running
    (`docker ps` works).\
-   **Permission denied** → Run Docker with `sudo` or add your user to
    the `docker` group.\
-   **Maven not found** → Install Maven if building locally.\
-   **Empty decompiled output** → Ensure you used the correct jar
    (recovered-app.jar).

------------------------------------------------------------------------


##  License

This project is licensed under the **MIT License**:

```
MIT License

Copyright (c) 2025 Haneen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

------------------------------------------------------------------------

##  Credits / References

-   [Docker Docs](https://docs.docker.com/)\
-   [jd-cli Decompiler](https://github.com/kwart/jd-cli)\
-   [Maven Docs](https://maven.apache.org/)
