#!/usr/bin/perl

use Dancer2;
use serenity;

my $wiki_manager = serenity->new;
get '/page/:name' => sub {
	(my $status_code, my $content) =  $wiki_manager->get_content_page_by_name( params->{name} );
	status $status_code;
	return $content;
};

get '/' => sub {
	(my $status_code, my $content) = $wiki_manager->get_system_page_by_name( "welcome" );
	status $status_code;
	return $content;
};

get '/create' => sub {
	(my $status_code, my $content) = $wiki_manager->get_system_page_by_name( "create_page" );
        status $status_code;
        return $content;
};

post '/create' => sub {
	(my $status_code, my $content) = $wiki_manager->create_page_for_name( params->{pagename}, "markdown", params->{pagecontent} );
	status $status_code;
	print "$status_code , $content";
        return $content;
};

get '/*' => sub {
	(my $status_code, my $content) = $wiki_manager->get_system_page_by_name( "404" );
        status $status_code;
        return $content;
};
dance;
