function testplan = testplan_visualization(data_table)
%功能：test plan可视化 (速度，压强) ，创建一个figure (tiledlayout = 两个subplot）
%未来或许可以以某种方式和时间截面数据动画联动
    
    Gleitgeschwindigkeit = data_table.Gleitgeschwindigkeit;
    spez_Pressung = data_table.spez_Pressung;
    time = data_table.timeStamp;

    %将传感器数据以矩阵形式提取，用于增加与时间截面动画联动的功能
    sensor_data = data_table{1:length(time),2:end-2};
    
    figure;
    testplan = tiledlayout(3,1,"TileSpacing","compact");
    
    %用\去除下划线的特殊含义
    %对总图进行标注
    titleForDisplay = replace(data_table.Properties.Description,"_","\_");
    title(testplan,"Test Plan for "+ titleForDisplay);
    xlabel(testplan,"t in [h]")
    
    %tile for specific pressure
    ax1 = nexttile; %虽然 axes object 的字面意思是“图的轴”，但在 MATLAB 中，
    % 它实际上表示了整个图形对象，包括图形窗口中的坐标轴以及其他与图形相关的元素。
    plot(time,spez_Pressung)
    ylabel("p in [MPa]")
    title("Specific Pressure")
    ylim([0, max(spez_Pressung)+1])

    %tile for circumferential speed
    ax2 = nexttile;
    plot(time,Gleitgeschwindigkeit)
    ylabel("v in [m/s]")
    title("Circumferential Speed")
    ylim([0, max(Gleitgeschwindigkeit)+1])

    %联动max T值随时间变化的图像
    ax3 = nexttile;
    maxT_vector = max(sensor_data,[],2); % max T的列向量
    plot(time,maxT_vector,'.-');
    ylabel("T in [°C]")
    title("Temperature")
    %联动T_mean值随时间变化的图像
    hold on
    avgT_vector = mean(sensor_data,2);
    plot(time,avgT_vector,'.-');
    hold off
    legend("max. T","avg. T");

    %联动共同横轴（时间轴）
    linkaxes([ax1,ax2,ax3],'x');
    %display max T
    disp("The documented max. T reached "+ num2str(max(maxT_vector))+" ℃.");

    % 强制显示图像
    %savefig;     openfig;
   
end