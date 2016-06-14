classdef GuppyF038B < GentlCam
    %GUPPYF038B A customized class for GuppyF038B (AKA Guppy 530) in E5
    
    properties
    end
    
    methods
        function obj = GuppyF038B(adaptor, id)
            obj@GentlCam(adaptor, id);
        end
        function initCam(obj)
            initCam@GentlCam(obj);
            v = obj.vidin;
            s = getselectedsource(v);
            s.ExposureTime = 100;
            s.Gain = 0;
            s.IIDCMode = 'Mode2';
        end
    end
    
end

