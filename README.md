# marccam
A reworking of Edcam to support multiple instances and be more stable.

Usage: 

Type marccam to start a new instance.  The GUI will pop up, and will allow you to select a camera from the list of detected cameras.  You will need to ensure that the necessary drivers for your specific camera are properly installed.  Also, you may need to program custom support for your specific camera.  Currently the project mainly support AVT Guppy cameras

To support a camera, write a subclass of Cam.m.  There are several subclasses of Cam already provided that may prove useful.  GentlCam.m supports cameras that communicate with the Gentl driver.  Subclass GentlCam instead of Cam if your camera also uses the Gentl driver.  Use GuppyProF046B.m and GuppyF038B.m as examples of how to write a Cam subclass.  These two classes are subclasses specifically tailored to the lab I work in.

Once you have written a custom subclass for your camera, implement it in the camWithProperties and camWithAdaptorAndID functions of Cam.m.  It is recommended that you put your custom subclass in camWithAdaptorAndID if your class represents a specific adaptor and camWithProperties if your class represents a specific camera or model of camera.  Use the provided name and adaptor identifiers to identify your target camera.

The app supports hardware triggering, but you may need to configure it for your specific camera with a custom Cam class.  The app also supports a constant video mode and a still frame image mode.

It supports fits along the x and y axis and  will log data from these fits to a file.  You may need to modify the fit features to your needs as the current features are based on the needs in my lab.  Data fitting and logging is managed in ImageProcessing.m, DataLogger.m, FitTracker.m, and if you want to implement a new fit you will need to add its name to the list in marccam.fig.

The app supports blank image detection.  It will display but otherwise ignore images it detects as empty.  The blank image detection is managed in ImageProcessing.m.  There are several alternate but currently unused blank image detection algorithms located in that file.
