$(function() {
  function BrandAddressAutocomplete() {
    var text_field = document.getElementById('brand_address');
    var autocomplete = new google.maps.places.Autocomplete(text_field, { types: ['geocode'] });
    _googleMapsListener();

    function _googleMapsListener() {
      google.maps.event.addDomListener(text_field, 'keydown', function(e) {
        if (e.keyCode == 13) { e.preventDefault(); }
      });
    }
  }

  new BrandAddressAutocomplete();
});
