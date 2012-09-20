var gData;
var markers = []
var map;

function initialize() {
	var myLatlng = new google.maps.LatLng(-25.363882,131.044922);
	var mapOptions = {
	  zoom: 4,
	  center: myLatlng,
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);



	
}

function checkJSON()
{
	for (var i = 0; i < markers.length; i++)
	{
		markers[i].setMap(null)
		markers.pop()
	}

	$.getJSON('/admin/last30Scans.json', function(data)
		{
			gData = data;
			var i = 0
		
			for (i = 0; i < data.length; i++)
			{
				var newMarkerlatLong = new google.maps.LatLng(data[i].latitude,data[i].longitude)
				var marker = new google.maps.Marker({
				    position: newMarkerlatLong,
				    map: map,
				    title: data[i].name
				});
				markers.push(marker)
			}

		});
}

$(document).ready(function() {
	initialize();
	var timer = setInterval('checkJSON()',3000)

});

