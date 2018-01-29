%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%References%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%{
https://www.mathworks.com/matlabcentral/answers/9641-how-do-i-round-to-the-nearest-arbitrary-enumerated-value-in-matlab
%}

function [img] = myNMS(Im, Io)
  %filters = [
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %Io = im2double(Io);
  %%round Io to nearest 45 degrees%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  E = [0 0 0 ; 1 0 1; 0 0 0];
  N = E';
  NE =[0 0 1; 0 0 0; 1 0 0];
  NW = flip(NE);
  filters = [E ; NE ; N ; NW]
  %filters(3*i+(1:3),:)
  Ior = wrapToPi(Io);
  Ior(find(Ior < 0)) = pi + Ior(find(Ior < 0));
  Ior = round(Ior*4/pi);
  Ior(find(Ior == 4)) = 0;
  img = Ior;
end
    
                
        
        
