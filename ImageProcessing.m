classdef ImageProcessing
    %IMAGEPROCESSING A static class for data analysis of image data.
    
    properties
    end
    
    methods(Static)
        function data = sumX(image)
            %Returns an array of data that corresponds to the sums of the
            %pixel intensities in each column.
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
           %Returns an array of data that corresponds to the sums of pixel
           %intensities in each row.
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
            %plots data from the given image onto the given axes xplot and
            %yplot and records its results in the given FitTracker object.
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
            smap = flip(1:s(2));
            axes(yplot);
            plot(ydata,smap);
            axis manual
            axis([min(ydata),max(ydata),0,s(2)]);
            %axis([0,s(2),min(ydata),max(ydata)]);
            hold on
            plot(feval(f,1:s(2)),smap);
            hold off
            %view(-90, 90);
            set(gca, 'xdir', 'reverse');
            
            
            fitTrack.updateNumouts();
        end
        function f = fitWithDataAndType(data, fitType)
            %Applies a fit of the given type to the given data and returns
            %the results.
            [x, y] = prepareCurveData([], data);
            switch fitType
                case 'gauss1+'
                    fitType = 'a1*exp(-((x-b1)/c1)^2)+d1';
                    [m,i] = max(data);
                    f = fit(x, y, fitType, 'StartPoint', [m,i,1,0]);
                case 'gauss2+'
                    fitType = 'a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+d1';
                    [m,i] = max(data);
                    f = fit(x, y, fitType, 'StartPoint', [m,i,1,m,i,1,0]);
                case 'gauss3+'
                    fitType = 'a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+a3*exp(-((x-b3)/c3)^2)+d1';
                    [m,i] = max(data);
                    f = fit(x, y, fitType, 'StartPoint', [m,i,1,m,i,1,m,i,1,0]);
                case 'gauss4+'
                    fitType = 'a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+a3*exp(-((x-b3)/c3)^2)+a4*exp(-((x-b4)/c4)^2)+d1';
                    [m,i] = max(data);
                    f = fit(x, y, fitType, 'StartPoint', [m,i,1,m,i,1,m,i,1,m,i,1,0]);
                otherwise
                    f = fit(x,y,fitType);
            end
        end
        function b = detectBlank(img)
            %Detects whether the image is empty (monocolored) or has
            %something interesting.  Returns 1 if the image is blank and 0
            %if the image has content.
            
            b = ImageProcessing.linearFitter(img);
            
            %if size(img, 3) > 1
            %    img = rgb2gray(img);
            %end
            %mama = max(max(img));
            %masu = max(sum(img));
            %misu = min(sum(img));
            %if masu - misu > 3 * mama
            %    b = 0; %image has content
            %else
            %    b = 1; %image is blank
            %end
        end
        function b = threshold(img, v)
            %Applies a threshold to the total value of the image.  This is
            %a rudimentary function to be used by the detectBlank function.
            if sum(sum(img)) > 200000
                b = 1;
            else
                b = 0;
            end
        end
        function b = maxCluster(img)
           % An algorithm designed to detect whether the image or blank or
           % not.  It finds the 5 brightest columns of the image, computes
           % the standard deviation of their indexes, and comapares that
           % value to the width of the image.
           if size(img, 3) >  1
               img = rgb2gray(img);
           end
           data = sum(img);
           %rindices = randperm(size(data,2));
           %rdata(rindices) = data;
           [~, i] = sort(data); %has an issue with all black images
           %i = rindices(i);
           sd = std([i(end), i(end-1), i(end-2),i(end-3),i(end-4)]); %take the standard devition of the x positions of the 5 brightest columns
           %disp(sd)
           %disp(size(img))
           %disp(size(i))
           %disp([i(end), i(end-1), i(end-2), i(end-3), i(end-4)])
           if sd > size(img,2) / 30
               b = 1; %if the brightest columns are very spread compared to the size of the image, then the image must be blank
           else
               b = 0; %if the brightest columns are clustered compared to the size of the image, then the image must have content.
           end
        end
        
        function b = linearFitter(img)
            %An algorithm designed to detect blank images by seeing how
            %well the image matches a constant fit.  If the data matches a
            %constant fit well then we are looking at noise with no clear
            %signals.
            %weakness: this algorithm detects gradients or other forms of
            %uneven background lighting as a signal
            if size(img, 3) >  1
               img = rgb2gray(img);
            end
            d = sum(img);
            [x,y] = prepareCurveData([], d);
            f = fit(x, y, 'x*0 + a1', 'StartPoint', 0);
            c = confint(f, 0.99);
            %disp(c(2) - c(1));
            %disp(size(img,1)/10);
            v = c(2) - c(1);
            %if v > max(d) / 100
            if v > size(img, 1)/10
                b = 0; %if there is a large difference between the confidence interval bounds, then the image has content
            else
                b = 1; %if there is not much difference between the confidence interval bounds, then the image is blank.
            end
        end
        
    end
end