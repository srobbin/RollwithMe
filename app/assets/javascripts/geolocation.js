var geocoder;

function initialize() {
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(40.730885,-73.997383);
  var mapOptions = {
    zoom: 8,
    center: latlng,
    mapTypeId: 'roadmap'
  }
}

function geolocate() {

  // Try HTML5 geolocation
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
                                       position.coords.longitude);
      var coordinates = String([pos.k,pos.B])

      codeLatLng(coordinates);

    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }
}

function codeLatLng(currentCoordinates) {
  var input = currentCoordinates;
  var latlngStr = input.split(',', 2);
  var lat = parseFloat(latlngStr[0]);
  var lng = parseFloat(latlngStr[1]);
  var latlng = new google.maps.LatLng(lat, lng);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[1]) {
          marker = new google.maps.Marker({
        });
        var address = results[0].formatted_address;
            $('#start').val(address);
        } else {
        alert('Your location could not be retrieved.');
      }
    } else {
      alert('Unfortunately there was an error while attempting to find your location. Please try again momentarily.');
    }
  });
}
