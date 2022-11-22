function plotSimilarity(data)
    
    for i = 1:1
        dataSet = data(i);
        if isempty(dataSet.Des_Amplitude)
            continue;
        end

        des_time = dataSet.Des_Time(:,1);
        des_amplitude = dataSet.Des_Amplitude(:,1);
        %subplot(3, 3, i);
        plot(des_time,des_amplitude,'-');
        hold on



        %plot(des_time,MVMExtraRaw,'-');
        %hold on
    end
end