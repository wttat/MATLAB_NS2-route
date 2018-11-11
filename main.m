clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% target ns2 setdest format:
% $node_(0) set X_ 0
% $node_(0) set Y_ 50000
% $node_(0) set Z_ 4000
% $ns_ at 0.0 "$node_(0) setdest x y z v" 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Created by WTTAT!!!
% ALl right Reserved!!!
% Since June 1th 2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Initialize 100000*100000*100000 Cube
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = 20000; % dive x direction length
zb = 1000; % dive z height above bottom
zmax = 4000; % total height
l = 100000;

x_orgin=zeros(10,l); % Initialize Orgin x axis matrix
y_orgin=zeros(10,l); % Initialize Orgin y axis matrix
z_orgin=zeros(10,l); % Initialize Orgin z axis matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Dive Movement for node group 2 : from ��n_group1�� to ��n_group1+n_group2��
%  Initialize 100000*100000*4000 Cube
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_group2=10;%Group 2 node number

m = 2000; % interval
tt=500; % speed up
t_group2 = 1:m/tt:l/tt;

v_group2=zeros(n_group2,l/m); % Initialize speed axis matrix

xx_group2=zeros(n_group2,l/m); % Initialize Chosen x axis matrix
yy_group2=zeros(n_group2,l/m); % Initialize Chosen y axis matrix
zz_group2=zeros(n_group2,l/m); % Initialize Chosen z axis matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   x10-x19's trace

for id = 1:n_group2
    
    y_space_group2 = 1000; %the space between each node
    
    x_orgin(id,:) = 1:l;
    %y_orgin(id,:)=l/2+((-1)^(id-1))*(id-1)*y_space_group2; %undone
    y_orgin(id,:) = 45000+id*y_space_group2;
    z_orgin(id,:) = 1:l;
    
    for n=1:xl
        z_orgin(id,x_orgin(id,n)) = zmax-x_orgin(id,n)/(xl/(zmax-zb));
    end
    
    for n= xl:(l-xl)
        z_orgin(id,x_orgin(id,n)) = zb+100*rand(1);
    end
    
    for n =(l-xl):l
        z_orgin(id,x_orgin(id,n)) = x_orgin(id,n)/(xl/(zmax-zb))+zmax-(zmax-zb)*l/xl;
    end
    
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abandoned
% %%%%%   x2's trace
% id = 2;
% z_(id,:)=1:l;
% x_(id,:)=1:l;
% y_(id,:)=46000;
% for n=1:xl
%     z_(id,x_(id,n)) = zmax-x_(id,n)/(xl/(zmax-zb));
% end
% for n= xl:(l-xl)
%     z_(id,x_(id,n)) = zb+100*rand(1);
% end
% for n =(l-xl):l
%     z_(id,x_(id,n)) = x_(id,n)/(xl/(zmax-zb))+zmax-(zmax-zb)*l/xl;
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Speed  Calculation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 for id=1:n_group2
    for n=1:(l/m)
        xx_group2(id,n) = x_orgin(id,t_group2(n)*tt);
        yy_group2(id,n) = y_orgin(id,t_group2(n)*tt);
        zz_group2(id,n) = z_orgin(id,t_group2(n)*tt);
            if n>1
            v_group2(id,n)=sqrt((xx_group2(id,n)-xx_group2(id,n-1))^2+(yy_group2(id,n)-yy_group2(id,n-1))^2+(zz_group2(id,n)-zz_group2(id,n-1))^2);
            v_group2(id,n)=tt*v_group2(id,n)/m;
            else
                v_group2(id,n)=0;
            end

    end
    v_group2(id,1)=v_group2(id,2); % initial speed
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Source node group 1 : from 0 to 1000 ��n_group1��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 n_group1 =n_group2*l/1000 ; %Group 1 node number = Group 2 number * 100000m / 1000m
 
 x_group1 = ones(1,n_group1) ;
 y_group1 = ones(1,n_group1) ;
 z_group1 = 500*ones(1,n_group1) ;
 
 i=1; %for y 10 lines of group2
 ii=0;%for x offset
 
 for count_group1=1:l/1000  : n_group1
         for offset=count_group1 : (count_group1+l/1000-1)
             x_group1(1,offset)= 500+1000*ii;
             y_group1(1,offset) = yy_group2(i,1);
             ii=ii+1;
         end
     i=i+1;
 end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sink node group 3 : from 1001 to 4000 ��n_group3��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 n_group3 = zmax/1000*n_group2*l/1000- n_group1; %Group 3 node number = Group 1 number * 100000m / 1000m*(4000/1000-1)
 
 x_group3 = ones(1,n_group3) ;
 y_group3 = ones(1,n_group3) ;
 z_group3 = ones(1,n_group3) ;

 for z_level = 1 : n_group1 : n_group3 %  z_level = 1 1001 2001     
     z_height = z_level-1+1500; %  z_height = 1500 2500 350
     for offset_z = z_level : z_level+n_group1-1 % 1~1000 1001~2000 2001~3000                    
         i=1; %for y 10 lines of group2                     
         ii=0;%for x offset
         for offset_y=z_level : l/1000 : z_level+n_group1-1 % 1 100 200 .. 1000
             for offset =  offset_y : offset_y+l/1000-1 % 1~100 100~200 .. 900~1000
                 x_group3(1,offset)= 500+1000*ii;
                 y_group3(1,offset) = yy_group2(i,1);
                 z_group3(1,offset) = z_height;
                 ii=ii+1;
             end
             i=i+1;
         end            
    end
 end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output NS-2 Format
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fid = fopen('./ns2.txt', 'wt+');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %  Node Group 1 From 1 to 1000
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
 
 for id=1:n_group1
    
    fprintf(fid,'\n\n\n########################################## \n\n\n');
    
    nodeid_group1 = (id-1)*ones(1,n_group1);  % ns2 nodeid -1 from 0 - 999
  
    N_group1=[nodeid_group1(1,id)];
    fprintf(fid,'set node_(%1.0f) [ $ns_  node %1.0f ] \n',N_group1,N_group1);
    fprintf(fid,'$node_(%1.0f) set sinkStatus_ 1 \n\n',N_group1);
    fprintf(fid,'$node_(%1.0f) set position_update_interval_ $opt(position_update_interval) \n\n',N_group1);
    fprintf(fid,'$god_ new_node $node_(%1.0f) \n',N_group1);
    fprintf(fid,'$node_(%1.0f) random-motion 0 \n',N_group1); %ȡ������ƶ�
    
    % orgin coordinate
    A_group1=[nodeid_group1(1,id) ; x_group1(1,id) ; nodeid_group1(1,id) ; y_group1(1,id) ; nodeid_group1(1,id) ; z_group1(1,id)];
    fprintf(fid,'$node_(%1.0f) set X_ %6.3f \n$node_(%1.0f) set Y_ %6.3f \n$node_(%1.0f) set Z_ %6.3f \n', A_group1);
    
    fprintf(fid,'$node_(%1.0f) set passive 1 \n\n',N_group1);

    fprintf(fid,'\nset rt [$node_(%1.0f) set ragent_] \n',N_group1);
    fprintf(fid,'$rt set control_packet_size  $opt(routing_control_packet_size)  \n\n');
    fprintf(fid,'set a_(%1.0f) [new Agent/UWSink] \n',N_group1);
    fprintf(fid,' $ns_ attach-agent $node_(%1.0f) $a_(%1.0f)\n',N_group1,N_group1);
    fprintf(fid,' $a_(%1.0f) attach-vectorbasedforward $opt(width)\n',N_group1);
    fprintf(fid,' $a_(%1.0f) cmd set-range $opt(range) \n',N_group1);
    fprintf(fid,' $a_(%1.0f) cmd set-target-x -20\n',N_group1);
    fprintf(fid,' $a_(%1.0f) cmd set-target-y -10\n',N_group1);
    fprintf(fid,' $a_(%1.0f) cmd set-target-z -20\n',N_group1);
    fprintf(fid,' $a_(%1.0f) cmd set-filename $opt(datafile)\n',N_group1);
    fprintf(fid,' $a_(%1.0f) cmd set-packetsize $opt(packet_size) ;# # of bytes\n',N_group1);
    
