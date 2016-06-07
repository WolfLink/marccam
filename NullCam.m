classdef NullCam < Cam
    %NULLCAM A class that represents a null camera.
    %   When no camera is selected, this class gets used.
    
    properties
    end
    
    methods
        function obj = NullCam()
            obj@Cam('none',0);
            obj.DeviceName = 'none';
        end
    end
    
end

