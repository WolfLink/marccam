classdef ImageProcessing
    %IMAGEPROCESSING A static class for data analysis of image data
    
    properties
    end
    
    methods(Static)
        function data = sumX(image)
            if size(image,3) > 1
                try
                    image = rgb2gray(image);
                catch
                    imshow(image)
                end
            end
            data = sum(image);
        end
        function data = sumY(image)
           if size(image,3) > 1
                try
                    image = rgb2gray(image);
                catch
                    imshow(image)
                end
           end
           image = transpose(image);
           data = sum(image);
        end
        
        function fillPlots(img, xplot, yplot, fitTrack)
            fitType = fitTrack.fitType;
            xdata = ImageProcessing.sumX(img);
            f = ImageProcessing.fitWithDataAndType(xdata, fitType);
            fitTrack.xFit = f;
            s = size(xdata);
            axes(xplot);
            plot(xdata);
            axis manual
            axis([0,s(2), min(xdata), max(xdata)]);
            hold on
            plot(f);
            hold off
            ydata = ImageProcessing.sumY(img);
            f = ImageProcessing.fitWithDataAndType(ydata, fitType);
            fitTrack.yFit = f;
            
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
            
            
            fitTrack.updateNumouts();
        end
        function f = fitWithDataAndType(data, fitType)
            [x, y] = prepareCurveData([], data);
            if strcmp(fitType, 'gauss+')
               fitType = 'a1*exp(-((x-b1)/c1)^2)+d1';
               [m,i] = max(data);
               f = fit(x, y, fitType, 'StartPoint', [m,i,1,0]);
            else
                f = fit(x, y, fitType);
            end
        end
        function b = detectBlank(img)
            % if the difference between the brightest line and the darkest
            % line is more than just a few brighter-than-average pixels,
            % then the image contains something interesting.
            if size(img, 3) > 1
                img = rgb2gray(img);
            end
            mama = max(max(img));
            masu = max(sum(img));
            misu = min(sum(img));
            if masu - misu > 3 * mama
                b = 0; %image has content
            else
                b = 1; %image is blank
            end
        end
        
        
    end
end