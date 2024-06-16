function selectedIndices = selectRows(targetTbl,select_n_rows)
%对任意超过n行的表格均匀地提取n行, 返回这n行的索引

% 表格的行数为 numRows
numRows = height(targetTbl); % 这里只是一个示例，你需要根据你的实际情况更改

% 选取的行数目标
numSelectedRows = select_n_rows;

% 生成平均间隔的索引
selectedIndices = round(linspace(1, numRows, numSelectedRows));

end