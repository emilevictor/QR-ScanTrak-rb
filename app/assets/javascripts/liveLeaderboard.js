var gData = null

/*
* This function is called every couple of seconds and hits the leaderboard
* JSON feed. It will then update the page with the results.
*/
function hitStaticLeaderboard()
{
	$.getJSON('staticLeaderboard.json', function(data)
	{

		//console.log(data);
		gData = data
		var i = 0
		$("#liveLeaderboard").empty();
		var headings = "<tr><th>Placement</th><th>Team ID</th><th>Team Name</th><th>Score</th><tr>"
		$("#liveLeaderboard").append(headings)
		for (i = 0; i < data.length; i++)
		{
			var lineToAppend = "<tr><td class='placement'>"+parseInt(i+1)+"</td><td class='teamID'>"+parseInt(data[i].id)+"</td><td class='teamName'>"+data[i].name+"</td><td class='points'>"+parseInt(data[i].score)+"</td></tr>"

			$("#liveLeaderboard").append(lineToAppend);
		}

	});
}

// When the page loads, start a timer.
$(document).ready(function() {
	hitStaticLeaderboard();
	var timer = setInterval("hitStaticLeaderboard()", 2000)

});

