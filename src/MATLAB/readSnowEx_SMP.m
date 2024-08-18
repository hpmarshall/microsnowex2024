function data = readSnowEx_SMP(base_path, siteNum, date_str)
    % Construct the filename pattern
    filename_pattern = sprintf('SNEX20_SMP_*_%s_%s.csv', siteNum, date_str);
    
    % Find all matching files in the directory
    files = dir(fullfile(base_path, filename_pattern));
    
    % Check if any files are found
    if isempty(files)
        data = [];  % Return empty if no files found
        return;
    end
    
    % Initialize structure array to store data
    data = struct('Lat', {}, 'Lon', {}, 'Depth', {}, 'Force', {});
    
    % Loop through each file
    for i = 1:length(files)
        % Construct the full file path
        filepath = fullfile(base_path, files(i).name);
        
        % Read the data from the CSV file, skipping the first 7 rows
        opts = detectImportOptions(filepath);
        opts.DataLines = [8, Inf]; % Specify data lines starting from row 8
        tmp_data = readmatrix(filepath, opts);
        
        % Extract Lat, Lon from the first 7 rows
        fid = fopen(filepath);
        for j = 1:7
            line = fgetl(fid); % Read line-by-line until we reach the 7th line
            if contains(line, 'Lat:')
                C = strsplit(line, ':');
                lat = str2double(C{2});
                data(i).Lat = lat;
            elseif contains(line, 'Lon:')
                C = strsplit(line, ':');
                lon = str2double(C{2});
                data(i).Lon = lon;
            elseif contains(line, 'SMP Serial Number:')
                C = strsplit(line, ':');
                smp_serial = strtrim(C{2});
                data(i).SMP_Serial = smp_serial;
            elseif contains(line, 'Total Samples:')
                C = strsplit(line, ':');
                total_samples = str2double(C{2});
                data(i).Total_Samples = total_samples;
            end
        end
        fclose(fid);
        
        % Assign depth and force data
        data(i).Depth = tmp_data(:, 1);
        data(i).Force = tmp_data(:, 2);
        
        % Check if Depth and Force lengths match
        if length(data(i).Depth) ~= length(data(i).Force)
            warning(['Skipping file ' files(i).name ' - Depth and Force lengths do not match']);
            % Remove this entry from the data structure
            data(i) = [];
        end
    end
end
