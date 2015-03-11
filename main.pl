#!/usr/bin/perl

use lib 'lib';
use Dancer2;
use Serenity;

my $wiki_manager = Serenity->new;

sub set_status_and_return_content {
	status $_[0];
	$_[1];	
}

get '/page/:name' => sub {
	(my $status_code, my $content) =  $wiki_manager->get_content_page_by_name( params->{name} );
	set_status_and_return_content($status_code, $content);
};

get '/' => sub {
	(my $status_code, my $content) = $wiki_manager->get_system_page_by_name( "welcome" );
	set_status_and_return_content($status_code, $content);
};

get '/create' => sub {
	(my $status_code, my $content) = $wiki_manager->get_system_page_by_name( "create_page" );
    set_status_and_return_content($status_code, $content);
};

post '/create' => sub {
	my $page_name = params->{pagename};
	my $page_content = params->{pagecontent};
	(my $status_code, my $content) = $wiki_manager->create_page_for_name( $page_name, "markdown", $page_content );
	if( $status_code == 200) {
		redirect "/page/" . $page_name;
	} else {
		$wiki_manager->get_system_page_by_name( "500" );
	}
};

get qr{/public/(\S*)} => sub {
	(my $static_file_name) = splat;
    send_file $static_file_name;
};

get '/*' => sub {
	(my $status_code, my $content) = $wiki_manager->get_system_page_by_name( "404" );
     set_status_and_return_content($status_code, $content);
};


dance;
