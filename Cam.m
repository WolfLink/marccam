classdef Cam
    %CAM A 
    %   Detailed explanation goes here
    
    properties
        AdaptorName
        DeviceID
        DeviceName
    end
    
    methods
        function obj = Cam(adaptor, id)
            obj.AdaptorName = adaptor;
            obj.DeviceID = id;
            c = imaqhwinfo(adaptor, id);
            obj.DeviceName = c.DeviceName;
        end
    end
    
    methods(Static)
        
        function cameras = listCameras()
            cameras = {};
            dict = imaqhwinfo;
            for a = dict.InstalledAdaptors
                bs = imaqhwinfo(char(a));
                for b = bs.DeviceIDs
                    newcam = Cam(char(a),b{1});
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
                 fprintf('\tDefaultFormat: %s', c.DefaultFormat)
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

