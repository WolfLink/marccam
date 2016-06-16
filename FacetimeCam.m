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
           if obj.vidin.FramesAvailable > 0
              obj.lastimg = getdata(obj.vidin, 1); %get the most recent frame
              obj.lastimg = ycbcr2rgb(obj.lastimg);
           else
               try
                   obj.lastimg = obj.takePicture(); %if there are no currently available frames then take a picture now
               catch e
                   disp('unable to get an image')
                   %if we are unable to take a new picture, use the previous picture
               end
           end
           picture = obj.lastimg;
        end
        function arm(obj)
            arm@Cam(obj);
            src = getselectedsource(obj.vidin);
        end
    end
    
end

