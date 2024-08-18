function data = readSnowEx_laser(base_path, siteNum, date_str)
    % Ensure inputs are character vectors or strings
    if iscell(siteNum)
        siteNum = cellfun(@char, siteNum, 'UniformOutput', false);
    end
    if iscell(date_str)
        date_str = cellfun(@char, date_str, 'UniformOutput', false);
    end
    
    % Check if lengths of siteNum and date_str match
    if length(siteNum) ~= length(date_str)
        error('Length of siteNum and date_str must be the same.');
    end
    
    % Initialize a structure to hold data
    data = struct();
    
    % Define the manual column headers
    columnHeaders = {'sampleSignal', 'reflectance', 'SSA', 'topHeight', 'deq', 'comments'};
    
    % Loop through each site-number-date pair
    for i = 1:length(siteNum)
        currentSiteNum = siteNum{i};
        currentDateStr = date_str{i};
        
        % Prepend "site_" to the site number
        tempFieldName = strcat('site_', currentSiteNum);
        
        % Convert site number to a valid MATLAB field name
        validFieldName = matlab.lang.makeValidName(tempFieldName);
        
        % Create the search pattern for the filenames
        pattern = sprintf('SnowEx20_SSA_GM_%s_%s_*_v01.csv', currentDateStr, currentSiteNum);
        full_pattern = fullfile(base_path, pattern);
        
        % Find all files matching the pattern
        files = dir(full_pattern);
        
        % Initialize a cell array to hold concatenated data
        concatenatedData = [];
        
        if isempty(files)
            disp(['No files matching the pattern were found for siteNum "', currentSiteNum, '" and date_str "', currentDateStr, '".']);
        else
            for k = 1:length(files)
                % Read the CSV file
                file_path = fullfile(base_path, files(k).name);
                
                % Open the file and read the content
                fid = fopen(file_path, 'rt');
                fileContent = textscan(fid, '%s', 'Delimiter', '\n');
                fclose(fid);
                
                % Extract the data rows (header row is expected on the 14th line)
                dataRows = fileContent{1}(15:end);
                
                % Read data from rows
                splitData = cellfun(@(x) strsplit(x, ','), dataRows, 'UniformOutput', false);
                
                % Determine the maximum number of columns
                maxCols = max(cellfun(@numel, splitData));
                
                % Initialize an array for the split data
                splitDataArray = cell(length(dataRows), maxCols);
                
                % Fill the split data array
                for row = 1:length(dataRows)
                    splitRow = splitData{row};
                    splitDataArray(row, 1:numel(splitRow)) = splitRow;
                end
                
                % Convert the split data to table columns with specified headers
                splitDataTable = array2table(splitDataArray, 'VariableNames', columnHeaders(1:maxCols));
                
                % Convert table to cell array and concatenate with existing data
                concatenatedData = [concatenatedData; table2cell(splitDataTable)]; %#ok<AGROW>
            end
        end
        
        % Store the concatenated data for this site-number pair in the structure
        data.(validFieldName) = concatenatedData;
    end
end
