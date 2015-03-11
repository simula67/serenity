#!/usr/bin/perl -w
use strict;
use lib 'lib';
use Serenity;
use Test::Simple tests => 3;
use File::Slurp;
my $serenity = Serenity->new();
(my $status_code, my $received_html) = $serenity->get_system_page_by_name( 'welcome' );
ok( 200 == $status_code , "Status code 200");
my $expected_html = <<'EOF';
<html>
	<head>
		<title>Welcome to the Wiki</title>
		<script src="/public/jquery/jquery-1.11.2.min.js"></script>
		<link rel="stylesheet" href="/public/bootstrap/bootstrap.min.css">
		<link rel="stylesheet" href="/public/bootstrap/bootstrap-theme.min.css">
		<script src="/public/bootstrap/bootstrap.min.js"></script>
	</head>
	<body>
		<nav class="navbar navbar-inverse navbar-fixed-top">
      		<div class="container">
          		<a class="navbar-brand" href="/">Serenity Wiki</a>
        	</div>
    	</nav>
    	
    	<div class="container" style="padding-top: 70px;">
      		<div class="starter-template">
        		<h1 >Welcome to the Wiki!!</h1>
        		<p class="lead">Here you can create and edit pages to your heart's content.</p>
        		<ul>
        			<li>Create pages by going to <a href=/create>/create</a></li>
					<li>View created pages by going to page/page_name</li>
				<ul>
      		</div>
    	</div>
	</body>
</html>
EOF
ok ($expected_html eq $received_html, "HTML received for welcome page");
my $create_page_name = "world_war_i";
my $create_page_type = "markdown";
my $create_page_content = "Also fought by brave dudes";
$serenity->create_page_for_name( $create_page_name, $create_page_type, $create_page_content );
my $read_content = read_file ("pages/md/content/$create_page_name.md") or die "Cannot open file $!";
ok( $read_content eq $create_page_content, "Comparing read page content for newly created page" );

