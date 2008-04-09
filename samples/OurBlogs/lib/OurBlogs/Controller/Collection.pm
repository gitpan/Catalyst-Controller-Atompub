package # hide from PAUSE
    OurBlogs::Controller::Collection;

use strict;
use warnings;
use base qw(Catalyst::Controller::Atompub::Collection);

use HTTP::Status;
use NEXT;

sub auto :Private {
    my($self, $c) = @_;
    if (!$c->req->method eq 'GET' && !$c->req->method eq 'HEAD') {
        my $realm = $c->config->{authentication}{http}{realm};
        $c->authorization_required(realm => $realm);
        return $self->error($c, RC_FORBIDDEN)
            if $c->user->username ne $c->req->captures->[0];
    }
    $self->NEXT::auto($c);
}

sub default :LocalRegex('^(\w+)$') {
    my($self, $c) = @_;
    $self->NEXT::default($c);
}

sub edit_uri :LocalRegex('^(\w+)/([.\w]+)$') {
    my($self, $c) = @_;
    $self->NEXT::edit_uri($c);
}

sub make_collection_uri {
    my($self, $c) = @_;
    my $class = ref $self || $self;
    my $uri = $class->NEXT::make_collection_uri($c);
    $class->NEXT::make_collection_uri($c).'/'
        .(ref $c->controller eq $class ? $c->req->captures->[0] : $c->user->username);
}

sub get_feed :Atompub(list) {
    my($self, $c) = @_;
    my $feed = $self->collection_resource->body;
    my $rs = $c->model('DBIC::Entries')->search({
        uri => { like => $self->make_collection_uri($c).'%' },
    }, {
        order_by => 'edited desc',
    });
    while (my $entry_resource = $rs->next) {
        my $entry = XML::Atom::Entry->new(\$entry_resource->body);
        $feed->add_entry($entry);
    }
    1;
}

sub create_resource :Atompub(create) {
    my($self, $c) = @_;
    my $uri = $self->entry_resource->uri;
    my $edited = $self->edited->epoch;
    my $entry = $self->entry_resource->body;
    $c->model('DBIC::Entries')->create({
        edited => $edited,
        uri    => $uri,
        body   => $entry->as_xml,
    });
    1;
}

sub get_resource :Atompub(read) {
    my($self, $c) = @_;
    my $uri = $c->req->uri;
    my $rs = $c->model('DBIC::Entries')->find({ uri => $uri });
    my $entry = XML::Atom::Entry->new(\$rs->body);
    $self->entry_resource->body($entry);
    1;
}

sub update_entry :Atompub(update) {
    my($self, $c) = @_;
    my $uri = $c->req->uri;
    my $edited = $self->edited->epoch;
    my $entry = $self->entry_resource->body;
    $c->model('DBIC::Entries')->find({ uri => $uri })->update({
        uri => $uri,
        edited => $edited,
        body => $entry->as_xml,
    });
    1;
}

sub delete_entry :Atompub(delete) {
    my($self, $c) = @_;
    my $uri = $c->req->uri;
    $c->model('DBIC::Entries')->find({ uri => $uri })->delete;
    1;
}

1;
