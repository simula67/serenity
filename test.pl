#!/usr/bin/perl -w
use strict;

use serenity;
use Test::Simple tests => 3;
use File::Slurp;

my $serenity = serenity->new();
(my $status_code, my $received_html) = $serenity->get_system_page_by_name( 'welcome' );
ok( 200 == $status_code , "Status code 200");
my $expected_html = <<'EOF';
<html>
	<head>
		<title>Welcome to the Wiki</title>
	</head>
	<body>
		<p>Welcome to the Wiki!!</p>
		<p>Create pages by going to <a href=/create>/create</a></p>
		<p>View created pages by going to page/page_name</p>
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

