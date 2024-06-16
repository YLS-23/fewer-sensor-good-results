function output_table = preprocess(input_table)
% 针对结构数组化的表格进行预处理，改为输入表格，输出表格
% （原来是输入表格名，输出表格）

%default: TableDescription = FileName 之后再改
%TableDescription = Input_table;
%output_table.Properties.Description = TableDescription;

%删除meta
output_table = removevars(input_table,["meta0" "meta1" "meta2"]);

%统一表格变量的名称，以便于代码复用 rename -> timeStamp, spez_Pressung, Gleitgeschwindigkeit
output_table = renamevars(output_table,["timeStamp","spez_Pressung","Gleitgeschwindigkeit_m_s_"], ...
    ["timeStamp","spez_Pressung","Gleitgeschwindigkeit"]);

end