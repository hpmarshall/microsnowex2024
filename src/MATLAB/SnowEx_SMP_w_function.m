% Example usage to plot SMP data for multiple sites on a map and force vs depth subplots

%% Define site numbers and date strings
base_path = 'C:\Users\sydne\Downloads\SnowEx\';  % Enter folder with data
siteNum = {'2S7', '2S16', '9C16', '1S17', '2N13'}; % Example site numbers
date_str = {'20200208', '20200208', '20200205', '20200208', '20200206'}; % Example date strings

for s = 1:length(siteNum)
    % Read SMP data for the current site and date
    data = readSnowEx_SMP(base_path, siteNum{s}, date_str{s});
    
    % Check if data is empty (no files found)
    if isempty(data)
        warning(['No data found for site ' siteNum{s} ' on date ' date_str{s}]);
        continue;  % Skip to the next site
    end
    
    % Open a new figure for each site
    figure('Position', [100, 100, 1000, 600], 'Color', 'w');
    
    % Number of files for the current site
    num_files = length(data);
    
    % Use parula colormap for varying colors
    file_colors = parula(num_files);
    
    % Plot SMP locations on map (subplot 1)
    subplot(1, 2, 1); % Assuming 1 row, 2 columns for map and force vs depth
    hold on;
    for i = 1:num_files
        plot(data(i).Lon, data(i).Lat, 'o', 'MarkerSize', 8, 'MarkerFaceColor', file_colors(i, :), 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    end
    % Set axis properties for geographic data
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.XLabel.String = 'Longitude';
    ax.YLabel.String = 'Latitude';
    title(['Locations for Site ' siteNum{s}], 'FontSize', 14, 'FontWeight', 'bold');
    grid on;
    box on;  % Show box around the plot
    axis equal;  % Ensure equal scaling for latitude and longitude
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman'); % Set font to Times New Roman
    
    % Plot force vs depth for each file at the current site (subplot 2)
    subplot(1, 2, 2);
    hold on;
    for i = 1:num_files
        depth = data(i).Depth;
        force = data(i).Force;
        plot(force, -depth, '-', 'Color', file_colors(i, :), 'LineWidth', 1); % Plot force vs depth with specified color
    end
    title(['Force vs Depth for Site ' siteNum{s}], 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Force (N)', 'FontSize', 12);
    ylabel('Depth (mm)', 'FontSize', 12);
    grid on;
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman'); % Set font to Times New Roman
    
end
