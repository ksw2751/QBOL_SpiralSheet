N = 12*8;
r = 2^(1/12);

f_i = 33; % initial freq 
note_i = -1; % initial note
f = f_i*r.^(-32+note_i:N-2);
theta = pi/2 - 2*pi*log2(f/f_i);
A = 1./f;

P = 2;

f_P = f_i*r.^(-32+note_i:1/P:N-2);
theta_P = pi/2 - 2*pi*log2(f_P/f_i);
A_P = 1./f_P;
l = polarplot(theta, A,'o');
R = A(1);
rlim([0 R])
set(gca,'thetaticklabel',{'C' 'B' 'A#' 'A' 'G#' 'G' 'F#' 'F' 'E' 'D#' 'D' 'C#' })
set(gca,'rticklabel',[])
hold on

p = polarplot(0,0,'o', Color='none');
p.Color = 'red';

plot_note = [];

off_note_exp = false;

mididevinfo
device = mididevice(1);

while 1
    msgArray = midireceive(device);

    on_no = msgArray([msgArray.Type] == 1);
    on_note = [on_no.Note];
    
    if off_note_exp
        off_note = [msgArray([msgArray.Type] == 2).Note];
    else
        off_note = [on_no([on_no.Velocity] == 0).Note];
    end
    
    plot_note = horzcat(plot_note, on_note);
    
    p.XData = theta(plot_note - 35);
    p.YData = A(plot_note - 35);
    
    for i = 1:length(off_note)
        off_index = (plot_note == off_note(i));
        plot_note(off_index) = [];
    end

    drawnow;
end