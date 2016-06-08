classdef FacetimeCam < Cam
    %FACETIMECAM Is designed for the interaction between multicam and the
    %built-in FaceTime cameras on macbooks.
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = FacetimeCam(adaptor, id)
            obj@Cam(adaptor, id);
        end
        function picture = takePicture(obj)
           picture = takePicture@Cam(obj);
           picture = ycbcr2rgb(picture); 
        end
        function arm(obj)
            arm@Cam(obj);
            src = getselectedsource(obj.vidin);
            %src.Exposure = 20;
        end
    end
    
end

