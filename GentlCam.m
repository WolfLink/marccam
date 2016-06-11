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
            v.ReturnedColorSpace = 'rgb';
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
        function notesForTriggering
            v.TriggerMode = 'hardware';
            v.FramesPerTrigger = 1;
            v.TriggerRepeat = inf;
            s = getselectedsource(v);
            s.TriggerMode = 1;
            s.TriggerActivation = 'FallingEdge';
            % after configuring the camera in this way, you can start the
            % camera and it will take frames whenever it receieves a
            % trigger.  Later you Stop the camera.  As far as I can tell,
            % there are no trigger callbacks so you will have to loop stuff
            % manually probably.
        end
    end
    
end

