function [angle, intensity,vectornew] = DiODe_orient_intensityprofile(artifact,center,pixdim,radius)
vector = [0 1] .* (radius / pixdim(1));
vectornew = [];

for k = 1:360
    theta = (2*pi/360) * (k-1);    
    rotmat = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    vectornew =vertcat(vectornew,(vector * rotmat) + center);
    angle(k) = theta;
    intensity(k) = DiODe_orient_interpimage(artifact,[vectornew(k,1) vectornew(k,2)]);    
end


end