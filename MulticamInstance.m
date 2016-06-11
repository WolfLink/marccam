classdef MulticamInstance < handle
    %MULTICAMINSTANCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figure
        numID
        currentCamera
        cameras
        mainDisplayAxes
        fitXAxes
        fitYAxes
        fitType
        img
        statusText
    end
    
    methods
        function obj = MulticamInstance(f)
            obj.figure = f;
            obj.numID = f.Number;
            obj.cameras = Cam.listCameras;
            obj.currentCamera = Cam.nullCam;
            obj.mainDisplayAxes = [];
            obj.fitType = 'gauss1';
            obj.img = 0;
        end
        function switchCamera(obj, cam)
            %make a function in the camera class that stops and shuts down
            %the current camera
            obj.currentCamera.startRecording();
            obj.currentCamera = cam;
            cam.minstance = obj;
            obj.statusText.String = 'Waiting for Start';
            cam.status = obj.statusText;
        end
        function updateImageOutput(obj)
            obj.img = obj.currentCamera.getCurrentImage();
            if ~isempty(obj.mainDisplayAxes)
                axes(obj.mainDisplayAxes)
                image(obj.img);
                obj.redrawPlots();
                obj.currentCamera.triggerCount = obj.currentCamera.triggerCount + 1;
                obj.statusText.String = sprintf('Frames: %d', obj.currentCamera.triggerCount);
            end
        end
        function redrawPlots(obj)
            xdata = ImageProcessing.sumX(obj.img);
            [x, y] = prepareCurveData([], xdata);
            f = fit(x, y, obj.fitType);
            axes(obj.fitXAxes);
            plot(xdata);
            hold on
            plot(f);
            hold off
            ydata = ImageProcessing.sumY(obj.img);
            [x, y] = prepareCurveData([], ydata);
            f = fit(x, y, obj.fitType);
            axes(obj.fitYAxes);
            plot(ydata);
            hold on
            plot(f);
            hold off
            view(-90, 90);
            set(gca, 'xdir', 'reverse');
        end
        
        
    end
    
    methods(Static)
        function hmap = manageHMap(fig)
           persistent m;
           if isempty(m) && ~isempty(fig)
               i = MulticamInstance(fig);
               m = containers.Map(fig.Number, i);
           end
           hmap = m;
        end
        function i = instanceForFigure(fig)
            num = fig.Number;
            hmap = MulticamInstance.manageHMap(fig);
            if hmap.isKey(num)
                i = hmap(num);
            else
                i = MulticamInstance(fig);
                hmap(num) = i;
            end
        end
        function b = removeInstance(fig)
            hmap = MulticamInstance.manageHMap(fig);
            minstance = hmap(fig.Number);
            for cam = minstance.cameras
               c = cam{1};
               stop(c.vidin);
               delete(c.vidin);
               delete(c);
            end
            delete(minstance);
            hmap.remove(fig.Number);
        end
 
    end
    
end