function splitstandard_data = splitMACAddress(~, standard_data)
    
    MACMap = containers.Map();
    
    for i = 1:length(standard_data)

        if isKey(MACMap, standard_data(i).Destination) == 0
            MACMap(char(standard_data(i).Destination)) = MACMap.length+1;
        end 
    end
    struct_array = struct('MAC','', ...
        'Des_Time',[],'Des_CSIMatrix',{},'Des_Amplitude',{});

    
    for i = 1:length(standard_data)
        if(isempty(standard_data(i).Destination)) 
            continue;
        end
        index = MACMap(char(standard_data(i).Destination));

        
        struct_array(index).MAC = standard_data(i).Destination;
        struct_array(index).Des_Time(end+1,:) = standard_data(i).Time;
        struct_array(index).Des_CSIMatrix(end+1,:) = abs(standard_data(i).CSIMatrix);
    end

    splitstandard_data = struct_array;
    splitstandard_data = processCSI(splitstandard_data,'Amplitude');

    
    
end

function weightedData = processCSI(data, method)

    if strcmp(method, 'Amplitude') == 1
        for i = 1:length(data)

            Des_M = data(i).Des_CSIMatrix;
            if isempty(Des_M) == 0
                for j = 1:length(Des_M(:,1))
                    A = Des_M(j,1);
                    amplitude = mean(A);
                    data(i).Des_Amplitude(end+1,:) = amplitude;
                end
            end
            
            
        end
    end
    weightedData = data;
end

