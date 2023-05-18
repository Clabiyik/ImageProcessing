%Kamerayý açmamý saðlar aslýnda kamera bakýmýndan bir sürü özellik sunuyor
%fakat benim kullandýðým sürüm 2013 olduðu MJPG kullandým 176x144 olmasýnýn
%sebebi ise 640x480 açtýðýmda bilgisiyarýn kaldýrmamasýydý
vid = videoinput('winvideo', 1, 'MJPG_176x144');
% Kameranýn önizlemesini açar
preview(vid);
% Görüntü iþleme süresi (saniye)
processing_time = 30;
% tic kullanmamýn sebebi ticin anlýk zamana karþý bir sayýcý baþlatmasýdýr
start_time = tic;
% Sonsuz bir döngüde kamera görüntüsünü iþle
while toc(start_time) < processing_time
    img = getsnapshot(vid);
    % Görüntüyü HSV renk uzayýna dönüþtürdüm
    img_hsv = rgb2hsv(img);
    % Daha fazla renk aralýðý ekleyebilirsiniz
    %HSV renk uzayýna göre blue_rangei buldum
   range = [0.6, 1, 0.4, 0.8]; 
    
    % Renk maskelemesini uygula
    mask = (img_hsv(:,:,1) >= range(1)) & (img_hsv(:,:,1) <= range(2)) & (img_hsv(:,:,2) >= range(3)) & (img_hsv(:,:,2) <= range(4));
   
    % Renk bölgelerini görüntüde iþaretle
    color_objects = img;
    color_objects(repmat(~mask, [1 1 3])) = 0; %Mask deðiþkeninde 0 a denk gelen deðiþkenleri siyah renge dönüþtürür.
    %repmat ise maskeyi görüntüye uyacak þekilde uyarlanmasýdýr.
    % Bulunan mavi bölgelerin merkezini hesapla
     stats = regionprops(mask, 'Centroid');
    if ~isempty(stats) % stats deðiþkeninin boþ olup olmadýðýný kontrol eder. yani bir nevi maskten sonuç geliyor mu diye kontrol eder
        
        %  Nesnelerin merkezini hesapla
        centroids = cat(1, stats.Centroid); % cat (concatenate) dizi veya matrislerin birleþtirilmesi için kullanýlýr
        
        % En büyük merkezi bul.(~ kullanýlmasýnýn amacý bir çok çýktý vermekte fakat en büyük merkezi bulursam tek çýktý vermektedir.)
        [~, idx] = max(centroids(:, 2)); % Y koordinatýna göre en büyük merkezi bul 
        max_centroid = round(centroids(idx, :));
        
        % Merkezi iþaretleyen metni ekle
        x = max_centroid(1);
        y = max_centroid(2)-10;
        text_str = 'Mavi';
        color_objects = insertText(color_objects, [x, y], text_str, 'FontSize', 24, 'BoxColor', 'blue', 'TextColor', 'white');
    end
    
    % Ýþlenmiþ görüntüyü göster
    imshow(color_objects);
    
end