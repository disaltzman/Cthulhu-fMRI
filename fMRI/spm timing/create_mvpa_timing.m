 % find all excel files in directory
sessionFiles = dir('*.xlsx');
allNames = {sessionFiles.name}';

% specify the name of your different conditions as they appear in your
% behavioral output
conditionNames = {'vowelstep1.wav','vowelstep3.wav','vowelstep5.wav','vowelstep7.wav','sinestep1.wav','sinestep3.wav','sinestep5.wav','sinestep7.wav','catch.wav'};
conditions = length(conditionNames);

% specify the number of runs and the amount of rows in your excel file
% each run is
runs = 10;
runLength = 160;

% specify what row of your excel file data begins on (this is usually row 2
% if you have headers in the first row)
runStart = 92;

% go through excel files to grab relevant column information for SPM
for i=1:length(sessionFiles)
    [~,fileName,~] = fileparts(allNames{i});
    % initialize cells SPM needs
    names = conditionNames;
    onsets = cell(1,conditions);
    durations = {2};
    durations = repmat(durations,1,conditions);  
    
    % read in excel file
    [num,txt,raw] = xlsread(sessionFiles(i).name);
    
    % for loop for each run
    for r=1:runs
        if r==1
            runStart = runStart;
        else
            % for run 2+, change runStart so it is appropriate for your
            % next run
            runStart = runStart+runLength;
        end
        
        % separate data for current block
        current_block = raw(runStart:(runLength*r)+1,1:10);
        
        % grab onset information
        for j=1:conditions
                        
            % create a cell that just has the list of stimulus names from
            % the current block
            trialType = current_block(:,4);
            
            % find the indices of the stimuli that match the
            % current condition we're finding the onset for and then check
            % against the "onset" column in your excel file
            index = strcmp(trialType,conditionNames(j));           
            trialOnsets=double(length(trialType));
            trialOnsets=current_block(find(index),10);
            onsets{1,j} = cell2mat(trialOnsets);
        end
        
        % save new data for SPM
        %timing_name = erase(sessionFiles.name,'.xlsx');
        save(num2str(r),'names','onsets','durations');
        clear onsets 
    end       
end