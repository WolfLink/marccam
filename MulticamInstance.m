classdef MulticamInstance
    %MULTICAMINSTANCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figure
        numID
    end
    
    methods
        function obj = MulticamInstance(f)
            obj.figure = f;
            obj.numID = f.Number;
        end
    end
    
    methods(Static)
        function i = instanceForFigure(fig)
            persistent hmap;
            num = fig.Number;
            if isempty(hmap)
                i = MulticamInstance(fig);
                hmap = containers.Map(num, i);
            elseif hmap.isKey(num)
                i = hmap(num);
            else
                i = MulticamInstance(fig);
                hmap(num) = i;
            end
        end
    end
    
end