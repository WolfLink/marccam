classdef Cam < handle
    %CAM A class to represent a connected camera.
    %   The Cam class represents a camera given by its AdaptorName and
    %   DeviceID.  These two pieces of information are what determine a
    %   specific camera according to the imaq library.  The class stores
    %   these pieces of information and manages interaction with the camera
    %   it represents, including starting and stopping the camera and
    %   getting data from the camera.
    
    properties
        AdaptorName %The name of the Adaptor matlab uses to communicate with the camera
        DeviceID %The number used by matlab to identify the camera.
        DeviceName %The name of the device as reported by imaqhwinfo
        vidin %The handle to the videoinput object that corresponds to the represented camera
        serialNumber %The serial number of the represented camera or the DeviceID if the camera does not report a serial number (such as with FaceTime cameras)
        minstance %the handle to the multicaminstance that this instance of Cam belongs to
        lastimg %The last recorded image.  It is used when an error prevents the class from getting a new image.
        status %A handle to the statusText object of the corresponding multicaminstance
        triggerCount %the number of triggers recieved since the last time triggering was started
    end
    
    methods
        % camera management functions
        function arm(obj)
           obj.vidin =  videoinput(obj.AdaptorName, obj.DeviceID);
           %This should work most of the time but if your camera needs 
           %specific settings, write a subclass.
           %    Override this function to prepare for hardware triggering.
           %    See GentlCam for an example.
        end
        function startRecording(obj)
            %Starts the videoinput object, updates the status, and sets
            %triggerCount to 0.  You may want to ovverride this function in
            %a subclass for certain situations such as hardware triggering.
            start(obj.vidin);
            obj.status.String = 'Waiting for Trigger';
            obj.triggerCount = 0;
        end
        function stopRecording(obj)
            %Stops the videoinput object and updates the status.  You may
            %want to override this function in a subclass for certain
            %situations such as hardware triggering.
            stop(obj.vidin);
            obj.status.String = 'Waiting for Start';
        end
        
        function picture = takePicture(obj)
           %Takes a quick picture.  This function may not work when the
           %camera is configured in certain ways such as for hardware
           %triggering.  You may want to override this function in those
           %situations.
           picture = getsnapshot(obj.vidin);
        end
        
        function picture = getCurrentImage(obj)
           %Returns the last picture taken or takes a new one.
           if obj.vidin.FramesAvailable > 0
              obj.lastimg = getdata(obj.vidin, 1); %get the most recent frame
           else
               try
                   obj.lastimg = obj.takePicture(); %if there are no currently available frames then take a picture now
               catch e
                   disp('unable to get an image')
                   %if we are unable to take a new picture, use the previous picture
               end
           end
           picture = obj.lastimg;
        end
        
        function props = getCameraProperties(obj)
           %Use the output of this function for writing custom subclasses for cameras
           props = get(obj.vidin);
        end
            
        % Constructors and constructor-like functions
        function obj = Cam(adaptor, id)
            obj.AdaptorName = adaptor;
            obj.DeviceID = id;
            obj.triggerCount = 0;
        end
        function initCam(obj)
            c = imaqhwinfo(obj.AdaptorName, obj.DeviceID);
            obj.DeviceName = c.DeviceName;
            arm(obj);
            s = getselectedsource(obj.vidin);
            if isprop(s, 'DeviceID')
                obj.serialNumber = s.DeviceID;
            else
                obj.serialNumber = obj.DeviceID; 
            end
        end 
        function b = isnull(obj)
            b = eq(obj, Cam.nullCam());
        end
    end
    
    methods(Static)
        function obj = nullCam() %used to represent the lack of a camera when no camera is selected
            persistent nullc;
            if isempty(nullc)
                nullc = NullCam();
            end
            obj = nullc;
        end
        
        function cameras = listCameras() %Returns a list of camera objects for all detected cameras.  This is called when creating a new multicaminstance.
            cameras = {};
            dict = imaqhwinfo;
            for a = dict.InstalledAdaptors
                bs = imaqhwinfo(char(a));
                for b = bs.DeviceIDs
                    c = imaqhwinfo(char(a), b{1});
                    newcam = Cam.camWithProperties(char(a), c.DeviceName, b{1});
                    newcam.initCam;
                    cameras = [cameras, {newcam}]; %#ok<AGROW> %suppressed array growth warning here
                end
            end
                    
        end
        
        function findCameras() %Finds all cameras matlab can detect and prints information about them.
           dict = imaqhwinfo;
           for a = dict.InstalledAdaptors
               bs = imaqhwinfo(char(a));
              for b = bs.DeviceIDs
                 fprintf('\nFound Camera: \n\tAdaptorName: %s\n\tDevice ID: %d\n',a{1},b{1})
                 c = imaqhwinfo(char(a), b{1});
                 fprintf('\tDeviceName: %s', c.DeviceName)
                 fprintf('\tDefaultFormat: %s\n', c.DefaultFormat)
              end
           end
        end
        
        function previewAllCameras() %Opens preview windows for all cameras matlab can detect.  The preview windows may not work for certain cameras.
            cams = Cam.listCameras;
            for cam = cams
                vid = videoinput(cam.AdaptorName, cam.DeviceID); %#ok<TNMLP> %supressed video api usage warning here
                preview(vid)
            end
        end
        
        
        function c = camWithProperties(adaptor, name, id)
            % Use this swtich statement to identify specific cameras and
            % identify custom classes written for them.  This function gets
            % called by listCameras and is therefore used by multicam.
            switch name
                case 'FaceTime HD Camera'
                    c = FacetimeCam(adaptor, id);
                case 'AVT Guppy F038B NIR'
                    c = GuppyF038B(adaptor, id);
                case 'AVT Guppy PRO F046B'
                    c = GuppyProF046B(adaptor, id);
                otherwise
                    c = Cam.camWithAdaptorAndID(adaptor, id);
            end
        end
        function c = camWithAdaptorAndID(adaptor, id)
            % This function's purpose is similar to camWithProperties
            % except it is used to provide custom classes for adaptors
            % rather than specific cameras.
            switch adaptor
                case 'gentl'
                    c = GentlCam(adaptor, id);
                otherwise  
                    c = Cam(adaptor, id);
            end
        end
        
        function hardwaretrigger(v, e, obj)
           %Update the current image when the camera recieves a hardware
           %trigger.
           obj.updateImageOutput();
        end
        
    end
end

