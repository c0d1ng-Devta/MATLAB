%counts number of times a character comes in text file.
function c=char_counter (a,b)
fid=fopen(a,'rt');
if fid<=0 ||double(b)<32||double(b)>126
    c=-1;
    return
end
a=fscanf(fid,'%c');
k=(a==b);
c=sum(k(:));   