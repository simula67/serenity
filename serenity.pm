#!/usr/bin/perl
package serenity;
use Moose;
use File::Slurp;

sub get_page_by_name($$) {
	(my $this, my $type, my $page_name) = @_;
	die "\$type was undefined at get_page_by_name $!" unless $type;
	die "\$page_name was undefined at get_page_by_name $!" unless $page_name; 
	my $prefix = "";
	if( $type eq "system" ) {
		$prefix = "pages/html/system/";
	} elsif ( $type eq "content" ) {
		$prefix = "pages/html/content/";
	} else {
		die "Unknown type in get_page_by_name $!";
	}
	my $html_data = "";
	eval {
		$html_data = read_file( $prefix . $page_name . ".html" );
	};
	if ($@) {
		return $this->error_404();
	} else {
		return (200, $html_data);
	}
}

sub get_system_page_by_name {
	$_[0]->get_page_by_name( "system", $_[1] );
}

sub get_content_page_by_name {
	$_[0]->get_page_by_name( "content", $_[1] );	
}

sub error_404 {
	my @status_and_content = $_[0]->get_system_page_by_name( "404" );
	# Yes, overwrite status to 404
	$status_and_content[0] = 404;
	return @status_and_content;
}

sub create_page_for_name {
	(my $this, my $page_name, my $content_type, my $content ) = @_;
	open(OUTFILE, ">pages/md/content/$page_name.md") or die "Cannot open file $!";
	print OUTFILE $content;
	close OUTFILE;
	system("./Markdown.pl pages/md/content/$page_name.md > pages/html/content/$page_name.html");
	return ( 200, "Page successfully created" );
}
1;
