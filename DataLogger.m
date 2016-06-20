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
            fname = sprintf('Log %s %s.txt', id, char(datetime('now', 'Format', 'yyyy-MM-dd')));
            e = exist(fname, 'file');
            obj.fileid = fopen(fname,'a+');
            if ~e
                fprintf(obj.fileid, 'X,Y,TIME');
            end
        end
        function writeTrackEntry(obj)
            fprintf(obj.fileid, '\n%f,%f,%s', obj.storedx, obj.storedy, char(datetime('now', 'Format', 'HH:mm:ss')));
        end
    end
end