classdef MulticamInstance
    %MULTICAMINSTANCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figure
        numID
        camera
        cameraDatas
    end
    
    methods
        function obj = MulticamInstance(f)
            obj.figure = f;
            obj.numID = f.Number;
        end
        function switchCamera(cam)
            if isempty(camera)
                camera = cam;
            else
            end
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