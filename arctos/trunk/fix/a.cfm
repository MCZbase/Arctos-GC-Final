<cfinclude template="/includes/_header.cfm">



	<script src="http://maps.googleapis.com/maps/api/js?client=gme-museumofvertebrate1&sensor=false&libraries=geometry" type="text/javascript"></script>

	    <script type="text/javascript">
	      function initialize() {
	        var mapOptions = {
	          center: new google.maps.LatLng(-34.397, 150.644),
	          zoom: 8,
	          mapTypeId: google.maps.MapTypeId.ROADMAP
	        };
	        var map = new google.maps.Map(document.getElementById("map-canvas"),
	            mapOptions);
	      }
	      google.maps.event.addDomListener(window, 'load', initialize);
	    </script>

	  <body>
	    <div id="map-canvas"/>
	  </body>


	<cfinclude template="/includes/_footer.cfm">

