function fig = maxT_position_animation(sensor_position, data_table)
%功能：全区域全时段演示, 但只标注每个时间点maximum的位置
%可能的改进：
%同步演示曲线在test plan中对应的位置
%若maximum处于同一位置，则用同一种颜色的点表示
%用线连接各maximum, 以清晰显示位置的跳变
%画出maximum大小随时间变化的图，与Testplan比照（同步演示）

    time = data_table.timeStamp;
    %将传感器数据以矩阵形式提取，用于画时间截面动画
    sensor_data = data_table{1:length(time),2:end-2};

    %创立figure
    fig = figure; %GPT启发，创建独立的figure
    ax = axes; %GPT启发，添加坐标轴对象，用于添加xlabel,xticks等
    an = animatedline(Marker=".",MarkerSize=8);

    %给fig命名
    set(fig, "Name", "T_max position of "+ data_table.Properties.Description);
    %显示figure名称
    disp(get(fig, 'Name')+": ");

    %xlabel,xlim,xticks,ylabel
    xlabel(ax,'φ in [°]'), xlim(ax,[90 270]);
    xticks(ax,sensor_position);
    ylabel(ax,"T in [°C]");
    grid on

    %动画开始
    for i = 1:height(sensor_data)
        [maximum, idx] = max(sensor_data(i,:));

        % 添加数据点
        addpoints(an,sensor_position(idx),maximum);
        drawnow ; % 增加 limitrate 以加速
    end
    % 强制显示图像
    savefig; openfig;

%进阶功能2: 区分阶梯/周期
end