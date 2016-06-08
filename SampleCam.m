classdef SampleCam < Cam
    %SAMPLECAM This is a sample class to serve as a template to base
    %custom camera subclasses off of
    %   A subclass of Cam should use this as a guide.  It is not required
    %   to override aall of the functions; just the ones where
    %   customization is needed based on the requirements of the specific
    %   camera type.
    
    properties
    end
    
    methods
        function arm(obj)
            videoformat = 'insert video format here';
            obj.vidin = videoinput(obj.AdaptorName, obj.DeviceID, videoformat); %do not edit this line 
        end
    end
    
end

