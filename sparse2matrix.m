function m=sparse2matrix (c)
m=c{2}.*ones(c{1});
for n= 3:length(c)
    m(c{n}(1),c{n}(2))=c{n}(3);
end