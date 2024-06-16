function [adjusted_R2,RSS] = adj_R2_polyfit(input_table,n,degree)
%均匀选择表格中的n行，对每一行数据分别进行不同次数的多项式拟合，并计算adjusted R^2值

% 举例，n = 10, degree = 3:6, 则：
% adjusted_R2矩阵有4行，分别对应三次、四次、五次和六次多项式拟合的adjusted R^2值；
% adjusted_R2矩阵有10列，分别对应表格中被均匀选中的10行。

selected_rows = selectRows(input_table,n);
adjusted_R2 = zeros(length(degree),length(selected_rows)); % 创建空白矩阵
RSS = zeros(length(degree),length(selected_rows)); % 创建空白矩阵

for i = 1:n
    % 提取该行中相关的列（end-19+1:end-2）
    rowData = input_table{selected_rows(i),end-18:end-2};

    % 对每一行数据分别进行..次、..次、和..次多项式拟合，并计算 adjusted R^2 值
    for j = degree
        % 用 polyfit 对当前行的数据进行多项式拟合
        p = polyfit(1:length(rowData), rowData, j);
        
        % 计算拟合后的预测值
        yfit = polyval(p, 1:length(rowData));
        
        % 计算拟合残差
        residuals = rowData - yfit;
        
        % 计算总平方和
        SS_total = sum((rowData - mean(rowData)).^2);
        
        % 计算残差平方和
        SS_residual = sum(residuals.^2);
        
        % 计算并填入 adjusted R^2 值
        adjusted_R2(j-(degree(1)-1), i) = ...
            1-SS_residual/SS_total*(size(input_table,2)-1)/(size(input_table,2)-j-1);

        % 填入RSS值
        RSS(j-(degree(1)-1), i) = SS_residual;
    end
end

end