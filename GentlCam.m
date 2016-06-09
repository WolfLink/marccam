classdef GentlCam < Cam
    %GENTLCAM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = GentlCam(adaptor, id)
           obj@Cam(adaptor, id); 
        end
        function initCam(obj)
            initCam@Cam(obj);
            obj.vidin.returnedColorspace = 'rgb';
        end
    end
    
end

