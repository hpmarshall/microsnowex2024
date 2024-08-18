% Define base path, site numbers, and date strings
base_path = 'C:\Users\sydne\Downloads\SnowEx\';  % Enter folder with data
siteNum = {'2S7', '2S16', '9C16', '1S17', '2N13'}; % Example site numbers
date_str = {'20200208', '20200208', '20200205', '20200208', '20200206'}; % Example date strings

% Call the function
data = readSnowEx_laser(base_path, siteNum, date_str);

% Define figure properties
fontName = 'Times New Roman';
fontSize = 12;

% Plot data for each site
siteNames = fieldnames(data);

for i = 1:length(siteNames)
    siteName = siteNames{i};
    
    % Replace underscores with spaces in the site name
    siteNameDisplay = strrep(siteName, '_', ' ');
    
    % Extract the data for the current site
    siteData = data.(siteName);
    
    % Convert to table for easier manipulation
    siteTable = cell2table(siteData, 'VariableNames', {'sampleSignal', 'reflectance', 'SSA', 'topHeight', 'deq', 'comments'});
    
    % Check if the required columns are available
    if all(ismember({'SSA', 'topHeight'}, siteTable.Properties.VariableNames))
        % Extract SSA and top height
        SSA = siteTable.SSA;
        topHeight = siteTable.topHeight;
        
        % Convert to numeric arrays, handling non-numeric values
        SSA = str2double(SSA);
        topHeight = str2double(topHeight);
        
        % Remove NaN values (which result from non-numeric conversions)
        validIndices = ~isnan(SSA) & ~isnan(topHeight);
        SSA = SSA(validIndices);
        topHeight = topHeight(validIndices);
        
        % Create a new figure with specified size and position
        figure('Position', [100, 100, 500, 650], 'Color', 'w');
        plot(SSA, topHeight, '-', 'Linewidth', 2);
        
        % Set plot labels and title
        xlabel('Specific Surface Area (SSA)', 'FontName', fontName, 'FontSize', fontSize);
        ylabel('Top Height (cm)', 'FontName', fontName, 'FontSize', fontSize);
        title([siteNameDisplay], 'FontName', fontName, 'FontSize', fontSize);
        
        % Set the font for the axes
        set(gca, 'FontName', fontName, 'FontSize', fontSize);
    else
        warning('Site %s does not contain required columns: SSA and topHeight.', siteName);
    end
end
