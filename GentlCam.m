classdef GentlCam < Cam
    %GENTLCAM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = GentlCam(adaptor, id)
           obj@Cam(adaptor, id); 
        end
        function startRecording(obj)
            %set gentl camera to automcatically record based on the
            %hardware trigger
            v = obj.vidin;
            stop(v);
            triggerconfig(v, 'hardware');
            v.FramesPerTrigger = 1;
            v.TriggerRepeat = inf;
            s = getselectedsource(v);
            if isprop(s, 'TriggerMode')
                s.TriggerMode = 'On';
                s.TriggerActivation = 'RisingEdge';
            elseif isprop(s, 'ExposureStartTriggerMode')
                s.ExposureStartTriggerMode = 'On';
                s.ExposureStartTriggerActivation = 'RisingEdge';
            else
                disp('unable to find proper trigger mode')
                triggerconfig(v, 'immediate');
            end
            set(v, 'TriggerFcn', {@Cam.hardwaretrigger, obj.minstance});
            startRecording@Cam(obj);
        end
        function stopRecording(obj)
            v = obj.vidin;
            stopRecording@Cam(obj);
            triggerconfig(v,'immediate');
            s = getselectedsource(v);
            if isprop(s, 'TriggerMode')
                s.TriggerMode = 'Off';
                s.TriggerActivation = 'FallingEdge';
            elseif isprop(s, 'ExposureStartTriggerMode')
                s.ExposureStartTriggerMode = 'Off';
            else
                disp('unable to find proper trigger mode')
                triggerconfig(v, 'immediate');
            end
        end
        function initCam(obj)
            initCam@Cam(obj);
            v = obj.vidin;
            v.ReturnedColorSpace = 'grayscale';
            triggerconfig(v, 'immediate');
            s = getselectedsource(v);
            if isprop(s, 'TriggerMode')
                s.TriggerMode = 'Off';
                s.TriggerActivation = 'FallingEdge';
            elseif isprop(s, 'ExposureStartTriggerMode')
                s.ExposureStartTriggerMode = 'Off';
            else
                disp('unable to find proper trigger mode')
                triggerconfig(v, 'immediate');
            end
        end
        
    end
    
end

