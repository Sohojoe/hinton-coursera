function quiz(w0, w1, w2)

figure(1)
hold all
x = linspace(0,100);
% y = ((w1*x)+w0)+(x*w2^2);
y = w0+w1*x+(w2*(x.^2));
plot(x,y);
%     plot(x,w0+w1*x+w2*(x^2))    
% for x=-100:100
%     y = w0+w1*x;
%     plot(x,y)    
% end
legend(sprintf('w0={0}, w1={1}, w2={2}', w0,w1,w2));

