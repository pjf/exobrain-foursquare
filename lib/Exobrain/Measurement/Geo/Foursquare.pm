package Exobrain::Measurement::Geo::Foursquare;
use Moose;
use Method::Signatures;

with 'Exobrain::Measurement::Geo';

# ABSTRACT: Foursquare location measurement class
# VERSION

=head1 SYNOPSIS

    $exobrain->measure('Geo::Foursquare',
        checkin => $checkin
    );

=head1 DESCRIPTION

This class creatures a packet which consumes the L<Exobrain::Mesurement::Geo>
role from a Foursquare packet.

=cut

around BUILDARGS => func ($orig!, $class!, :$checkin?, ...) {

    if ($checkin) {

        # We have a checkin parameter. Auto-inflate that into our
        # pull packet. Note that we pass `@_` at the end, so any
        # caller-supplied additional parameters will override what's
        # in the packet.

        my $name = ( $checkin->{user}{firstName} // "" ) . " "
                 . ( $checkin->{user}{lastName } // "" );

        my $user = $checkin->{user}{id};

        return $class->orig(
            source    => 'Foursquare',
            timestamp => $checkin->{createdAt},
            is_me     =>  ($checkin->{user}{relationship} eq 'self'),
            user      => $user,
            user_name => $name,
            message   => $checkin->{shout} // "",
            poi       => {
                name  => $checkin->{venue}{name},
                id    => $checkin->{venue}{id},
                lat   => $checkin->{venue}{location}{lat},
                long  => $checkin->{venue}{location}{lng},
            },
            raw       => $checkin,
            @_,
        );
    }

    # Not an auto-inflating check-in, then...
    return $class->$orig(@_);
};

1;
