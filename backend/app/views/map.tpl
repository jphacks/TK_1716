<!DOCTYPE html>
<html>
  <head>
    <title>あのね、</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script>
    var map;
    var currentInfoWindow = null;
    var markers = [];
    var data = receiveData();
    var init_center = {lat: Number(data.lat), lng: Number(data.lng)};

    var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var labelIndex = 0;

    var directionsService;
    var directionsDisplay;

      // mapの初期状態
      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 14,
          center: init_center
        });
        directionsService = new google.maps.DirectionsService;
        directionsDisplay = new google.maps.DirectionsRenderer;
        directionsDisplay.setOptions({
          suppressMarkers: true,
          preserveViewport: true
        });

        // 現在地にpin
        addMarker(init_center, "現在地", true);

        // 授乳室/オムツ台にpin
        {% for spot in near_spot%}
          add_spot = {lat: {{spot[2]}}, lng: {{spot[1]}}};
          addMarker(add_spot, "{{spot[0]}}", false);
        {% endfor %}
      }

      function receiveData(){
        var arg = new Object;
        arg["lat"] = {{lat}};
        arg["lng"] = {{lng}};
        return arg;
      }

      // pinの追加
      function addMarker(location, label, is_current_position){
      // もし現在地ならデフォルトのpin
      if (is_current_position) {
        var marker = new google.maps.Marker({
            position: location,
            map: map,
            clickable: true,
          });
      }
      // それ以外なら種類に対応したpin
      else {
          var marker = new google.maps.Marker({
            position: location,
            map: map,
            {% if ptype=="milk"%}
            icon: "{{url('img_file', filename="milk.png")}}",
            {% else %}
            icon: "{{url('img_file', filename="omutsu.png")}}",
            {% endif %}
             clickable: true,
          });
          }

          // 吹き出しの追加
          var infoWindow = new google.maps.InfoWindow({
            content: label
           });

          google.maps.event.addListener(marker, 'click', function()
          {
           // すでに開かれてるinfowindowを閉じる
           if (currentInfoWindow) {
				currentInfoWindow.close();
			}
            infoWindow.open(map, marker);
            currentInfoWindow = infoWindow;
            ShowDirection(marker.position)
          });
          markers.push(marker);
      }

      function getPosition(){
        alert("Yes");
      }

      // 経路表示
      function ShowDirection(location){
        directionsDisplay.setMap(map);
        directionsService.route({
          origin: init_center,
          destination: location,
          travelMode: 'WALKING'
        },function(response, status) {
          if (status === 'OK') {
            directionsDisplay.setDirections(response);
          } else {
            window.alert('Directions request failed due to ' + status);
          }
        });
      }

    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDj8oKeKcUKdb9PGF5EZgF6-z30koUGkmQ&callback=initMap&language=ja&region=JP"
    async defer>
    </script>
  </body>
</html>
