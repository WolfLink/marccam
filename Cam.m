classdef Cam
    %CAM Summary of this class goes here
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
        end
    end
    
    methods(Static)
        
        function cameras = listCameras()
            cameras = {};
            dict = imaqhwinfo;
            for a = dict.InstalledAdaptors
                bs = imaqhwinfo(char(a));
                for b = bs.DeviceIDs
                    newcam = Cam(a{1},b{1});
                    c = imaqhwinfo(char(a), b{1});
                    newcam.DeviceName = c.DeviceName;
                    cameras = [cameras, newcam]; %#ok<*AGROW> %suppressed array growth warning here %#ok<AGROW>
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
    end
    
end

