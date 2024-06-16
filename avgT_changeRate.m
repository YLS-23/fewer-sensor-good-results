function slopeVector = avgT_changeRate(input_table)
% 用于计算平均温度的变化率。返回一个比表格行数少一的平均温度斜率的列向量。
% 每7.2秒采集一次数据

% 提取数据
sensor_data = input_table{1:height(input_table),2:25};
time = input_table.timeStamp;

% 提取平均温度
avgT_vector = mean(sensor_data,2);
% 提取deltaT
deltaT = diff(avgT_vector); % in [℃]
% 提取时间间隔
deltaTime = diff(time)*3600; % in [s]

% 得到斜率
slopeVector = deltaT./deltaTime; % in [℃/s]

end