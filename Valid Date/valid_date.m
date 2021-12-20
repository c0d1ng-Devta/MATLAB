function a=valid_date (y,m,d)
if y>0 && m>0 && d>0 && isscalar(y) && isscalar(m)&& isscalar(d) && m<=12 ... 
    && sum(floor([y m d])==[y, m ,d])
    if sum(ismember([1,3,5,7,8,10,12],m))&&d<=31
        a=true;
    elseif sum(ismember([4 6 9 11],m))&& d<=30
        a=true;
    elseif rem(y,4)==0&&((rem(y,100)~=0 && rem(y,400)~=0) || (rem(y,100)==0 && rem(y,400)==0))&& d<=29
        a=true;
    elseif d<=28
        a=true;
    else
        a=false;
    end
else
    a=false;
end

