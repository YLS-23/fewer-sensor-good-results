function filteredTable = positionFilter(input_table)
%过滤数据(最简单粗暴的方式):排除所有max T位于97.5到180度（不含）之间的数据。
%输入表格，输出表格！
    
    %找到需要删除的行的row index 
    %对应的sensor position: 1到11（含），即sensor_data的1到11列
    sensor_data = input_table{1:height(input_table),2:25};
    
    [~, idx] = max(sensor_data,[],2);
    rowsToDelete = [];
    for i = 1:length(idx)
        if idx(i) < 11 %如果找到了对应的列
            rowsToDelete(end+1) = i; %就删除表格的第i行   
        end
    end
    
    %进行行删除
    input_table(rowsToDelete,:) = [];
    filteredTable = input_table;

    %rowsToDelete % Output contents, 并进行简单的可视化聚类
    figure;
    plot(rowsToDelete, '-o',MarkerSize=2);
    title("Clustering of deleted rows")
    ylabel("Indices of deleted rows")
    grid on
    
    %从curve fitting角度，还需要删除前五个传感器所测得的数据。


end