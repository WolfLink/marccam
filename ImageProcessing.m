classdef ImageProcessing
    %IMAGEPROCESSING A static class for data analysis of image data
    
    properties
    end
    
    methods(Static)
        function data = sumX(image)
            try
                image = rgb2gray(image);
            catch
                imshow(image)
            end
            data = sum(image);
        end
        function data = sumY(image)
           image = rgb2gray(image);
           image = transpose(image);
           data = sum(image);
        end
        function fillPlots(img, xplot, yplot, numouts, fitType)
            if strcmp(fitType, 'gauss+')
               fitType = 'a1*exp(-((x-b1)/c1)^2)+d1';
            end
            xdata = ImageProcessing.sumX(img);
            [x, y] = prepareCurveData([], xdata);
            f = fit(x, y, fitType);
            
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
            s = size(xdata);
            axes(xplot);
            plot(xdata);
            axis manual
            axis([0,s(2), min(xdata), max(xdata)]);
            hold on
            plot(f);
            hold off
            ydata = ImageProcessing.sumY(img);
            [x, y] = prepareCurveData([], ydata);
            f = fit(x, y, fitType);
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
            s = size(ydata);
            axes(yplot);
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
            
            
            set(numouts, 'String', str); 
        end
    end
end