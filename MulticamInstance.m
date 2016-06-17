classdef MulticamInstance < handle
    % MULTICAMINSTANCE A class that is used to keep track of instances of
    % MULTICAM.
    %   Each instance of MULTICAMINSTANCE holds all of the properties needed 
    %   by a specific instance and handles to gui objects needed for output.
    
    properties
        figure %the handle to the corresponding figure instance
        numID %the number used by matlab to identify the figure instance
        currentCamera %the CAM object representing the currently selected camera
        cameras %an array of CAM objects that can be selected
        mainDisplayAxes %the axes that the image is displayed on
        fitXAxes %the axes that show the graph of data along the x axis
        fitYAxes %the axes that show the graph of data along the y axis
        img %the currently viewed image
        statusText %a text label that give the current status of the camera
        numouts %a listbox that gives data from the analysis of the x and y graphs
        detailouts %a listbox that gives more detailed data on a selected item from numouts
        selectedNumout %the currently selected item from numouts that detailouts give info on
        fitTrack
    end
    
    methods
        function obj = MulticamInstance(f)
            obj.figure = f;
            obj.numID = f.Number;
            obj.cameras = Cam.listCameras;
            obj.currentCamera = Cam.nullCam;
            obj.mainDisplayAxes = [];
            obj.fitTrack = FitTracker('gauss1+');
            obj.img = 0;
            obj.selectedNumout = 2;
        end
        function switchCamera(obj, cam)
            %stop the current camera and switch to the new camera
            obj.currentCamera.stopRecording();
            obj.currentCamera = cam;
            cam.minstance = obj;
            obj.statusText.String = 'Waiting for Start';
            cam.status = obj.statusText;
        end
        function updateImageOutput(obj)
            %get the current image from the camera and display it
            obj.img = obj.currentCamera.getCurrentImage();
            if size(obj.img,3) == 1
               %obj.img = ind2rgb(obj.img, jet(256)); the default colormap
               %seems to work better (?)
            end
            if ~isempty(obj.mainDisplayAxes)
                axes(obj.mainDisplayAxes)
                image(obj.img);
                if ImageProcessing.detectBlank(obj.img)
                    obj.statusText.String = 'Blank Image Detected';
                else
                    obj.redrawPlots();
                    obj.currentCamera.triggerCount = obj.currentCamera.triggerCount + 1;
                    obj.statusText.String = sprintf('Frames: %d', obj.currentCamera.triggerCount);
                end
            end
        end
        function redrawPlots(obj)
            % update the graphs that accompany the image and update the
            % numerical outputs
            obj.fitTrack.numouts = obj.numouts;
            obj.fitTrack.detailouts = obj.detailouts;
            ImageProcessing.fillPlots(obj.img, obj.fitXAxes, obj.fitYAxes, obj.fitTrack);
            obj.fitTrack.displayDetails(obj.selectedNumout);
        end
        function changeSelectedData(obj, dat)
            %switch which item from numouts is selected and display its
            %data
            obj.selectedNumout = dat;
            obj.fitTrack.displayDetails(dat);
        end
        function changeFitType(obj, fitType)
           %change the currently selected fit type for the analysis used in
           %fitXAxes and fitYAxes
           delete(obj.fitTrack);
           obj.fitTrack = FitTracker(fitType);
           set(obj.numouts, 'Value', 2);
           set(obj.detailouts, 'Value', 1);
           obj.selectedNumout = 2;
        end
 
    end
    
    methods(Static)
        %These functions are used to keep a multicaminstance connected with
        %the corresponding gui instances.  Do not edit these.
        function hmap = manageHMap(fig)
           %returns the handle to the hashmap that is used to keep track of
           %multicaminstances
           persistent m;
           if isempty(m) && ~isempty(fig)
               i = MulticamInstance(fig);
               m = containers.Map(fig.Number, i);
           end
           hmap = m;
        end
        function i = instanceForFigure(fig)
            %returns the multicaminstance that corresponds to the given
            %figure handle
            num = fig.Number;
            hmap = MulticamInstance.manageHMap(fig);
            if hmap.isKey(num)
                i = hmap(num);
            else
                i = MulticamInstance(fig);
                hmap(num) = i;
            end
        end
        function removeInstance(fig)
            %removes the multicaminstance for the given figure handle from
            %the list of instance.  This is called from the deleteFcn in
            %multicam.
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