classdef GuppyProF046B < GentlCam
    %GUPPYPROF046B A customized class for Guppy Pro F046B in E5.
    %It inherits from GentlCam since the Guppy Pro F046B uses the gentl adaptor
    %to communicate with matlab.
    
    properties
    end
    
    methods
        function obj = GuppyProF046B(adaptor, id)
           obj@GentlCam(adaptor, id);
        end
        function initCam(obj)
            initCam@GentlCam(obj); 
            v = obj.vidin;
            s = getselectedsource(v);
            s.ExposureTime = 100;
            %s.Gain = 0;
            %s.IIDCMode = 'Mode2';
        end
    end
    
end

