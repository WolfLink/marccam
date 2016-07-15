classdef FacetimeCam < Cam
    %FACETIMECAM Is designed for the interaction between multicam and the
    %built-in FaceTime cameras on macbooks.
    %   This class is just for testing purposes.  I developed multicam on a
    %   macbook so FaceTime camera support was necessary to aid
    %   development.
    
    properties
    end
    
    methods
        function obj = FacetimeCam(adaptor, id)
            obj@Cam(adaptor, id);
        end
        function picture = takePicture(obj)
           picture = takePicture@Cam(obj);
           picture = ycbcr2rgb(picture); %the FaceTime camera outputs to ycbcr by default so convert to rgb
        end
        function picture = getCurrentImage(obj)
           picture = ycbcr2rgb(getCurrentImage@Cam(obj));
        end
        function arm(obj)
            arm@Cam(obj);
            src = getselectedsource(obj.vidin);
        end
    end
    
end

