var placeSearch,
    autocomplete;

function startAutoComplete() {
  // Create the autocomplete object, restricting the search
  // to geographical location types.
  autocomplete = new google.maps.places.Autocomplete(
      (document.getElementById('start')),
      { types: ['geocode', 'establishment'] },
      { location: [41.8819,87.6278] },
      { components: ['us'] });

   autocomplete = new google.maps.places.Autocomplete(
      (document.getElementById('destination')),
      { types: ['geocode', 'establishment'] },
      { location: [41.8819,87.6278] },
      { components: ['us'] });
  // When the user selects an address from the dropdown,
  // populate the address fields in the form.
}
