classdef Cam < handle
    %CAM A class to represent a connected camera.
    %   The Cam class represents a camera given by its AdaptorName and
    %   DeviceID.  These two pieces of information are what determine a
    %   specific camera according to the imaq library.  The class stores
    %   these pieces of information and manages interaction with the camera
    %   it represents, including starting and stopping the camera and
    %   getting data from the camera.
    
    properties
        AdaptorName
        DeviceID
        DeviceName
        vidin
    end
    
    methods
        % camera management functions
        function arm(obj)
           obj.vidin =  videoinput(obj.AdaptorName, obj.DeviceID); %This should work most of the time but if your camera needs specific settings, write a subclass.
        end
        function images = getFrames(obj, numFrames)
            obj.vidin.TriggerRepeat = numFrames - 1;
            start(obj.vidin);
            wait(obj.vidin, 100);
            images = zeros(720, 1280, numFrames);
            %if obj.vidin.FramesAvailable == numFrames
                for i = 1 : numFrames
                    images(:,:,i) = getdata(obj.vidin);
                    % note: this line was based off of edcam but could be a
                    % source of lag and inefficient memory usage.  This
                    % could be optimized.
                end
            %else
            %    images = 0;
            %end
        end
            
        % constructors and constructor-like functions
        function obj = Cam(adaptor, id)
            obj.AdaptorName = adaptor;
            obj.DeviceID = id;
        end
        function initCam(obj)
            c = imaqhwinfo(obj.AdaptorName, obj.DeviceID);
            obj.DeviceName = c.DeviceName;
        end 
        function b = isnull(obj)
            b = eq(obj, Cam.nullCam());
        end
    end
    
    methods(Static)
        function obj = nullCam()
            persistent nullc;
            if isempty(nullc)
                nullc = NullCam();
            end
            obj = nullc;
        end
        
        function cameras = listCameras()
            cameras = {};
            dict = imaqhwinfo;
            for a = dict.InstalledAdaptors
                bs = imaqhwinfo(char(a));
                for b = bs.DeviceIDs
                    newcam = Cam(char(a),b{1});
                    newcam.initCam;
                    cameras = [cameras, newcam]; %#ok<AGROW> %suppressed array growth warning here
                end
            end
                    
        end
        
        function findCameras()
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
        
        function previewAllCameras()
            cams = Cam.listCameras;
            for cam = cams
                vid = videoinput(cam.AdaptorName, cam.DeviceID); %#ok<TNMLP> %supressed video api usage warning here
                preview(vid)
            end
        end
        
    end
end

