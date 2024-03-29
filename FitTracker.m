classdef FitTracker < handle
    %FITTRACKER is a class designed to keep track of parameters from a
    %calculated fit as they change over time.
    %   Every time a new picture is taken, the results from the applied fit
    %   are added to a list of recorded data here.  This class managed the
    %   output for both numouts and detailouts and the relationship between
    %   the two.
    
    %   Currently, only the b values from gaussian fits are
    %   tracked.  That is because the b values can be used to approximate
    %   the location of a laser shined into the camera, which is the use of
    %   this feature in E5.  If you need to support other fit types or
    %   track other parameters, modify this class.
    
    properties
        fitType %The currently selected fit type
        xFit %the current fit results along the x axis
        yFit %the current fit results along the y axis
        numouts %the handle to the numouts that corresponds to this instance of multicaminstance
        detailouts %the handle to the detailouts that corresponds to this instance of multicaminstance
        callbacktrack %a list of data to be displayed when a certain item in numouts is selected
        logger %an instance of the DataLogger class to write tracked data to a file
        loggingEnabled %will log data if this is 1 and will not if this is 0
    end
    
    methods
        
        function obj = FitTracker(ft)
           obj.fitType = ft;
           obj.callbacktrack = {};
           obj.loggingEnabled = 0;
        end
        function displayDetails(obj, index)
           %update the current contents of detailouts
           set(obj.detailouts, 'String', obj.callbacktrack{index});
        end
        
        function updateNumouts(obj)
            % the following code is used to display the b values from the
            % gaussian fit.  These values correspond to the center points
            % of the peaks that the gaussian fit finds.
            
            f = obj.xFit;
            obj.logger.vals = [];
            obj.logger.names = {};
            
            % Set the matlab fit summary to be displayed when "X Fit
            % Analysis:" is selected from numouts
            obj.callbacktrack{1} = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f);
            cbtc = 2;
            str = {'X Fit Analysis:'};
            
            names = coeffnames(f);
            vals = coeffvalues(f);
            s = size(names);
            for c = 1:s(1)
                %go through the data in f and populate the string to put in
                %numouts
                v = vals(c);
                i = names(c);
                k = strfind(i, 'b');
                obj.logger.names{end+1} = strcat('X', i); %store values of properties for logging to file later
                obj.logger.vals(end+1) = v;
                if ~isempty(k{1}) %filter for only the b values
                   str{end + 1} = char(strcat(i, sprintf(': %f', v)));
                   
                   %Create a new list of data or add to the current list of
                   %data for the corresponding variable.  This data will be
                   %displayed in detailouts when the corresponding
                   %variables is selected from numouts
                   cbts = size(obj.callbacktrack);
                   if cbtc > cbts(2)
                       obj.callbacktrack{cbtc} = {v};
                   elseif obj.loggingEnabled == 1
                      cbtl = obj.callbacktrack{cbtc};
                      cbtl{end + 1} = v;
                      obj.callbacktrack{cbtc} = cbtl;
                   end
                   cbtc = cbtc + 1;
                end
            end
            
            
            % more code to output to numouts except this time we are using
            % the y values.
            f = obj.yFit;
            
            % Set the matlab fit summary to be displayed when "X Fit
            % Analysis:" is selected from numouts
            str{end+1} = 'Y Fit Analysis';
            obj.callbacktrack{cbtc} = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f);
            cbtc = cbtc + 1;
            
            
            names = coeffnames(f);
            vals = coeffvalues(f);
            s = size(names);
            for c = 1:s(1)
                 %go through the data in f and populate the string to put in
                %numouts
                v = vals(c);
                i = names(c);
                k = strfind(i, 'b');
                
                obj.logger.names{end+1} = strcat('Y',i);
                obj.logger.vals(end+1) = v;
                if ~isempty(k{1}) %filter for only the b values
                   str{end + 1} = char(strcat(i, sprintf(': %f', v)));
                   
                   %Create a new list of data or add to the current list of
                   %data for the corresponding variable.  This data will be
                   %displayed in detailouts when the corresponding
                   %variables is selected from numouts
                   cbts = size(obj.callbacktrack);
                   if cbtc > cbts(2)
                       obj.callbacktrack{cbtc} = {v};
                   elseif obj.loggingEnabled == 1
                      cbtl = obj.callbacktrack{cbtc};
                      cbtl{end + 1} = v;
                      obj.callbacktrack{cbtc} = cbtl;
                   end
                   cbtc = cbtc + 1;
                end
            end
            set(obj.numouts, 'String', str);
            obj.logger.writeTrackEntry(); %log the collected data to a file
        end
        
        
    end
    
end