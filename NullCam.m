classdef NullCam < Cam
    %NULLCAM A class that represents the lack of a camera.
    %   When no camera is selected, this class gets used.
    
    properties
    end
    
    methods
        function arm(~)
        end
        function startRecording(~)
        end
        function stopRecording(~)
        end
        function picture = getCurrentImage(obj)
           picture = obj.takePicture(); 
        end
        function picture = takePicture(~)
           picture = 0;
        end
        function obj = NullCam()
            obj@Cam('none',0);
            obj.DeviceName = 'none';
        end
        function images = getFrames(~, ~)
            images = 0;
        end
    end
    
end

