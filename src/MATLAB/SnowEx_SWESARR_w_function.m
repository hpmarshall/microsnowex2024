% Define inputs
base_path = 'C:\Users\sydne\Downloads\SnowEx\';
siteNames = {'GRMST1', 'GRMST1', 'GRMST1', 'GRMNT1', 'GRMCT2'}; % NOT site numbers, SWESARR flight sites
flightNums = {'27503', '27401', '27502', '09501', '13801'}; % Ensure these are strings
dates = {'200212', '200212', '200212', '200211', '200211'}; % Corresponding dates in YYMMDD format

% site lat/lons (to pull out SWESARR info closest to points
site_2S7_lon = -108.197787563804; site_2S7_lat = 39.0186601908570; 
site_2S16_lon = -108.182250287817; site_2S16_lat = 39.0187721358515; 
site_9C16_lon = -108.197052406491; site_9C16_lat = 39.0442732839490; 
site_1S17_lon = -108.181784067249; site_1S17_lat = 39.0197518601843; 
site_2N13_lon = -108.196258636639; site_2N13_lat = 39.0339658591742; 

% Initialize cell array to hold data
allData = cell(numel(siteNames), 1);

% Loop through each site name, flight number, and date
for i = 1:numel(siteNames)
    siteName = siteNames{i};
    flightNum = flightNums{i};
    date_str = dates{i};
    
    % Call the function
    allData{i} = readSnowEx_SWESARR(base_path, siteName, flightNum, date_str);
    
    % Display the result
    fprintf('Data for site %s, flight number %s, and date %s loaded.\n', siteName, flightNum, date_str);
end

% Display the results
disp(allData);
