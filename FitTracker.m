classdef FitTracker < handle
    %FITTRACKER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fitType
        xFit
        yFit
        numouts
        detailouts
        callbacktrack
    end
    
    methods
        
        function obj = FitTracker(ft)
           obj.fitType = ft;
           obj.callbacktrack = {};
        end
        function displayDetails(obj, index)
           set(obj.detailouts, 'String', obj.callbacktrack{index});
        end
        
        function updateNumouts(obj)
           % the following code is used to display the b values from the
            % gaussian fit.  These values correspond to the center points
            % of the peaks that the gaussian fit finds.
            
            %set(obj.numouts,'String', sprintf('%s',f));
            %set(obj.numouts, 'String', {'Hello';'World'});
            %str = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f);
            f = obj.xFit;
            obj.callbacktrack{1} = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f);
            cbtc = 2;
            str = {'X Fit Analysis:'};
            names = coeffnames(f);
            vals = coeffvalues(f);
            s = size(names);
            for c = 1:s(1)
                v = vals(c);
                i = names(c);
                k = strfind(i, 'b');
                if ~isempty(k{1})
                   str{end + 1} = char(strcat(i, sprintf(': %f', v)));
                   cbts = size(obj.callbacktrack);
                   if cbtc > cbts(2)
                       obj.callbacktrack{cbtc} = {v};
                   else
                      cbtl = obj.callbacktrack{cbtc};
                      cbtl{end + 1} = v;
                      obj.callbacktrack{cbtc} = cbtl;
                   end
                   cbtc = cbtc + 1;
                end
            end
            % more code to output to numouts except this time we are using
            % the y values
            f = obj.yFit;
            str{end+1} = 'Y Fit Analysis';
            obj.callbacktrack{cbtc} = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f);
            cbtc = cbtc + 1;
            names = coeffnames(f);
            vals = coeffvalues(f);
            s = size(names);
            for c = 1:s(1)
                v = vals(c);
                i = names(c);
                k = strfind(i, 'b');
                if ~isempty(k{1})
                   str{end + 1} = char(strcat(i, sprintf(': %f', v)));
                   cbts = size(obj.callbacktrack);
                   if cbtc > cbts(2)
                       obj.callbacktrack{cbtc} = {v};
                   else
                      cbtl = obj.callbacktrack{cbtc};
                      cbtl{end + 1} = v;
                      obj.callbacktrack{cbtc} = cbtl;
                   end
                   cbtc = cbtc + 1;
                end
            end
            set(obj.numouts, 'String', str);
        end
        
        
    end
    
end