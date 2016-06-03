classdef MulticamInstance < handle
    %MULTICAMINSTANCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figure
        numID
        currentCamera
        cameras
    end
    
    methods
        function obj = MulticamInstance(f)
            obj.figure = f;
            obj.numID = f.Number;
            obj.cameras = Cam.listCameras;
            obj.currentCamera = Cam.nullCam;
        end
        function switchCamera(obj, cam)
            %make a function in the camera class that stops and shuts down
            %the current camera
            obj.currentCamera = cam;
        end
    end
    
    methods(Static)
        function hmap = manageHMap(fig)
           persistent m;
           if isempty(m) && ~isempty(fig)
               i = MulticamInstance(fig);
               m = containers.Map(fig.Number, i);
           end
           hmap = m;
        end
        function i = instanceForFigure(fig)
            num = fig.Number;
            hmap = MulticamInstance.manageHMap(fig);
            if hmap.isKey(num)
                i = hmap(num);
            else
                i = MulticamInstance(fig);
                hmap(num) = i;
            end
        end
        function b = removeInstance(fig)
            hmap = MulticamInstance.manageHMap(fig);
            hmap.remove(fig.Number);
        end
            
    end
    
end