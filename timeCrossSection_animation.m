function fig = timeCrossSection_animation(sensor_position, data_table, speedUp_No_0_Yes_1)
%基本功能：全区域全时段演示
%可能的改进：同步演示曲线在test plan中对应的位置

    %Speed Up, default slow
    if speedUp_No_0_Yes_1 == 1
        pauseTime = 0.01;
    else
        pauseTime = 0.4;
    end
    
    time = data_table.timeStamp;
    %将传感器数据以矩阵形式提取，用于画时间截面动画
    sensor_data = data_table{1:length(time),2:end-2};

    %创立figure
    fig = figure; %GPT启发，创建独立的figure
    %给fig命名
    set(fig, "Name", "Animation for "+ data_table.Properties.Description);
    %显示figure名称
    disp(get(fig, 'Name')+": ");

    %plot曲线全部
    plot(sensor_position,sensor_data(1,:),'.-');
    xlabel('φ in [°]'), xlim([90 270])
    xticks(sensor_position)
    ylabel("T in [°C]")
    title("Cross Sectional Data Animation")
    pause(pauseTime)
    hold on
    for i = 2:height(sensor_data)
        plot(sensor_position,sensor_data(i,:),'.-')
        pause(pauseTime)
    end
    hold off
    
    
%进阶功能1：Maximum标注

%进阶功能2: 区分阶梯/周期
end