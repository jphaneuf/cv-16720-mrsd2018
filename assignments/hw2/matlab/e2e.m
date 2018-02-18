filters = createFilterBank();
img = imread('coins.png');
img = imread('../data/airport/sun_aerinlrdodkqnypz.jpg')
somanyimgs = extractFilterResponses(img , filters);
