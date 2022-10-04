function data = Data2Frame2(file)
    data_array = struct('Source',{},'Destination',{},'Time',{},'CSIMatrix',{}, 'MVMExtra',{});
    
    Addr1Content = file{1,1}.Header.Addr1;

    for i = 1:length(Addr1Content)
        data_unit = file{1, 1};
    
        StandardHeader = data_unit.Header;
        MACAddressDestination = join(cellstr(dec2hex(StandardHeader.Addr1(i,1:6))),':');
        MACAddressSource = join(cellstr(dec2hex(StandardHeader.Addr2(i,1:6))),':');
        MVMExtra = data_unit.MVMExtra.Raw(i, 267);
        %267 未经agc的原始signal

        RxSBasic = data_unit.Basic;

        Timestamp = RxSBasic.Timestamp;
        Time = ConvertDate(Timestamp(i,1));
        if Time ~= 0
            CSIMatrix = data_unit.CSI(i,:);

            data_array(end+1) = struct('Source',MACAddressSource, 'Destination',MACAddressDestination, 'Time',Time, 'CSIMatrix',CSIMatrix, 'MVMExtra',MVMExtra);
        end 
        
    end
    
    [b, index] = sort([data_array.Time]);
    data = splitMACAdress(data_array(index));

    %计算Raw和Amplitude的相关系数r
    


end

% 时间戳转实际时间 (us -> s) + sample time 保留整数
function [ date ] = ConvertDate(time)
    date = double(time)/1000000;
end

%分离information,b
function splitData = splitMACAdress(data)
    
    MACMap = containers.Map();
    
    for i = 1:length(data)
        if isKey(MACMap, data(i).Source) == 0
            MACMap(char(data(i).Source)) = MACMap.length+1;
        end
        if isKey(MACMap, data(i).Destination) == 0
            MACMap(char(data(i).Destination)) = MACMap.length+1;
        end 
    end

    struct_array = struct('MAC','', ...
        'Des_Time',[],'Des_CSIMatrix',{},'Des_Amplitude',{}, 'MVMExtraRaw',{},'Des_Similarity',{});

    
    for i = 1:length(data)
        index = MACMap(char(data(i).Destination));

        if mean(abs(data(i).CSIMatrix)) == 0
            continue;
        end
        struct_array(index).MAC = data(i).Destination;
        struct_array(index).Des_Time(end+1,:) = data(i).Time;
        struct_array(index).Des_CSIMatrix(end+1,:) = abs(data(i).CSIMatrix);
        struct_array(index).MVMExtraRaw(end+1,:) = data(i).MVMExtra;
    end

    
    splitData = struct_array;
    splitData = processCSI(splitData,'Amplitude');

    %splitData = processCSI(splitData,'Euclid');
    
    
end

%CSIMatrix处理
function weightedData = processCSI(data, method)

    if strcmp(method, 'Euclid') == 1
        for i = 1:length(data)
            M = data(i).CSIMatrix;
            for j = 1:length(M(:,1))-1
               A = M(j);
               B = M(j+1);
               C = (A-B);
               distance = abs(sum(C(:)));
               similarity = 1/(1 + distance);
               data(i).Similarity(end+1,:) = distance;
            end
            
        end
        %MIN = min(data(i).Similarity(:,1));
        %MAX = max(data(i).Similarity(:,1));
        %M = (data(i).Similarity(:,1) - MIN)/(MAX - MIN);
        %data(i).Similarity(:,1) = M;


    elseif strcmp(method, 'Amplitude') == 1
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

