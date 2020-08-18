function a=caesar(m,n)
k=zeros(1,length(m));
n=rem(n,95);
for i =1:length(m)
    if (double(m(i))+n)>126
        k(i)=31+((double(m(i))+n)-126);
    elseif (double(m(i))+n)<32
        k(i)=-(32-(double(m(i))+n))+126;
    else
        k(i)=(double(m(i))+n);
    end
end
a=char(k);
        
function txt = caesar1(txt,key)
    txt = double(txt) + key;
    first = double(' ');
    last = double('~');
    % use mod to shift the characters - notice the + 1
    % this is a common error and results in shifts 
    % being off by 1
    txt = char(mod(txt - first,last - first + 1) + first);
end

function y = caesar2(ch, key)
    v = ' ' : '~';
    [~, loc] = ismember(ch, v);
    v2 = circshift(v, -key);
    y = v2(loc);
end