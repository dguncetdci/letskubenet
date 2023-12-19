
# Build and Run a Container Image for the .Net App in Visual Code Studio

## Overview
This guide will walk you through building and running a container image for the .net app.

## Steps

### 1. Build a Container Image
Ensure Docker is configured for Linux containers. Use the following command to build the image:
```bash
docker build -t mynetapp .
```

You will see a series of outputs indicating the progress of the build process.

### 2. Run a Container Image
Now that the container image is built, you can run it using the following command:
```bash
docker run -p 8080:8080 mynetapp
```

This will start the container and expose it on port 8080.

### 3. Verify the Running Container
After running the container, open a browser and visit `http://localhost:8080` to view the running application.

You should see the mynetapp landing page. 

### 4. Stop the Container
To stop the container, press `CTRL + C` inside the CLI.

---

By completing these steps, you have successfully built and run a container image for the .Net application.
