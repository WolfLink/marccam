classdef ImageProcessing
    %IMAGEPROCESSING A static class for data analysis of image data
    
    properties
    end
    
    methods(Static)
        function data = sumX(image)
            image = rgb2gray(image);
            data = sum(image);
        end
        function data = sumY(image)
           image = rgb2gray(image);
           image = transpose(image);
           data = sum(image);
        end
    end
end