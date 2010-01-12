package Net::Prowl;

use Moose;
use LWP::UserAgent;
use URI::Escape;
use XML::Simple;

has 'debug' => (
    is        => 'rw',
    required  => 1,
    default   => sub { },
    predicate => 'is_debug',
);

has 'apikeys' => (
    is       => 'rw',
    required => 1,
    default  => sub { [] }
);

has 'app' => (
    is       => 'rw',
    required => 1,
    default  => sub { 'Net::Prowl' }
);

has 'prio' => (
    is       => 'rw',
    required => 1,
    default  => sub { 0 }
);

has 'event' => (
    is       => 'rw',
    required => 1,
    default  => sub { 'alert' }
);

has 'message' => (
    is       => 'rw',
    required => 1,
    default  => sub { '' }
);

has 'url' => (
    is       => 'ro',
    required => 1,
    default  => sub { 'https://prowl.weks.net/publicapi/' }
);

has 'err' => (
    is        => 'rw',
    predicate => 'has_err',
);

sub verify {
    my ( $self, $key ) = @_;
    my $path   = 'verify?apikey=' . $key;
    my $result = $self->_call($path);
    return $result;
}

sub add_key {
    my ( $self, $key ) = @_;
    if ( $self->verify($key) ) {
        push( @{ $self->apikeys }, $key );
    }
    else {
        warn $self->err;
    }
    return;
}

sub send {
    my $self = shift;
    my @req;
    if ( length $self->message > 10000 ) {
        $self->message( substr( $self->message, 0, 10000 ) );
    }
    if ( length $self->event > 1024 ) {
        $self->event( substr( $self->event, 0, 1024 ) );
    }
    push( @req, "apikey=" . join( ',', @{ $self->apikeys } ) );
    push( @req, "description=" . uri_escape( $self->message ) );
    push( @req, "event=" . uri_escape( $self->event ) );
    push( @req, "priority=" . $self->prio );
    push( @req, "application=" . uri_escape( $self->app ) );
    my $path = 'add?' . join( '&', @req );
    print STDERR "Request: $path\n";
    my $result = $self->_call($path);
    return $result;
}

sub _call {
    my ( $self, $path ) = @_;
    my $uri = $self->url . $path;
    print STDERR "URI: $uri\n" if $self->is_debug;

    my $req = HTTP::Request->new();
    $req->method('GET');
    $req->uri($uri);

    #$req->content( to_json($content) ) if ($content);

    my $ua  = LWP::UserAgent->new();
    my $res = $ua->request($req);
    print STDERR "Result: " . $res->decoded_content . "\n" if $self->is_debug;
    if ( $res->is_success ) {
        return XMLin( $res->decoded_content );
    }
    else {
        if ( my $_err = XMLin( $res->decoded_content ) ) {
            $self->err($_err);
        }
        else {
            $self->err( $res->status_line );
        }
    }
    return;
}

=head1 NAME

Net::Prowl - The great new Net::Prowl!

=head1 VERSION

Version 0.3

=cut

our $VERSION = '0.3';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::Prowl;

    my $foo = Net::Prowl->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Lenz Gschwendtner, C<< <norbu09 at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-prowl at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Prowl>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Prowl


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Prowl>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Prowl>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Prowl>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Prowl/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Lenz Gschwendtner.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of Net::Prowl
