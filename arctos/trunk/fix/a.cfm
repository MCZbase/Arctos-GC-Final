<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">

<head>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
<title>Google Maps</title>

<style>
body {font: normal 12px verdana;}
.link {color:blue;text-decoration:underline;cursor:pointer};
</style>
<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;sensor=false&amp;key=#application.gmap_api_key#" type="text/javascript"></script>
<script src="dragzoom_mod.js" language="javascript" type="text/javascript"></script>

</script>
</head>
<div id="map_canvas" style="width: 100%; height: 400px;"></div>
<script language="javascript" type="text/javascript">
	jQuery(document).ready(function() {
	  	initializeMap();
	});
	jQuery(document.body).unload(function() {
		GUnload();
	});
	function initializeMap() {
		if (GBrowserIsCompatible()) {
			var map = new GMap2(document.getElementById("map_canvas"));
			var center = new GLatLng(55, -135);
			map.setCenter(center, 3);
			map.addControl(new GLargeMapControl(),new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(1,1)));
			map.addMapType(G_PHYSICAL_MAP);
			map.addControl(new GScaleControl(),new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(1,50)));
			map.addControl(new GMapTypeControl(),new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(1,1)));
			
			map.enableGoogleBar();
			var boxStyleOpts = {
				opacity:.0,
				border:"2px solid green"
			}
			var otherOpts = {
				overlayRemoveTime:99999999999999,  
				buttonHTML:"Turn on Select",
				buttonZoomingHTML:"Turn off Select",
				buttonStartingStyle:{left:'150px', border: '1px solid black', padding: '4px',fontSize:'small',color:'blue',fontWeight:'bold'},
				buttonZoomingStyle:{background: 'lightblue'},
				backButtonEnabled : true,
				backButtonHTML : 'Go Back',
				minDragSize:3
			};
			var callbacks = {
				dragend:function(nw,ne,se,sw,nwpx,nepx,sepx,swpx){
					jQuery('#nwLat').val(nw.lat());
					jQuery('#nwlong').val(nw.lng());
					jQuery('#selat').val(se.lat());
					jQuery('#selong').val(se.lng());
					jQuery('#selectedCoords').val('Selected Area: NW=' + nw + '; SE=' + se);
				}
			};			
			map.addControl(new DragZoomControl(boxStyleOpts, otherOpts, callbacks),new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(325,4)));
		}
	}
</script>
<body>

</body>
</html>



