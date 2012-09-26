var leaderboardData = null
var scansData = null

/*
* This function is called every couple of seconds and hits the leaderboard
* JSON feed. It will then update the page with the results.
*/
function hitStaticLeaderboard()
{
	$.getJSON('/admin/teams/staticLeaderboard.json', function(data)
	{

		//console.log(data);
		leaderboardData = data
		var i = 0
		$("#liveLeaderboardFrontScreen").empty();
		var headings = "<tr><th>Placement</th><th>Team Name</th><th>Score</th><tr>"
		$("#liveLeaderboardFrontScreen").append(headings)
		for (i = 0; i < data.length; i++)
		{
			var lineToAppend = "<tr><td class='placement'>"+parseInt(i+1)+"</td><td class='teamName'>"+data[i].name+"</td><td class='points'>"+parseInt(data[i].score)+"</td></tr>"

			$("#liveLeaderboardFrontScreen").append(lineToAppend);
		}

	});
}

//Get the last 10 scans for this game.
function hitScansLeaderboard()
{
	
	$.getJSON('/admin/scans/lastNScansForThisGame/10.json', function(data)
	{
		//console.log(data);
		scansData = data
		var i = 0
		$("#recentScans").empty();
		var headings = "<tr><th>Tag</th><th>Team Name</th><th>Points</th><tr>"
		$("#recentScans").append(headings)
		for (i = 0; i < data.length; i++)
		{
			var lineToAppend = "<tr><td class='tag_name'>"+data[i].tag_name+"</td><td class='team_name'>"+data[i].team_name+"</td><td class='points_scans'>"+parseInt(data[i].points)+"</td></tr>"

			$("#recentScans").append(lineToAppend);
		}

	});

}

// When the page loads, start a timer.
$(document).ready(function() {
	hitStaticLeaderboard();
	hitScansLeaderboard();
	var timer = setInterval("hitStaticLeaderboard()", 10000)
	var scanTimer = setInterval("hitScansLeaderboard()", 10000)


});

