classdef GentlCam < Cam
    %GENTLCAM A subclass of Cam designed to accomadate the best settings
    %for most cases with a camera that uses gentl.
    %   The GentlCam automatically sets up the attached camera for hardware
    %   triggering and default settings.
    
    %   Rather than modifying this class, if you need to customize your own
    %   gentl camera, create a subclass like GuppyF038B.m.
    
    properties
    end
    
    methods
        function obj = GentlCam(adaptor, id)
           obj@Cam(adaptor, id); 
        end
        function switchVidMode(obj, vm)
            switchVidMode@Cam(obj, vm);
           v = obj.vidin;
           switch vm
               case 'Hardware Trigger' 
                   %set gentl camera to automcatically record based on the
                   %hardware trigger
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
               case 'Manual Trigger'
                   triggerconfig(v,'immediate');
                   s = getselectedsource(v);
                   if isprop(s, 'TriggerMode')
                       s.TriggerMode = 'Off';
                   elseif isprop(s, 'ExposureStartTriggerMode')
                       s.ExposureStartTriggerMode = 'Off';
                   else
                       disp('unable to find proper trigger mode')
                   end
               case 'Live Video'
                   triggerconfig(v,'immediate');
                   s = getselectedsource(v);
                   if isprop(s, 'TriggerMode')
                       s.TriggerMode = 'Off';
                   elseif isprop(s, 'ExposureStartTriggerMode')
                       s.ExposureStartTriggerMode = 'Off';
                   else
                       disp('unable to find proper trigger mode')
                   end
                   set(v, 'TriggerFcn', {@Cam.hardwaretrigger, obj.minstance});
               otherwise
                   disp('Error: unsupported video mode')
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