%     plot(v_(id,:));
%     title('Speed');
%     hold on;

    plot3(x_group1(1,:),y_group1(1,:),z_group1(1,:),'.'); %
    xlabel('X');ylabel('Y');zlabel('Z');
    grid on;
    title('Source Node Coordinate');
    hold on;

end
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %  Node Group 3 From 1000 to 4000
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 offset_group3 = n_group1 ;
 
  for id=1:n_group3
    
    fprintf(fid,'\n\n\n########################################## \n\n\n');
    
    nodeid_group3 = (id-1)*ones(1,n_group3)+offset_group3;  % ns2 nodeid -1 from 1000 - 3999
  
    N_group3=[nodeid_group1(1,id)];
    fprintf(fid,'set node_(%1.0f) [ $ns_  node %1.0f ] \n',N_group3,N_group3);
    fprintf(fid,'$node_(%1.0f) set sinkStatus_ 1 \n\n',N_group3);
    fprintf(fid,'$node_(%1.0f) set position_update_interval_ $opt(position_update_interval) \n\n',N_group3);
    fprintf(fid,'$god_ new_node $node_(%1.0f) \n',N_group3);
    fprintf(fid,'$node_(%1.0f) random-motion 0 \n',N_group3); %ȡ������ƶ�
    
    % orgin coordinate
    A_group3=[nodeid_group3(1,id) ; x_group3(1,id) ; nodeid_group3(1,id) ; y_group3(1,id) ; nodeid_group3(1,id) ; z_group3(1,id)];
    fprintf(fid,'$node_(%1.0f) set X_ %6.3f \n$node_(%1.0f) set Y_ %6.3f \n$node_(%1.0f) set Z_ %6.3f \n', A_group3);
    
    fprintf(fid,'$node_(%1.0f) set passive 1 \n\n',N_group3);

    fprintf(fid,'\nset rt [$node_(%1.0f) set ragent_] \n',N_group3);
    fprintf(fid,'$rt set control_packet_size  $opt(routing_control_packet_size)  \n\n');
    fprintf(fid,'set a_(%1.0f) [new Agent/UWSink] \n',N_group3);
    fprintf(fid,' $ns_ attach-agent $node_(%1.0f) $a_(%1.0f)\n',N_group3,N_group3);
    fprintf(fid,' $a_(%1.0f) attach-vectorbasedforward $opt(width)\n',N_group3);
    fprintf(fid,' $a_(%1.0f) cmd set-range $opt(range) \n',N_group3);
    fprintf(fid,' $a_(%1.0f) cmd set-target-x -20\n',N_group3);
    fprintf(fid,' $a_(%1.0f) cmd set-target-y -10\n',N_group3);
    fprintf(fid,' $a_(%1.0f) cmd set-target-z -20\n',N_group3);
    fprintf(fid,' $a_(%1.0f) cmd set-filename $opt(datafile)\n',N_group3);
    fprintf(fid,' $a_(%1.0f) cmd set-packetsize $opt(packet_size) ;# # of bytes\n',N_group3);
    
