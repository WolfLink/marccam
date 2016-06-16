classdef GuppyF038B < GentlCam
    %GUPPYF038B A customized class for GuppyF038B (AKA Guppy 530) in E5.
    %It inherits from GentlCam since the GuppyF038B uses the gentl adaptor
    %to communicate with matlab.
    
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

