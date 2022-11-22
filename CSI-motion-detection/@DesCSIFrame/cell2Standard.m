function standard = cell2Standard(~, file)
    standard = struct('Source',{},'Destination',{},'Time',{},'CSIMatrix',{});
    
    for i = 1:length(file)
        data_unit = file{i, 1};
    
        StandardHeader = data_unit.StandardHeader;
        MACAddressDestination = join(cellstr(dec2hex(StandardHeader.Addr1)),':');
        MACAddressSource = join(cellstr(dec2hex(StandardHeader.Addr2)),':');

        RxSBasic = data_unit.RxSBasic;

        Timestamp = RxSBasic.Timestamp;
        Time = ConvertDate(Timestamp);
        if Time ~= 0
            CSIMatrix = data_unit.CSI.CSI(:,1);

            standard(end+1) = struct('Source',MACAddressSource, 'Destination',MACAddressDestination, 'Time',Time, 'CSIMatrix',CSIMatrix);
        end 
        
    end

end

% 时间戳转实际时间 (us -> s) + sample time 保留整数
function date = ConvertDate(time)
    date = double(time)/1000000;
end