%     plot(v_(id,:));
%     title('Speed');
%     hold on;

    plot3(x_group3(1,:),y_group3(1,:),z_group3(1,:),'.'); %
    xlabel('X');ylabel('Y');zlabel('Z');
    grid on;
    title('Source Node Coordinate');
    hold on;

end
 
 
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %  Node Group 2 From 4000 to 4019
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 offset_group2 = n_group1+n_group3;
 
for id=1:n_group2
    
    fprintf(fid,'\n\n\n########################################## \n\n\n');
    
    nodeid_group2 = (id-1)*ones(n_group2,l/m);  % ns2 nodeid -1
  
    N_group2=[nodeid_group2(id,1)+offset_group2];
    fprintf(fid,'set node_(%1.0f) [ $ns_  node %1.0f ] \n',N_group2,N_group2);
    fprintf(fid,'$node_(%1.0f) set sinkStatus_ 1 \n\n',N_group2);
    fprintf(fid,'$node_(%1.0f) set position_update_interval_ $opt(position_update_interval) \n\n',N_group2);
    fprintf(fid,'$god_ new_node $node_(%1.0f) \n',N_group2);
    fprintf(fid,'$node_(%1.0f) random-motion 0 \n',N_group2); %ȡ������ƶ�
    
    % orgin coordinate
    A_group2=[nodeid_group2(id,1)+offset_group2;xx_group2(id,1);nodeid_group2(id,1)+offset_group2;yy_group2(id,1);nodeid_group2(id,1)+offset_group2;zz_group2(id,1)];
    fprintf(fid,'$node_(%1.0f) set X_ %6.3f \n$node_(%1.0f) set Y_ %6.3f \n$node_(%1.0f) set Z_ %6.3f \n', A_group2);
    
    fprintf(fid,'$node_(%1.0f) set passive 1 \n\n',N_group2);
    
    % time & 3dcoordinate & speed
    B_group2=[t_group2;nodeid_group2(id,:)+offset_group2 ; xx_group2(id,:) ; yy_group2(id,:) ; zz_group2(id,:) ; v_group2(id,:)];
    fprintf(fid,'$ns_ at %6.3f "$node_(%1.0f) setdest3d %6.3f %6.3f %6.6f %6.6f "\n', B_group2);

    fprintf(fid,'\nset rt [$node_(%1.0f) set ragent_] \n',N_group2);
    fprintf(fid,'$rt set control_packet_size  $opt(routing_control_packet_size)  \n\n');
    fprintf(fid,'set a_(%1.0f) [new Agent/UWSink] \n',N_group2);
    fprintf(fid,' $ns_ attach-agent $node_(%1.0f) $a_(%1.0f)\n',N_group2,N_group2);
    fprintf(fid,' $a_(%1.0f) attach-vectorbasedforward $opt(width)\n',N_group2);
    fprintf(fid,' $a_(%1.0f) cmd set-range $opt(range) \n',N_group2);
    fprintf(fid,' $a_(%1.0f) cmd set-target-x -20\n',N_group2);
    fprintf(fid,' $a_(%1.0f) cmd set-target-y -10\n',N_group2);
    fprintf(fid,' $a_(%1.0f) cmd set-target-z -20\n',N_group2);
    fprintf(fid,' $a_(%1.0f) cmd set-filename $opt(datafile)\n',N_group2);
    fprintf(fid,' $a_(%1.0f) cmd set-packetsize $opt(packet_size) ;# # of bytes\n',N_group2);
    
%     plot(v_(id,:));
%     title('Speed');
%     hold on;

    plot3(xx_group2(id,:),yy_group2(id,:),zz_group2(id,:),'v'); %
    xlabel('X');ylabel('Y');zlabel('Z');
    grid on;
    title('Movements');
    hold on;

end






fclose(fid);

% %xialuoxuanyundong
% z = 0:pi/50:10*pi;
% x = sin(z);
% y = cos(z);
