# Java Docker Demo

This project demonstrates how to containerize, run, and reverse-engineer a simple Java application using Docker.  
It covers building images, running containers, extracting artifacts, and decompiling JAR files.

---

##  Project Overview

The project includes:

- A simple **Java application** (`App.java`) that prints:
  - "Hello, World"
  - Current timestamp
  - Java version
  - Execution environment (Host JVM or Docker container)
- A **multi-stage Dockerfile** that:
  1. Compiles the Java code into a JAR file.
  2. Copies only the JAR into a lightweight image for execution.
- Steps to:
  - Run the container.
  - Recover the JAR file from the container.
  - Decompile the JAR to retrieve readable Java source code.

This exercise demonstrates concepts of **Docker image layering, multi-stage builds, and reverse engineering.**

---

##  Project Structure

```bash
java-docker-demo/
├── Dockerfile
├── App.java              # Original Java source
├── app.jar               # Packaged Java application (output)
├── recovered-app.jar     # Extracted JAR from Docker container
├── decompiled-src/       # Decompiled Java source files
│   ├── com/haneen/App.java
│   └── META-INF/...
└── README.md
```

---

##  Commands & Steps

### 1. Compile and Package the Application
If not already built, package the app into a `.jar` (done automatically in Dockerfile build stage).

### 2. Build the Docker Image
```bash
docker build -t hello-docker:1.0 .
```

### 3. Run the Container
```bash
docker run --rm hello-docker:1.0
```

Expected output:
```
Hello, World
Time now: 2025-08-19T16:05:54.323079391
Java version: 17.0.16
Running inside: Docker container
```

### 4. List Images
```bash
docker images
```

### 5. Extract the JAR from Container
```bash
cid=$(docker create hello-docker:1.0)
docker cp "$cid":/app/app.jar ./recovered-app.jar
docker rm "$cid"
```

### 6. Run the Recovered JAR on Host
```bash
java -jar recovered-app.jar
```

Output shows execution on **host JVM** instead of Docker.

### 7. Decompile the JAR
- Download [jd-cli](https://github.com/kwart/jd-cli/releases).  
- Extract it:
  ```bash
  tar -xvzf jd-cli-1.2.0-dist.tar.gz
  ```
- Run decompiler:
  ```bash
  mkdir decompiled-src
  java -jar jd-cli.jar recovered-app.jar -od decompiled-src
  ```

Decompiled files will be saved under `decompiled-src/`.

---

##  Tools Used

- **Java 17** – Programming language
- **Docker** – Containerization
- **jd-cli** – Java bytecode decompiler

---

##  Learning Outcomes

Through this project, we learned:

- How to use **multi-stage Docker builds** to keep images lightweight.
- How to run Java applications inside Docker containers.
- How to **extract and decompile JARs** to recover source code.
- How Docker isolates environments but allows recovery of built artifacts.

---

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
```

---
