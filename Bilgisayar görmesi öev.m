%Kameray� a�mam� sa�lar asl�nda kamera bak�m�ndan bir s�r� �zellik sunuyor
%fakat benim kulland���m s�r�m 2013 oldu�u MJPG kulland�m 176x144 olmas�n�n
%sebebi ise 640x480 a�t���mda bilgisiyar�n kald�rmamas�yd�
vid = videoinput('winvideo', 1, 'MJPG_176x144');
% Kameran�n �nizlemesini a�ar
preview(vid);
% G�r�nt� i�leme s�resi (saniye)
processing_time = 30;
% tic kullanmam�n sebebi ticin anl�k zamana kar�� bir say�c� ba�latmas�d�r
start_time = tic;
% Sonsuz bir d�ng�de kamera g�r�nt�s�n� i�le
while toc(start_time) < processing_time
    img = getsnapshot(vid);
    % G�r�nt�y� HSV renk uzay�na d�n��t�rd�m
    img_hsv = rgb2hsv(img);
    % Daha fazla renk aral��� ekleyebilirsiniz
    %HSV renk uzay�na g�re blue_rangei buldum
   range = [0.6, 1, 0.4, 0.8]; 
    
    % Renk maskelemesini uygula
    mask = (img_hsv(:,:,1) >= range(1)) & (img_hsv(:,:,1) <= range(2)) & (img_hsv(:,:,2) >= range(3)) & (img_hsv(:,:,2) <= range(4));
   
    % Renk b�lgelerini g�r�nt�de i�aretle
    color_objects = img;
    color_objects(repmat(~mask, [1 1 3])) = 0; %Mask de�i�keninde 0 a denk gelen de�i�kenleri siyah renge d�n��t�r�r.
    %repmat ise maskeyi g�r�nt�ye uyacak �ekilde uyarlanmas�d�r.
    % Bulunan mavi b�lgelerin merkezini hesapla
     stats = regionprops(mask, 'Centroid');
    if ~isempty(stats) % stats de�i�keninin bo� olup olmad���n� kontrol eder. yani bir nevi maskten sonu� geliyor mu diye kontrol eder
        
        %  Nesnelerin merkezini hesapla
        centroids = cat(1, stats.Centroid); % cat (concatenate) dizi veya matrislerin birle�tirilmesi i�in kullan�l�r
        
        % En b�y�k merkezi bul.(~ kullan�lmas�n�n amac� bir �ok ��kt� vermekte fakat en b�y�k merkezi bulursam tek ��kt� vermektedir.)
        [~, idx] = max(centroids(:, 2)); % Y koordinat�na g�re en b�y�k merkezi bul 
        max_centroid = round(centroids(idx, :));
        
        % Merkezi i�aretleyen metni ekle
        x = max_centroid(1);
        y = max_centroid(2)-10;
        text_str = 'Mavi';
        color_objects = insertText(color_objects, [x, y], text_str, 'FontSize', 24, 'BoxColor', 'blue', 'TextColor', 'white');
    end
    
    % ��lenmi� g�r�nt�y� g�ster
    imshow(color_objects);
    
end