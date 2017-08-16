<?php
	// get config info
	$pwFile = file_get_contents('../etc/passwords.pw');
	$rows = explode ("\n", $pwFile);
	
	$pw;
	
	foreach($rows as $row => $data)
	{
	        $row_data = explode(' => ', $data);
	        $pw[$row_data[0]] = $row_data[1];
	
	}

?>
<!DOCTYPE html >
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>Using MySQL and PHP with Google Maps</title>
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 90%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 90%;
        width: 90%;
        margin: 0;
        padding: 0;
      }
    </style>
    <script src="//code.angularjs.org/snapshot/angular.min.js"></script>
  </head>

  <body>
    <h3>Potential Friendlies</h3>
    <div id="map"></div>

    <script>
      var customImage = {
        R: 'images/elephant-16.png',
        D: 'images/donkey-24.png',
        mixed: 'images/mixed.png'
      };

        function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
          //center: new google.maps.LatLng(-33.863276, 151.207977),
          center: new google.maps.LatLng(39.798239, -75.833707),
          zoom: 12
        });
        var infoWindow = new google.maps.InfoWindow;

          // Change this depending on the name of your PHP or XML file
          //downloadUrl('https://storage.googleapis.com/mapsdevsite/json/mapmarkers2.xml', function(data) {
          downloadUrl("addr.f.xml?<?php echo $_SERVER['QUERY_STRING']; ?>", function(data) {
            var xml = data.responseXML;
            var markers = xml.documentElement.getElementsByTagName('marker');
            Array.prototype.forEach.call(markers, function(markerElem) {
              var name = markerElem.getAttribute('name');
              var address = markerElem.getAttribute('address');
              var party = markerElem.getAttribute('party');
              //var point = new google.maps.LatLng(39.738742, -75.797975);
              var point = new google.maps.LatLng(
                  parseFloat(markerElem.getAttribute('lat')),
                  parseFloat(markerElem.getAttribute('lng')));

              var infowincontent = document.createElement('div');
              var strong = document.createElement('strong');
              strong.textContent = name
              infowincontent.appendChild(strong);
              infowincontent.appendChild(document.createElement('br'));

              var text = document.createElement('text');
              text.textContent = address
              infowincontent.appendChild(text);
              //var image = customImage[party] || {};
              var image = customImage[party] || 'http://unstable.vukuu.com:8080/voter/question-mark-8-24.gif';
              var marker = new google.maps.Marker({
                map: map,
                position: point,
                icon: image
              });
              marker.addListener('click', function() {
                infoWindow.setContent(infowincontent);
                infoWindow.open(map, marker);
              });
            });
          });
        }



      function downloadUrl(url, callback) {
        var request = window.ActiveXObject ?
            new ActiveXObject('Microsoft.XMLHTTP') :
            new XMLHttpRequest;

        request.onreadystatechange = function() {
          if (request.readyState == 4) {
            request.onreadystatechange = doNothing;
            callback(request, request.status);
          }
        };

        request.open('GET', url, true);
        request.send(null);
      }

      function doNothing() {}
    </script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=<?php print $pw[mapsAPIweb]; ?>&callback=initMap">
    </script>
  </body>
</html>
