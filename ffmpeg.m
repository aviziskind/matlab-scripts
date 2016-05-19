function vals_out = ffmpeg(videoFileName, opt)

    if isfield(opt, 'get') && ~isempty(opt.get)
        
        cmd = sprintf('ffprobe %s ', videoFileName);
        [status,cmd_out] = system(cmd);
        assert(status == 0);
        %%
        cmd_out_C= strsplit(cmd_out, '\n');
        for i = 1:length(cmd_out_C)
            str = cmd_out_C{i};
            if ~isempty(strfind(str, 'Duration'))
%                   Duration: 00:11:05.65, start: 0.000000, bitrate: 25719 kb/s
                X = regexp(str, 'Duration: (\d+):(\d+):(\d+).(\d+),', 'tokens');
                nHours = str2double(X{1}{1});
                nMin = str2double(X{1}{2});
                nSec = str2double(X{1}{3});
                nSplitSec = str2double(X{1}{4});
                duration = nHours*3600 + nMin*60 + nSec + nSplitSec/100;
            end
            if ~isempty(strfind(str, 'Stream'))
%                 Stream #0:0: Video: ffv1 (FFV1 / 0x31564646), gray, 640x480, 25717 kb/s, 20 fps, 20 tbr, 20 tbn
                X_dims = regexp(str, ' (\d+)x(\d+), ', 'tokens');                
                width = str2double(X_dims{1}{1});
                height = str2double(X_dims{1}{2});
                
                X_fps = regexp(str, ' (\d+) fps, ', 'tokens');                
                fps = str2double(X_fps{1}{1});
            end
        end  
        %%
        nframes = fps * duration;

        toGet = opt.get;

        isCell = iscell(toGet);
        
        if ~isCell
            toGet = {toGet};
        end
        vals_out = cell(1,length(toGet));
        
        for i = 1:length(toGet)

            switch toGet{i}
                case 'fps',      vals_out{i} = fps;
                case 'duration', vals_out{i} = duration_sec;
                case 'nframes',  vals_out{i} = nFrames;
                case 'height',   vals_out{i} = height;
                case 'width',    vals_out{i} = width;
                case 'info',     vals_out{i} = struct('fps', fps, 'duration', duration, 'width', width, 'height', height, 'nframes', nframes);
            end

        end
        
        if ~isCell
            vals_out = vals_out{1};
        end
        return
    end
    

    
    info = ffmpeg(videoFileName, struct('get', 'info'));
%     timeStart_str = '';
    
    dest_dir = '';
    if isfield(opt, 'dest_dir')
        dest_dir = opt.dest_dir;
    end

    image_template_str = 'frame_%06d.jpg';
    if isfield(opt, 'image_template_str')
        image_template_str = opt.image_template_str;
    end
    
    quality_str = '-q:v 1';
    if isfield(opt, 'quality')
        quality_str = sprintf(' -q:v %d', opt.quality);
    end
    
%     if isfield(opt, 'frameStart')
%     
%         
%     end
    
    overwrite = true;
    if isfield(opt, 'overwrite')
        overwrite = opt.overwrite;
    end
    overwrite_str = iff(overwrite, ' -y', '');
    
    
    
    frameIds = [];
    if isfield(opt, 'frameIds')
        frameIds = opt.frameIds;
    end
    
    frames = ''; % 'all'
    if isfield(opt, 'frames')
        frames = opt.frames;
    end
    
    
   
    
    
    
%     if strncmp(subdir, '/f/', 3)
%         dest_dir = '';
%     end
%     if ~exist([dest_dir subdir], 'dir')
%         fprintf('Creating sub-folder %s\n', subdir);
%         mkdir([dest_dir subdir])
%     end
%     
%     if 
    
    
    if isempty(frameIds)
        nFrm = str2double(frames);
        if strcmp(frames, 'all')
            frame_str = '';
        elseif ~isnan(nFrm)
            frame_str = sprintf(' -vframes %d', nFrm);
        end

        cmd = sprintf('ffmpeg -i %s %s  %s  ''%s%s'' ', ...
                    videoFileName, frame_str, quality_str, dest_dir, image_template_str);
        fprintf('%s\n', cmd);
        tic;

        cmd_str = sprintf('ffmpeg -i %s', videoFileName);
        [status, output] = system(cmd_str);
        assert(status == 0);

%             system(cmd);
        toc;


    else  % get a particular set of frames

        grps = continuousGroupings(frameIds);

        for grp_i = 1:length(grps)
            grpFrameIds = grps{grp_i};

            assert( all(diff(grpFrameIds)  == 1 ));

%                     nFrames = length(grpFrameIds);
%                     frame_name = sprintf('face_%03d_frame-%06d.jpg', face_id, frameIds(frm_i) );

            nsec_start = (grpFrameIds(1)-1) / info.fps;
            nFramesInGroup = length(grpFrameIds);

            [~, time_sec, time_min, time_hrs] = sec2hms(nsec_start);
            time_str = sprintf('%02d:%02d:%09.6f', time_hrs, time_min, time_sec);
%             time_str = char( duration(0,0,nsec_start, 'format', 'hh:mm:ss.SSSSSS'));

%                 ffmpeg -i myvideo.avi -ss 00:01:00 -vframes 1 myclip.avi
            if nFramesInGroup == 1
                image_name_str = sprintf(image_template_str, grpFrameIds);
            else
                image_name_str = image_template_str;
            end

            cmd = sprintf('ffmpeg -ss %s -i %s %s   -vframes %d  %s  %s%s ', ...
                time_str, videoFileName, overwrite_str, nFramesInGroup,  quality_str, dest_dir, image_name_str);

            fprintf('Group %d/%d (frameIds = %d:%d) : \n ', grp_i, length(grps), grpFrameIds(1), grpFrameIds(end) )
%                 fprintf('%s\n', cmd);
%                 tic;
            [status, cmd_out] = system(cmd);
            assert(status == 0);
%                 toc;
        end


    end
        3;
        
        
    
% ffmpeg -i clipCHPV_0000_0000_10_130205_0021_00041_Face.avi -vframes 5000  -q:v 1  './face_041/face_041_%06d.jpg'
%}

end



% [105,  130?    112(night]
% list driver ids in fhwa_day
%  171 ( 9.6%) :  53 
%  171 ( 9.6%) :  56 
%  158 ( 8.9%) :  72 
%  229 (12.9%) :  88 
%  160 ( 9.0%) :  92 
%  161 ( 9.1%) :  108 
%  178 (10.0%) :  119 
%  186 (10.5%) :  122 
%  185 (10.4%) :  136 
%  175 ( 9.9%) :  153 