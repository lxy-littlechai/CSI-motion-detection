function standard = RXSBundle2Standard(~, file)
    standard = struct('Source',{},'Destination',{},'Time',{},'CSIMatrix',{});
    
    data_unit = file;
    len = length(file.StandardHeader.Addr1);
    for i = 1:len
        
    
        StandardHeader = data_unit.StandardHeader;
        MACAddressDestination = join(cellstr(dec2hex(StandardHeader.Addr1(i,1:6))),':');
        MACAddressSource = join(cellstr(dec2hex(StandardHeader.Addr2(i,1:6))),':');


        Timestamp = data_unit.Basic.Timestamp(i);
        Time = ConvertDate(Timestamp);
        if Time ~= 0
            csi = data_unit.CSI{1,1};
            CSIMatrix = csi(i,:);

            standard(end+1) = struct('Source',MACAddressSource, 'Destination',MACAddressDestination, 'Time',Time, 'CSIMatrix',CSIMatrix);
        end 
        
    end
end

% 时间戳转实际时间 (us -> s) + sample time 保留整数
function date = ConvertDate(time)
    date = double(time)/1000000;
end
