function data = readSnowEx_SWESARR(base_path, siteName, flightNum, date_str)
    % NOTE: flight paths were manually selected based on proximity to site
    % site 2S7: SNEX20_SWESARR_TB_GRMST1_27503_20008_000_200212_XKKa225H_v01.csv 
    % site 1S17: SNEX20_SWESARR_TB_GRMST1_27401_20008_000_200212_XKKa225H_v01.csv 
    % site 2S16: SNEX20_SWESARR_TB_GRMST1_27502_20008_000_200212_XKKa225H_v01.csv 
    % site 2N13: SNEX20_SWESARR_TB_GRMNT1_09501_20007_000_200211_XKKa225H_v01.csv 
    % site 9C16: SNEX20_SWESARR_TB_GRMCT2_13801_20007_000_200211_XKKa225H_v01.csv 
    
    % NAMING CONVENTION (ex/ GRMST1): in "(...)_GRMST1_27503_20008_000_200212_XKKa225H_v01":
    % GRMST1 = site name (S = south, N = north, C = cross line)
    % 275 = bearing
    % 03 = repeat count
    % 20008 = flight number
    % 000 = data take
    % 200212 = date (YYMMDD)
    % XKKa = band (could be X, Ku, K, or Ka)
    % 225 = look angle (°)
    % H = polarization (could be VH and VV or H)
    % v01 = version
    
    % Validate inputs
    if nargin ~= 4
        error('Please provide base path, site name, flight number, and date string.');
    end
    
    % Convert flight number to string with leading zeros if necessary
    flightNumStr = sprintf('%05s', flightNum); % Use '%05s' for strings
    
    % Create a search pattern based on site name, flight number, and date
    searchPattern = sprintf('*%s*%s*%s*.csv', siteName, flightNumStr, date_str);
    fprintf('Search pattern: %s\n', searchPattern);
    
    % Get a list of files matching the search pattern
    files = dir(fullfile(base_path, searchPattern));
    
    % Print filenames for verification
    if isempty(files)
        fprintf('No files found matching the pattern: %s\n', searchPattern);
    else
        for i = 1:numel(files)
            disp(files(i).name);
        end
    end
    
    % Check if files are found
    if isempty(files)
        error('No files found matching the pattern %s.', searchPattern);
    elseif numel(files) > 1
        warning('Multiple files found matching the pattern. The first file will be selected.');
    end
    
    % Initialize data structure
    data = struct();
    
    % Loop over found files (just taking the first match if multiple)
    for i = 1:numel(files)
        if i > 1
            break; % Only take the first file if multiple are found
        end
        
        fileName = files(i).name;
        filePath = fullfile(base_path, fileName);
        
        % Read the .csv file with original column names
        dataTable = readtable(filePath, 'VariableNamingRule', 'preserve');
        
        % Store information
        data.FileName = fileName;
        data.FilePath = filePath;
        data.Data = dataTable;
        
        % Display the read information
        fprintf('Data successfully read from %s\n', filePath);
    end
end
