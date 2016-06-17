classdef DataLogger < handle
    %DATALOGGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stringid
        fileid
        
        storedx
        storedy
    end
    
    methods
        function obj = DataLogger(id)
            obj.stringid = id;
            obj.fileid = fopen(sprintf('Log %s %s.txt', id, datetime('now')),'a+');
            fprintf(obj.fileid, 'X,Y,TIME');
        end
        function writeTrackEntry(obj)
            fprintf(obj.fileid, '\n%f,%f,%s', obj.storedx, obj.storedy, datetime('now'));
        end
    end
end