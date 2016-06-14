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
        numouts
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
            % update the graphs that accompany the image and update the
            % numerical outputs
            xdata = ImageProcessing.sumX(obj.img);
            [x, y] = prepareCurveData([], xdata);
            f = fit(x, y, obj.fitType);
            
            % the following code is used to display the b values from the
            % gaussian fit.  These values correspond to the center points
            % of the peaks that the gaussian fit finds.
            str = {'X Fit Analysis:'};
            names = coeffnames(f);
            vals = coeffvalues(f);
            s = size(names);
            for c = 1:s(1)
                v = vals(c);
                i = names(c);
                k = strfind(i, 'b');
                if ~isempty(k{1})
                   str{end+1} = char(strcat(i, sprintf(': %f', v)));
                end
            end
            s = size(xdata)
            axes(obj.fitXAxes);
            plot(xdata);
            axis manual
            axis([0,s(2), min(xdata), max(xdata)]);
            hold on
            plot(f);
            hold off
            ydata = ImageProcessing.sumY(obj.img);
            [x, y] = prepareCurveData([], ydata);
            f = fit(x, y, obj.fitType);
            % more code to output to numouts except this time we are using
            % the y values
            str{end+1} = 'Y Fit Analysis';
            names = coeffnames(f);
            vals = coeffvalues(f);
            s = size(names);
            for c = 1:s(1)
                v = vals(c);
                i = names(c);
                k = strfind(i, 'b');
                if ~isempty(k{1})
                   str{end+1} = char(strcat(i, sprintf(': %f', v)));
                end
            end
            s = size(ydata)
            axes(obj.fitYAxes);
            plot(ydata);
            axis manual
            axis([0,s(2),min(ydata),max(ydata)]);
            hold on
            plot(f);
            hold off
            view(-90, 90);
            set(gca, 'xdir', 'reverse');
            
            %set(obj.numouts,'String', sprintf('%s',f));
            %set(obj.numouts, 'String', {'Hello';'World'});
            %str = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f);
            
            
            set(obj.numouts, 'String', str);
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