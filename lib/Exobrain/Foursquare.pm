package Exobrain::Foursquare;
use Moose;
use Exobrain::Config;
use feature qw(say);

# ABSTRACT: Foursquare components for Exobrain
# VERSION

with 'Exobrain::Component';

my $FOURSQUARE_API = 'https://api.foursquare.com/v2';

sub component { "foursquare" };

sub services {
    return (
        source => 'Foursquare::Source',
    );
}

sub setup {

    # Load module and die swiftly on failure
    eval 'use WWW::Mechanize; 1;' or die $@;

    say "Welcome to the Exobrain::Foursquare setup process.";
    say "To complete setup, we'll need a valid FourSquare auth token";
    say "You can yoink this out of the API explorer at";
    say 'https://developer.foursquare.com/docs/explore';

    print "Auth token: ";
    chomp( my $token = <STDIN> );

    # Check to see if we auth okay.

    my $mech = WWW::Mechanize->new( autocheck => 1 );

    $mech->get("$FOURSQUARE_API/checkins/recent?oauth_token=$token&v=20130425");

    # TODO : Inspect content to ensure success
    
    say "\nThanks! Writing configuration...";

    my $config =
        "[Components]\n" .
        "Foursquare=$VERSION\n\n" .

        "[Foursquare]\n" .
        "auth_token = $token\n"
    ;

    my $filename = Exobrain::Config->write_config('Foursquare.ini', $config);

    say "\nConfig written to $filename. Have a nice day!";

    return;
}

1;

=for Pod::Coverage setup services component
