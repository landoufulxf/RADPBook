%Global ADP
global W F Q
F=-1*[1 0.1 1];
Q=[1 0 0;0 1 0;0 0 1];
W=[0 0 0];
P=[10 0;0 10]; 
Psave=[];
Qsave=[];

Qk = Q + 1/4*W'*W;

for i=1:10
    cvx_begin sdp
    
    variable dQs(3,3) symmetric
    variable Wn(1,3)
    variable mu
    
    dQ=-(Wn'*(F-1/2*W)+Q+1/4*(W'*W));
    dQs(1,1)==dQ(1,1);                          %#ok<EQEFF> CVX syntax
    dQs(1,2)+dQs(2,1)==dQ(1,2)+dQ(2,1);
    dQs(1,3)+dQs(3,1)+dQs(2,2)==dQ(1,3)+dQ(3,1)+dQ(2,2);
    dQs(3,2)+dQs(2,3)==dQ(3,2)+dQ(2,3); 
    dQs(3,3)==dQ(3,3);
    dQs>=0;
    Pn=[1/2*(Wn(1)) 1/6*(Wn(2)); 1/6*(Wn(2)) 1/4*(Wn(3))];
    Pn>=0;
    Pn<=P-(1e-10)*eye(2);
    minimize(trace(dQs))
    
    cvx_end
    W=Wn;
    P=Pn;
    Psave=[Psave;P(:)']
    Qsave=[Qsave;dQs(:)']
end  




