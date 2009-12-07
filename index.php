<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Technology House Map</title>

		<script src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js" type="text/javascript"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/scriptaculous/1.8.3/scriptaculous.js" type="text/javascript"></script>
		<script src="all.js.php" type="text/javascript"></script>

		<link href="reset.css" rel="stylesheet" type="text/css" />
		<link href="fonts.css" rel="stylesheet" type="text/css" />
		<link href="general.css" rel="stylesheet" type="text/css" />
		<link href="rooms.css.php" rel="stylesheet" type="text/css" />
		<link href="sprites.css.php" rel="stylesheet" type="text/css" />
		<link href="widgets.css" rel="stylesheet" type="text/css" />
    </head>

    <body>

		<div id="all">

			<div id="middle" style="display: none">

				<?php
					require 'rooms.html.php';
				?>

			</div>

			<div id="pane">
				<div class="top">
					<div>
						<div class="content">
							Welcome
						</div>
					</div>
				</div>

				<div class="middle">
					<div>
						<div class="content">
							<h1>Technology House</h1>

							<img class="photo" alt="" src="photos/welcome.png" />

							<div class="description">
								Welcome! You are a freshman at BROWN UNIVERSITY, and you are a new member of TECH HOUSE. You find yourself standing on the second floor of the  HOUSE, awed by the gleaming splendor. Promises of technology beyond your wildest dreams beckoned you to join the HOUSE, and now here you are. In September, you will move in to your own room, but for now you are visiting TECH HOUSE to explore your future home.<br />
								You notice that some PEOPLE are in their ROOMS. Maybe you should visit them.
							</div>
						</div>
					</div>
				</div>

				<div class="bottom">
					<div>
						<div class="content">
							<div id="scrollback"></div>
							<input type="text" id="prompt" />
						</div>
					</div>
				</div>
			</div>

			<div id="floorchooser"></div>

			<div id="noticer">
				<div class="inner">
					<div class="content">
						
					</div>
				</div>
				<div class="exclamation"></div>
			</div>

			<div id="bottompane"></div>

			<div id="notifier">
				<div class="inner">
					<!--<object data="" type="image/svg+xml"></object>-->
					<h1></h1>
					<span class="subtext1"></span>
					<span class="subtext2"></span>
				</div>
			</div>

			<div id="money"></div>

		</div>

    </body>
</html>