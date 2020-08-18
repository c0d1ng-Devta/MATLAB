function d=get_distance (a,b)
[~,~,raw]=xlsread('Distances.xlsx');
m=size(raw);
r=0;c=0;
for k=2:m
        if string(raw{k,1}) == string(a)
            r=k;
        end
        if string(raw{k,1}) == string(b)
            c=k;
        end
end
if r~=0 && c~=0
    d=raw{r,c};
else
    d=-1;
end
