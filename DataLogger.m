classdef DataLogger < handle
    %DATALOGGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stringid
        fname
        fid
        vals
        names
    end
    
    methods
        function obj = DataLogger(id)
            obj.stringid = id;
            obj.fname = sprintf('Log %s %s.csv', id, char(datetime('now', 'Format', 'yyyy-MM-dd')));
        end
        function writeTrackEntry(obj)
            e = exist(obj.fname, 'file');
            if isempty(obj.fid)
                obj.fid = fopen(obj.fname,'a+');
            end
            fileid = obj.fid;
            if ~e
                for i = obj.names
                    fprintf(fileid, sprintf('%s,', char(i{1})));
                end
                fprintf(fileid, 'Time');
            end
            fprintf(fileid, '\n');
            for i = obj.vals
                if size(i,2) > 1
                    fprintf(fileid, '%f,', (i(1) + i(2)) / 2);
                else
                    fprintf(fileid, '%f,', i);
                end
            end
            fprintf(fileid, '%s', char(datetime('now', 'Format', 'HH:mm:ss')));
        end
    end
end