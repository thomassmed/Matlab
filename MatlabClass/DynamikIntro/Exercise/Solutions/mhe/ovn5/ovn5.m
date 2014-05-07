%%

fs = 0.5;        % Signalens frekvens
t = 0:0.01:10;  % Tidsvektor
ts = 0.2;        % Filtrets tidskonstant
ws = 2 .*pi .*fs;


%%

%Fånga aktuellt fönster
h = findplot(0,'Tag','OVN5-1');
hold off
clf

u = sin(ws .* t);
plot(t,u);
hold all

G = 1 ./ (1 + ts .* 1j .* ws);

plot(t,abs(G) .* sin(ws .* t + angle(G)))


sys = tf(1,[ts 1]);
y = lsim(sys,u,t);

plot(t,y)

grid


%%

h = findplot(0,'Tag','OVN5-2');
clf
hold off
U = fft(u);
Y = fft(y);

[~,idxU] = max(abs(U));
[~,idxY] = max(abs(Y));

H = Y(idxY)/U(idxU)

compass(U(idxU))
hold on
compass(U(idxU).*G)
compass(Y(idxY))

ax = findall(gca,'Type','line','LineStyle','-','Color',[0 0 1]);
co = get(gca,'ColorOrder');
for i = 1:length(ax)
    set(ax(i),'Color',co(i,:))
    ax(i)
end

%%

h = findplot(0,'Tag','OVN5-3');
hold off
clf

N2 = floor(length(t)./2)+1;

f = linspace(0,50,N2);
w = 2.*pi.*f;

u1 = chirp(t,0.01,10,20);
y1 = lsim(sys,u1,t);

U1 = fft(u1);
Y1 = fft(y1);

loglog(f,abs(Y1(1:N2)./U1(1:N2)'));
hold all
[magsys,~] = bode(sys,w);
loglog(f,shiftdim(magsys));
loglog(f,abs(1./(1 + ts.*1j.*w)));
loglog(f,(w <= 1./ts) + (1 ./ (w .* ts) .* (w > 1./ts)));
ax = axis();
axis([ax(1) ax(2) ax(3) ax(4) .* 1.5]);
grid
