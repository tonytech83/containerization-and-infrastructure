<?php
	$tools = array
	(
	array("Chef", "chef-logo.png"),
	array("Docker", "docker-logo.png"),
	array("Elastic Stack", "elastic-stack-logo.png"),
	array("Puppet", "puppet-logo.png"),
	array("Saltstack", "salt-stack-logo.png"),
	array("Terraform", "terraform-logo.png")
	);
	$tool = rand(0,5);
?>
<html>
	<head>
		<title>Myriad of DevOps Tools</title>
	</head>
	<body style="background-color: #ffffff;">
		<div align="center">
			<h1>New tool every day, keeps the boss ... satisfied :)</h1>
			<br /><br /><br />
			<img width="800px" src="images/<?php echo $tools[$tool][1]; ?>" alt="<?php echo $tools[$tool][0]; ?>">
			<br /><br /><br />

			<?php
			require_once ('config.php');

			try {
				$connection = new PDO("mysql:host={$host};dbname={$database};charset=utf8", $user, $password);
				$query = $connection->query("INSERT INTO tools (tool) VALUES ('".$tools[$tool][0]."')");
				$query = $connection->query("SELECT COUNT(*) cnt, MAX(ts) mts FROM tools WHERE tool='".$tools[$tool][0]."'");
				$rows = $query->fetchAll();

				if (empty($rows)) {
					print "<h4>No data for ".$tools[$tool][0]."</h4>\n";
				} else {
					foreach ($rows as $row) {
						print "<h4>{$tools[$tool][0]} has been seen <b>{$row['cnt']}</b> time(s) so far.</h4>\n";
					}
				}
			}
			catch (PDOException $e) {
				print "<div align='center'>\n";
				print "No connetion to database. Try again later <a href=\"#\" onclick=\"document.getElementById('error').style = 'display: block;';\">Details</a><br/>\n";
				print "<span id='error' style='display: none;'><small><i>".$e->getMessage()." <a href=\"#\" onclick=\"document.getElementById('error').style = 'display: none;';\">Hide</a></i></small></span>\n";
				print "</div>\n";
			}
			?>
			<br />
			<h2>Refresh for more ...</h2>
			<br /><br /><br />
			<?php print "<small>Processed by <b>".gethostname()."</b> on ".date('Y-m-d-H-i-s')."</small>\n"; ?>
		</div>
	</body>
</html>
