classdef GuppyF038B < GentlCam
    %GUPPYF038B A customized class for GuppyF038B (AKA Guppy 530) in E5
    
    properties
    end
    
    methods
        function initCam(obj)
            initCam@GentlCam(obj);
            v = obj.vidin;
            s = getselectedsource(v);
            s.ExposureTime = 1;
            s.GainRaw = 0;
        end
    end
    
end

