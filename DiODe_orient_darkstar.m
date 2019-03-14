function dir_angles = DiODe_orient_darkstar(roll,pitch,yaw,dirlevel)
vizz = 0;
%% create vectors symbolizing the gaps between directional contacts at 60, 180 and 300 degrees
% and transform them to match lead trajectory and directional level
dirlevel = dirlevel(1:3);

ven = [0 0.65 -0.75 ]';
dor = [0 0.65 0.75 ]';
[M,~,~,~] = DiODe_orient_rollpitchyaw(roll-((2*pi)/6),pitch,yaw);
ven60 = M * ven;
dor60 = M * dor;
[M,~,~,~] = DiODe_orient_rollpitchyaw(roll-(3*(2*pi)/6),pitch,yaw);
ven180 = M * ven;
dor180 = M * dor;
[M,~,~,~] = DiODe_orient_rollpitchyaw(roll-(5*(2*pi)/6),pitch,yaw);
ven300 = M * ven;
dor300 = M * dor;

%% calculate intersecting points between vec60/180/300 and the z-plane through the dir-level artifact
vec60 = (dor60-ven60) / norm(dor60-ven60);              % unitvector from ven60 to dor60
dir_ven60 = dirlevel + ven60;                          % ventral point at 60� from the directional level
dir_dor60 = dirlevel + dor60;                          % dorsal point at 60� from the directional level
dir_x60 = (dirlevel(3) - dir_ven60(3)) / vec60(3);      % factor x of how many unitvectors dir_ven60 is distanced from the dirlevel in the z-dimension
dir_60 = dir_ven60 + (dir_x60 .* vec60);                % intersecting point of the line from ven60 to dor60 withe the dirlevel plane in the z-dimension

vec180 = (dor180-ven180) / norm(dor180-ven180);
dir_ven180 = dirlevel + ven180;
dir_dor180 = dirlevel + dor180;
dir_x180 = (dirlevel(3) - dir_ven180(3)) / vec180(3);
dir_180 = dir_ven180 + (dir_x180 .* vec180);

vec300 = (dor300-ven300) / norm(dor300-ven300);
dir_ven300 = dirlevel + ven300;
dir_dor300 = dirlevel + dor300;
dir_x300 = (dirlevel(3) - dir_ven300(3)) / vec300(3);
dir_300 = dir_ven300 + (dir_x300 .* vec300);

%% create vectors corresponding to the dark lines of the artiface
dir_vec1 = (dir_60 - dir_180) / norm(dir_60 - dir_180);
dir_vec2 = (dir_60 - dir_300)  / norm(dir_60 - dir_300);
dir_vec3 = (dir_180 - dir_300)  / norm(dir_180 - dir_300);

%% calculate the angles of the dark lines with respect to the y-axis
dir_angles(1) = atan2(norm(cross(dir_vec1,[0 1 0])),dot(dir_vec1,[0 1 0]));
if dir_vec1(1) < 0
    dir_angles(1) = -dir_angles(1);
end    
dir_angles(2) = atan2(norm(cross(dir_vec2,[0 1 0])),dot(dir_vec2,[0 1 0]));
if dir_vec2(1) < 0
    dir_angles(2) = -dir_angles(2);
end
dir_angles(3) = atan2(norm(cross(dir_vec3,[0 1 0])),dot(dir_vec3,[0 1 0]));
if dir_vec3(1) < 0
    dir_angles(3) = -dir_angles(3);
end

dir_angles = [dir_angles (dir_angles + pi)];
dir_angles(find(dir_angles>2*pi)) = dir_angles(find(dir_angles>2*pi)) - (2* pi);
dir_angles(find(dir_angles<0)) = dir_angles(find(dir_angles<0)) + (2* pi);
dir_angles = (2 *pi) -dir_angles;
dir_angles = sort(dir_angles);



%% vizz

if vizz == 1
    figure
    temp = [dir_ven60'; dir_ven180'; dir_ven300'; dir_dor60'; dir_dor180'; dir_dor300'];
    scatter3(temp(:,1),temp(:,2),temp(:,3),'b')
    hold on
    plot3(temp([1 2 3 1],1),temp([1 2 3 1],2),temp([1 2 3 1],3),'b')
    plot3(temp([4 5 6 4],1),temp([4 5 6 4],2),temp([4 5 6 4],3),'b')
    clear temp
    
    axis equal
    temp = [dir_60'; dir_180'; dir_300'];
    scatter3(temp(:,1),temp(:,2),temp(:,3),'r')
    clear temp
    temp = [dir_60'; (dir_60 - dir_vec1)'; (dir_60 - dir_vec2)'; (dir_180 - dir_vec3)'];
    plot3(temp([1 2 3 1],1),temp([1 2 3 1],2),temp([1 2 3 1],3),'r')
    clear temp
    scatter3(dirlevel(1),dirlevel(2),dirlevel(3),'g');
    xlabel('x')
    ylabel('y')
    zlabel('z')
end
end